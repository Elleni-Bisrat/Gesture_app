import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:silent_talk/home.dart';
import 'package:silent_talk/setting.dart';

class GestureApp extends StatelessWidget {
  const GestureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureScreen(),
    );
  }
}

class GestureScreen extends StatelessWidget {
  const GestureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            // child: Image.network(
            //   "https://images.unsplash.com/photo-1515378791036-0648a3ef77b2",
            //   fit: BoxFit.cover,
            // ),
            child: Image.asset(
              'assets/images/holdPen.jpg',
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.black.withOpacity(0.8)),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const SilentHome()),
                        );
                      },
                      child: _circleIcon(Icons.arrow_back_ios_new),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AccessibilityScreen(),
                          ),
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF6A3CFF).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 4,
                        backgroundColor: Color(0xFF6A3CFF),
                      ),
                      SizedBox(width: 6),
                      Text(
                        "LIVE",
                        style: TextStyle(
                          color: Color(0xFF6A3CFF),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 180,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  "✨ Detecting gestures...",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ),

          Positioned(
            top: 300,
            left: 40,
            right: 40,
            height: 260,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF6A3CFF), width: 2),
              ),
            ),
          ),

          Positioned(
            right: 30,
            bottom: 240,
            child: Row(
              children: [
                _floatingIcon(Icons.cameraswitch),
                SizedBox(width: 14),
                _floatingIcon(Icons.pause),
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
                    children: [
                      const Text(
                        "TRANSLATION",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 22),
                          children: [
                            TextSpan(
                              text: "Hello, how are ",
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: "you?",
                              style: TextStyle(
                                color: Color(0xFF6A3CFF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Confidence: 98%",
                        style: TextStyle(color: Colors.white54),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
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
                                    Icon(Icons.volume_up, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      "Speak",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
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
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.5),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  static Widget _floatingIcon(IconData icon) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.6),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  static Widget _smallButton(IconData icon) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
