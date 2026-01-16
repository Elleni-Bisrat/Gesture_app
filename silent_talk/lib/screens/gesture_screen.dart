import 'dart:async';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image/image.dart' as imglib;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:silent_talk/main.dart';
import 'package:silent_talk/screens/home_screen.dart';
import 'package:silent_talk/screens/settings_screen.dart';

class GestureScreen extends StatefulWidget {
  const GestureScreen({super.key});

  @override
  State<GestureScreen> createState() => _GestureScreenState();
}

class _GestureScreenState extends State<GestureScreen> {
  CameraController? _cameraController;
  tfl.Interpreter? _interpreter;
  bool _isDetecting = false;
  List<Map<String, dynamic>> _landmarks = [];
  String _statusText = "Tap to Detect Sign";
  String _previousGesture = "";
  int _stableCount = 0;
  bool _isLive = false;
  bool _isPaused = false;
  bool _usingFrontCamera = true;

  static const int _inputSize = 224;
  static const int _numLandmarks = 21;

  static const int THUMB_TIP = 4;
  static const int THUMB_IP = 3;
  static const int INDEX_TIP = 8;
  static const int INDEX_PIP = 6;
  static const int MIDDLE_TIP = 12;
  static const int MIDDLE_PIP = 10;
  static const int RING_TIP = 16;
  static const int RING_PIP = 14;
  static const int PINKY_TIP = 20;
  static const int PINKY_PIP = 18;

  String detectedGesture = "Tap the camera box to detect sign";
  int confidence = 0;

  imglib.Image _convertYUV420ToRgb(CameraImage image) {
    final width = image.width;
    final height = image.height;
    final yPlane = image.planes[0].bytes;
    final uPlane = image.planes[1].bytes;
    final vPlane = image.planes[2].bytes;

    final yStride = image.planes[0].bytesPerRow;
    final uvStride = image.planes[1].bytesPerRow;
    final uvPixelStride = image.planes[1].bytesPerPixel ?? 2;

    final rgbImage = imglib.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final uvRow = y ~/ 2;
        final uvCol = x ~/ 2;

        final yIndex = y * yStride + x;
        final uvIndex = uvRow * uvStride + uvCol * uvPixelStride;

        final yValue = yPlane[yIndex];
        final uValue = uPlane[uvIndex + 1] - 128;
        final vValue = vPlane[uvIndex] - 128;

        int r = (yValue + 1.370705 * vValue).clamp(0, 255).toInt();
        int g = (yValue - 0.698001 * vValue - 0.337633 * uValue)
            .clamp(0, 255)
            .toInt();
        int b = (yValue + 1.732446 * uValue).clamp(0, 255).toInt();

        rgbImage.setPixelRgb(x, y, r, g, b);
      }
    }
    return rgbImage;
  }

  List<List<List<List<double>>>> _preprocess(imglib.Image img) {
    final resized = imglib.copyResize(
      img,
      width: _inputSize,
      height: _inputSize,
      interpolation: imglib.Interpolation.linear,
    );

    final input = [
      List.generate(
        _inputSize,
        (y) => List.generate(
          _inputSize,
          (x) {
            final pixel = resized.getPixel(x, y);
            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          },
        ),
      )
    ];

    return input;
  }

  @override
  void initState() {
    super.initState();
    _initCamera();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter =
          await tfl.Interpreter.fromAsset('hand_landmark_full.tflite');
      debugPrint("Model loaded");
    } catch (e) {
      debugPrint("Model error: $e");
      if (mounted) setState(() => _statusText = "Error: Model not found");
    }
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras[0],
    );
    _cameraController = CameraController(front, ResolutionPreset.medium);
    await _cameraController!.initialize();
    if (mounted) setState(() {});
    _cameraController!.startImageStream(_processCameraImage);
  }

  void _processCameraImage(CameraImage image) async {
    if (!_isLive ||
        _isPaused ||
        _isDetecting ||
        _interpreter == null ||
        !mounted) return;
    _isDetecting = true;

    try {
      final rgb = _convertYUV420ToRgb(image);
      final input = _preprocess(rgb);

      var output = List.filled(1 * _numLandmarks * 3, 0.0)
          .reshape([1, _numLandmarks, 3]);
      _interpreter!.run(input, output);

      List<Map<String, dynamic>> newLm = [];
      for (int i = 0; i < _numLandmarks; i++) {
        double x = output[0][i][0] * image.width;
        double y = output[0][i][1] * image.height;
        double z = output[0][i][2];
        newLm.add({"x": x, "y": y, "z": z});
      }

      String gesture = _detectGesture(newLm);

      if (mounted) {
        setState(() {
          _landmarks = newLm;
          detectedGesture = gesture.isNotEmpty ? gesture : "Hand detected";
          confidence = gesture.isNotEmpty ? 85 + (_stableCount * 3) : 0;
          _statusText = detectedGesture;
        });

        if (gesture == "Thumb Up" && _previousGesture != "Thumb Up") {
          _stableCount++;
          if (_stableCount >= 4) {
            await flutterTts.speak("Thumb up detected");
            _stableCount = 0;
          }
        } else if (gesture != _previousGesture) {
          _stableCount = 0;
        }
        _previousGesture = gesture;
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      _isDetecting = false;
    }
  }

  String _detectGesture(List<Map<String, dynamic>> lm) {
    if (lm.length < _numLandmarks) return "";

    bool thumbExtended = lm[THUMB_TIP]["x"] < lm[THUMB_IP]["x"] - 10;
    bool othersCurled = lm[INDEX_TIP]["y"] > lm[INDEX_PIP]["y"] + 10 &&
        lm[MIDDLE_TIP]["y"] > lm[MIDDLE_PIP]["y"] + 10 &&
        lm[RING_TIP]["y"] > lm[RING_PIP]["y"] + 10 &&
        lm[PINKY_TIP]["y"] > lm[PINKY_PIP]["y"] + 10;

    return thumbExtended && othersCurled ? "Thumb Up" : "";
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_cameraController != null &&
              _cameraController!.value.isInitialized)
            Positioned.fill(child: CameraPreview(_cameraController!))
          else
            Positioned.fill(
              child:
                  Image.asset('assets/images/holdPen.jpg', fit: BoxFit.cover),
            ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: _isDetecting ? 6 : 3, sigmaY: _isDetecting ? 6 : 3),
              child: Container(
                  color: Colors.black.withOpacity(_isDetecting ? 0.8 : 0.4)),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      ),
                      child: _circleIcon(Icons.arrow_back_ios_new),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SettingsScreen()),
                        );
                      },
                      child: _circleIcon(Icons.settings),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  "Gesture Recognition",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => setState(() => _isLive = !_isLive),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6A3CFF).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor:
                              _isLive ? const Color(0xFF6A3CFF) : Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _isLive ? "LIVE" : "TAP TO DETECT",
                          style: TextStyle(
                            color:
                                _isLive ? const Color(0xFF6A3CFF) : Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 300,
            left: 40,
            right: 40,
            height: 260,
            child: GestureDetector(
              onTap: () {
                setState(() => _isLive = true);
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isDetecting
                            ? Colors.green
                            : const Color(0xFF6A3CFF),
                        width: _isDetecting ? 3 : 2,
                      ),
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isDetecting ? Icons.touch_app : Icons.camera_alt,
                            color: Colors.white,
                            size: 50,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _isDetecting
                                ? "Detecting..."
                                : "Tap to Detect Sign",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "(${_usingFrontCamera ? "Front" : "Back"} Camera)",
                            style: const TextStyle(color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isDetecting)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.green.withOpacity(0.1),
                        ),
                        child: const Center(
                          child: Icon(Icons.handshake,
                              color: Colors.green, size: 60),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: 240,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() => _usingFrontCamera = !_usingFrontCamera);
                    // You can add camera switch logic here later if needed
                  },
                  child: _floatingIcon(Icons.cameraswitch),
                ),
                const SizedBox(width: 14),
                GestureDetector(
                  onTap: () => setState(() => _isPaused = !_isPaused),
                  child:
                      _floatingIcon(_isPaused ? Icons.play_arrow : Icons.pause),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "TRANSLATION",
                        style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                            letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        detectedGesture,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Confidence: $confidence%",
                        style: TextStyle(
                            color: confidence > 70
                                ? Colors.green
                                : Colors.white54),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => flutterTts.speak(detectedGesture),
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6A3CFF),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.volume_up,
                                          color: Colors.white),
                                      SizedBox(width: 8),
                                      Text("Speak",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          _smallButton(Icons.share),
                          const SizedBox(width: 12),
                          _smallButton(Icons.bookmark),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _circleIcon(IconData icon) {
    return Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Colors.black.withOpacity(0.5)),
      child: Icon(icon, color: Colors.white),
    );
  }

  static Widget _floatingIcon(IconData icon) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Colors.black.withOpacity(0.6)),
      child: Icon(icon, color: Colors.white),
    );
  }

  static Widget _smallButton(IconData icon) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14)),
      child: Icon(icon, color: Colors.white),
    );
  }
}
