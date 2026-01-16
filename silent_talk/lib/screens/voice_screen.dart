import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:silent_talk/main.dart';
import 'package:silent_talk/screens/home_screen.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  final TextEditingController _textController = TextEditingController();

  bool _isListening = false;
  bool _speechAvailable = false;
  String _lastWords = "";
  String _tempWords = "";
  List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      print("Initializing speech...");
      bool initialized = await _speech.initialize(
        onStatus: (status) {
          print("Speech status: $status");
          if (mounted) {
            setState(() {
              if (status == "listening") {
                _isListening = true;
              } else if (status == "notListening" || status == "done") {
                _isListening = false;
                if (_tempWords.isNotEmpty) {
                  _addMessage(_tempWords, sender: "Me");
                  _tempWords = "";
                }
              }
            });
          }
        },
        onError: (error) {
          print("Speech error: $error");
          if (mounted) {
            setState(() {
              _isListening = false;
            });
          }
        },
      );

      if (mounted) {
        setState(() {
          _speechAvailable = initialized;
        });
      }

      if (_speechAvailable) {
        print("Speech available");
        await _tts.setLanguage("en-US");
        await _tts.setSpeechRate(0.5);
      } else {
        print("Speech NOT available");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Speech recognition not available on this device"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print("Error initializing speech: $e");
      if (mounted) {
        setState(() {
          _speechAvailable = false;
        });
      }
    }
  }

  Future<void> _startListening() async {
    print("Start listening called");
    
    if (!_speechAvailable) {
      print("Speech not available");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Speech recognition not available"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_isListening) {
      await _stopListening();
      return;
    }

    try {
      setState(() {
        _isListening = true;
        _tempWords = "";
        _lastWords = "";
      });

      await _speech.listen(
        onResult: (result) {
          print("Speech result: ${result.recognizedWords}");
          if (mounted) {
            setState(() {
              if (result.finalResult) {
                _lastWords = result.recognizedWords;
                _tempWords = "";
                if (_lastWords.trim().isNotEmpty) {
                  _addMessage(_lastWords, sender: "Me");
                }
              } else {
                _tempWords = result.recognizedWords;
              }
            });
          }
        },
        listenFor: const Duration(seconds: 60),
        pauseFor: const Duration(seconds: 5),
        partialResults: true,
        localeId: "en_US",
        cancelOnError: true,
        listenMode: ListenMode.dictation,
        onSoundLevelChange: (level) {
          print("Sound level: $level");
        },
      );
      
      print("Listening started successfully");
    } catch (e) {
      print("Error in _startListening: $e");
      if (mounted) {
        setState(() {
          _isListening = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _stopListening() async {
    print("Stop listening called");
    try {
      await _speech.stop();
      if (mounted) {
        setState(() {
          _isListening = false;
          if (_tempWords.isNotEmpty) {
            _addMessage(_tempWords, sender: "Me");
            _tempWords = "";
          }
        });
      }
    } catch (e) {
      print("Error stopping: $e");
    }
  }

  Future<void> _speak(String text) async {
    try {
      await _tts.speak(text);
    } catch (e) {
      print("Error speaking: $e");
    }
  }

  Future<void> _addMessage(String text, {required String sender}) async {
    if (text.trim().isEmpty) return;

    print("Adding message: $text from $sender");
    
    setState(() {
      _messages.add({"sender": sender, "text": text});
    });

    if (sender == "Me") {
      await Future.delayed(const Duration(milliseconds: 500));
      
      String response = _generateResponse(text);
      
      setState(() {
        _messages.add({"sender": "Assistant", "text": response});
      });
      
      await _speak(response);
    }
  }

  String _generateResponse(String text) {
    text = text.toLowerCase();
    
    if (text.contains('hello') || text.contains('hi') || text.contains('hey')) {
      return "Hello! Nice to meet you. I'm your voice assistant.";
    } else if (text.contains('how are you')) {
      return "I'm doing great! Thanks for asking. How can I help you?";
    } else if (text.contains('thank you') || text.contains('thanks')) {
      return "You're welcome! Is there anything else I can help with?";
    } else if (text.contains('bye') || text.contains('goodbye')) {
      return "Goodbye! Have a wonderful day!";
    } else if (text.contains('name')) {
      return "I'm Silent Talk Assistant, here to help you communicate.";
    } else if (text.contains('help')) {
      return "I can convert your speech to text and respond to you. Just speak clearly into the microphone.";
    } else if (text.contains('weather')) {
      return "I'm not connected to weather services, but I hope you have a nice day!";
    } else if (text.contains('time')) {
      return "I can't tell the time, but I suggest checking your device clock.";
    } else {
      return "You said: '$text'. I understand you!";
    }
  }

  void _sendTextMessage() {
    String text = _textController.text.trim();
    if (text.isEmpty) return;
    
    print("Sending text message: $text");
    
    _textController.clear();
    _addMessage(text, sender: "Me");
  }

  void _clearTempText() {
    setState(() {
      _tempWords = "";
    });
  }

  void _clearAllMessages() {
    setState(() {
      _messages.clear();
      _tempWords = "";
      _lastWords = "";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("All messages cleared"),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    _tts.stop();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0616),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            const SizedBox(height: 10),
            _todayChip(),
            const SizedBox(height: 12),
            Expanded(child: _chatSection()),
            _listeningSection(),
            const SizedBox(height: 12),
            _keyboardInputSection(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFF6A3CFF),
            child: Icon(Icons.graphic_eq, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            child: const Text(
              "Silent Talk",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _clearAllMessages,
            child: const Icon(Icons.delete_outline, color: Colors.white),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.settings, color: Colors.white),
        ],
      ),
    );
  }

  Widget _todayChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "Today",
        style: TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }

  Widget _chatSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        reverse: true,
        itemCount: _messages.length + (_tempWords.isNotEmpty ? 1 : 0),
        itemBuilder: (context, index) {
          if (_tempWords.isNotEmpty && index == 0) {
            return _realTimeMessage(_tempWords, "Listening...");
          }
          
          int messageIndex = _tempWords.isNotEmpty ? index - 1 : index;
          if (_messages.isEmpty) {
            return Container();
          }
          final msg = _messages[_messages.length - 1 - messageIndex];
          
          if (msg["sender"] == "Me") {
            return _userMessage(msg["text"]!, "Now");
          } else {
            return _assistantMessage(msg["text"]!, "Now");
          }
        },
      ),
    );
  }

  Widget _realTimeMessage(String text, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Me  $time",
            style: const TextStyle(color: Colors.white38, fontSize: 11)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6A3CFF), Color(0xFF4E2BD9)],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              if (text.isNotEmpty)
                GestureDetector(
                  onTap: _clearTempText,
                  child: const Icon(Icons.close, color: Colors.white70, size: 16),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _assistantMessage(String text, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Assistant  $time",
            style: const TextStyle(color: Colors.white38, fontSize: 11)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1C162C),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _userMessage(String text, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("Me  $time",
            style: const TextStyle(color: Colors.white38, fontSize: 11)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6A3CFF), Color(0xFF4E2BD9)],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _listeningSection() {
    return Column(
      children: [
        Text(
          _isListening ? "Listening... Speak now!" : "Tap mic to speak",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _startListening,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _isListening
                ? const LinearGradient(
                    colors: [Colors.red, Color(0xFFD93434)],
                  )
                : const LinearGradient(
                    colors: [Color(0xFF6A3CFF), Color(0xFF4E2BD9)],
                  ),
              boxShadow: _isListening
                ? [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ]
                : [],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  _isListening ? Icons.stop : Icons.mic,
                  color: Colors.white,
                  size: 30,
                ),
                if (_isListening)
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (_isListening && _tempWords.isNotEmpty) ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Real-time: $_tempWords",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
        if (!_isListening && _lastWords.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            "Last heard: \"$_lastWords\"",
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _keyboardInputSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Type a message",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1C162C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  _sendTextMessage();
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendTextMessage,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF6A3CFF), Color(0xFF4E2BD9)],
                ),
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
