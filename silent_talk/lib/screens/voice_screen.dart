// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:silent_talk/main.dart';
// import 'package:silent_talk/screens/home_screen.dart';

// class VoiceScreen extends StatefulWidget {
//   const VoiceScreen({super.key});

//   @override
//   State<VoiceScreen> createState() => _VoiceScreenState();
// }

// class _VoiceScreenState extends State<VoiceScreen> {
//   final SpeechToText _speech = SpeechToText();
//   final FlutterTts _tts = FlutterTts();
//   final TextEditingController _textController = TextEditingController();

//   bool _isListening = false;
//   bool _speechAvailable = false; // Track if speech is available
//   String _lastWords = "";
//   String _tempWords = ""; // For real-time partial results
//   List<Map<String, String>> _messages = [];

//   @override
//   void initState() {
//     super.initState();
//     _initSpeech();
//   }

//   Future<void> _initSpeech() async {
//     try {
//       _speechAvailable = await _speech.initialize(
//         onStatus: (status) {
//           debugPrint("Speech status: $status");
//           if (status == "done" || status == "notListening" || status == "listeningStopped") {
//             if (mounted) {
//               setState(() {
//                 _isListening = false;
//                 _tempWords = "";
//               });
//             }
//           } else if (status == "listening") {
//             if (mounted) {
//               setState(() {
//                 _isListening = true;
//               });
//             }
//           }
//         },
//         onError: (error) {
//           debugPrint("Speech error: $error");
//           if (mounted) {
//             setState(() {
//               _isListening = false;
//               _tempWords = "";
//             });
//           }
//         },
//       );

//       if (_speechAvailable) {
//         await _tts.setLanguage("en-US");
//         await _tts.setSpeechRate(0.5);
//       } else {
//         debugPrint("Speech recognition not available");
//       }
//     } catch (e) {
//       debugPrint("Error initializing speech: $e");
//       _speechAvailable = false;
//     }
//   }

//   Future<void> _startListening() async {
//     if (_isListening) {
//       await _stopListening();
//       return;
//     }

//     if (!_speechAvailable) {
//       debugPrint("Speech not available");
//       // Show a snackbar or dialog to inform the user
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Speech recognition is not available on this device"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     setState(() {
//       _isListening = true;
//       _tempWords = "";
//       _lastWords = "";
//     });

//     try {
//       await _speech.listen(
//         onResult: (result) {
//           if (mounted) {
//             setState(() {
//               if (result.finalResult) {
//                 // Final result - complete recognition
//                 _lastWords = result.recognizedWords;
//                 _tempWords = "";
//               } else {
//                 // Partial result - real-time feedback
//                 _tempWords = result.recognizedWords;
//               }
//             });

//             // When we have a final result, add it to messages
//             if (result.finalResult && _lastWords.isNotEmpty) {
//               Future.delayed(Duration.zero, () {
//                 _addMessage(_lastWords, sender: "Me");
//               });
//             }
//           }
//         },
//         listenFor: const Duration(seconds: 30),
//         pauseFor: const Duration(seconds: 3),
//         partialResults: true, // Enable partial results for real-time feedback
//         listenMode: ListenMode.confirmation,
//       );
//     } catch (e) {
//       debugPrint("Error starting listening: $e");
//       setState(() {
//         _isListening = false;
//         _tempWords = "";
//       });
//     }
//   }

//   Future<void> _stopListening() async {
//     try {
//       await _speech.stop();
//       // Don't set _isListening to false here - wait for the status callback
//     } catch (e) {
//       debugPrint("Error stopping listening: $e");
//       if (mounted) {
//         setState(() {
//           _isListening = false;
//           _tempWords = "";
//         });
//       }
//     }
//   }

//   Future<void> _speak(String text) async {
//     await _tts.speak(text);
//   }

//   Future<void> _addMessage(String text, {required String sender}) async {
//     if (text.trim().isEmpty) return;

//     setState(() {
//       _messages.add({"sender": sender, "text": text});
//     });

//     if (sender == "Me") {
//       await Future.delayed(const Duration(milliseconds: 800));
//       String reply = "You said: $text";
//       setState(() {
//         _messages.add({"sender": "Assistant", "text": reply});
//       });
//       await _speak(reply);
//     }
//   }

//   void _sendTextMessage() {
//     String text = _textController.text.trim();
//     if (text.isEmpty) return;
//     _textController.clear();
//     _addMessage(text, sender: "Me");
//   }

//   void _clearTempText() {
//     setState(() {
//       _tempWords = "";
//     });
//   }

//   @override
//   void dispose() {
//     _speech.stop();
//     _tts.stop();
//     _textController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0B0616),
//       body: SafeArea(
//         child: Column(
//           children: [
//             _topBar(),
//             const SizedBox(height: 10),
//             _todayChip(),
//             const SizedBox(height: 12),
//             Expanded(child: _chatSection()),
//             _listeningSection(),
//             const SizedBox(height: 12),
//             _keyboardInputSection(),
//             const SizedBox(height: 12),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _topBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         children: [
//           const CircleAvatar(
//             radius: 16,
//             backgroundColor: Color(0xFF6A3CFF),
//             child: Icon(Icons.graphic_eq, color: Colors.white, size: 18),
//           ),
//           const SizedBox(width: 10),
//           GestureDetector(
//             onTap: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const HomeScreen()),
//               );
//             },
//             child: const Text(
//               "Silent Talk",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//           ),
//           const Spacer(),
//           const Icon(Icons.settings, color: Colors.white),
//         ],
//       ),
//     );
//   }

//   Widget _todayChip() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: const Text(
//         "Today",
//         style: TextStyle(color: Colors.white70, fontSize: 12),
//       ),
//     );
//   }

//   Widget _chatSection() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: ListView.builder(
//         reverse: true,
//         itemCount: _messages.length + (_tempWords.isNotEmpty ? 1 : 0),
//         itemBuilder: (context, index) {
//           // If we're showing real-time text and this is the first (reversed) item
//           if (_tempWords.isNotEmpty && index == 0) {
//             return _realTimeMessage(_tempWords, "Listening...");
//           }
          
//           // Adjust index for messages list if we're showing real-time text
//           int messageIndex = _tempWords.isNotEmpty ? index - 1 : index;
//           final msg = _messages[_messages.length - 1 - messageIndex];
          
//           if (msg["sender"] == "Me") {
//             return _userMessage(msg["text"]!, "Now");
//           } else {
//             return _assistantMessage(msg["text"]!, "Now");
//           }
//         },
//       ),
//     );
//   }

//   Widget _realTimeMessage(String text, String time) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Me  $time",
//             style: const TextStyle(color: Colors.white38, fontSize: 11)),
//         const SizedBox(height: 6),
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Color(0xFF6A3CFF), Color(0xFF4E2BD9)],
//             ),
//             borderRadius: BorderRadius.circular(14),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   text,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontStyle: FontStyle.italic,
//                   ),
//                 ),
//               ),
//               if (text.isNotEmpty)
//                 GestureDetector(
//                   onTap: _clearTempText,
//                   child: const Icon(Icons.close, color: Colors.white70, size: 16),
//                 ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 12),
//       ],
//     );
//   }

//   Widget _assistantMessage(String text, String time) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Assistant  $time",
//             style: const TextStyle(color: Colors.white38, fontSize: 11)),
//         const SizedBox(height: 6),
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: const Color(0xFF1C162C),
//             borderRadius: BorderRadius.circular(14),
//           ),
//           child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
//         ),
//         const SizedBox(height: 12),
//       ],
//     );
//   }

//   Widget _userMessage(String text, String time) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Text("Me  $time",
//             style: const TextStyle(color: Colors.white38, fontSize: 11)),
//         const SizedBox(height: 6),
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Color(0xFF6A3CFF), Color(0xFF4E2BD9)],
//             ),
//             borderRadius: BorderRadius.circular(14),
//           ),
//           child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
//         ),
//         const SizedBox(height: 12),
//       ],
//     );
//   }

//   Widget _listeningSection() {
//     return Column(
//       children: [
//         Text(
//           _isListening ? "Listening... Speak now" : "Tap mic to speak",
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 12),
//         GestureDetector(
//           onTap: _startListening,
//           child: Container(
//             width: 64,
//             height: 64,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: _isListening
//                 ? const LinearGradient(
//                     colors: [Colors.red, Color(0xFFD93434)],
//                   )
//                 : const LinearGradient(
//                     colors: [Color(0xFF6A3CFF), Color(0xFF4E2BD9)],
//                   ),
//             ),
//             child: Icon(
//               _isListening ? Icons.stop : Icons.mic,
//               color: Colors.white,
//               size: 30,
//             ),
//           ),
//         ),
//         if (_isListening && _tempWords.isNotEmpty) ...[
//           const SizedBox(height: 12),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Text(
//               "Real-time: $_tempWords",
//               style: const TextStyle(
//                 color: Colors.white70,
//                 fontSize: 14,
//                 fontStyle: FontStyle.italic,
//               ),
//               textAlign: TextAlign.center,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ],
//     );
//   }

//   Widget _keyboardInputSection() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _textController,
//               style: const TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 hintText: "Type a message",
//                 hintStyle: const TextStyle(color: Colors.white54),
//                 filled: true,
//                 fillColor: const Color(0xFF1C162C),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           GestureDetector(
//             onTap: _sendTextMessage,
//             child: Container(
//               padding: const EdgeInsets.all(14),
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: LinearGradient(
//                   colors: [Color(0xFF6A3CFF), Color(0xFF4E2BD9)],
//                 ),
//               ),
//               child: const Icon(Icons.send, color: Colors.white, size: 24),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
      _speechAvailable = await _speech.initialize(
        onStatus: (status) {
          debugPrint("Speech status: $status");
          if (status == "done" || status == "notListening" || status == "listeningStopped") {
            if (mounted) {
              setState(() {
                _isListening = false;
                _tempWords = "";
              });
            }
          } else if (status == "listening") {
            if (mounted) {
              setState(() {
                _isListening = true;
              });
            }
          }
        },
        onError: (error) {
          debugPrint("Speech error: $error");
          if (mounted) {
            setState(() {
              _isListening = false;
              _tempWords = "";
            });
          }
        },
      );

      if (_speechAvailable) {
        await _tts.setLanguage("en-US");
        await _tts.setSpeechRate(0.5);
        await _tts.setPitch(1.0);
        await _tts.setVolume(1.0);
      } else {
        debugPrint("Speech recognition not available");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Speech recognition is not available on this device"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error initializing speech: $e");
      _speechAvailable = false;
    }
  }

  Future<void> _startListening() async {
    if (_isListening) {
      await _stopListening();
      return;
    }

    if (!_speechAvailable) {
      debugPrint("Speech not available");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Speech recognition is not available on this device"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isListening = true;
      _tempWords = "";
      _lastWords = "";
    });

    try {
      await _speech.listen(
        onResult: (result) {
          if (mounted) {
            setState(() {
              if (result.finalResult) {
                _lastWords = result.recognizedWords;
                _tempWords = "";
                
                // Add the final result to messages immediately
                if (_lastWords.trim().isNotEmpty) {
                  _addMessage(_lastWords, sender: "Me");
                }
              } else {
                _tempWords = result.recognizedWords;
              }
            });
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        listenMode: ListenMode.confirmation,
        localeId: "en_US",
        cancelOnError: true,
        listenOptions: SpeechListenOptions(partialResults: true),
      );
    } catch (e) {
      debugPrint("Error starting listening: $e");
      setState(() {
        _isListening = false;
        _tempWords = "";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _stopListening() async {
    try {
      await _speech.stop();
      // Show a toast that listening stopped
      if (_isListening) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Listening stopped"),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error stopping listening: $e");
      if (mounted) {
        setState(() {
          _isListening = false;
          _tempWords = "";
        });
      }
    }
  }

  Future<void> _speak(String text) async {
    try {
      await _tts.speak(text);
      await _tts.awaitSpeakCompletion(true);
    } catch (e) {
      debugPrint("Error speaking: $e");
    }
  }

  Future<void> _addMessage(String text, {required String sender}) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({"sender": sender, "text": text});
    });

    if (sender == "Me") {
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Generate a response based on what was said
      String reply = _generateResponse(text);
      
      setState(() {
        _messages.add({"sender": "Assistant", "text": reply});
      });
      
      await _speak(reply);
    }
  }

  String _generateResponse(String userMessage) {
    String lowerMessage = userMessage.toLowerCase().trim();
    
    if (lowerMessage.contains('hello') || lowerMessage.contains('hi') || lowerMessage.contains('hey')) {
      return "Hello! How can I assist you today?";
    } else if (lowerMessage.contains('how are you')) {
      return "I'm doing well, thank you for asking! How can I help you?";
    } else if (lowerMessage.contains('thank you') || lowerMessage.contains('thanks')) {
      return "You're welcome! Is there anything else I can help with?";
    } else if (lowerMessage.contains('goodbye') || lowerMessage.contains('bye')) {
      return "Goodbye! Have a great day!";
    } else if (lowerMessage.contains('name')) {
      return "I'm your Silent Talk assistant. I help convert speech to sign language.";
    } else if (lowerMessage.contains('help')) {
      return "I can help you convert your speech to sign language. Just speak and I'll translate!";
    } else if (lowerMessage.contains('weather')) {
      return "I'm not connected to weather services, but I hope it's nice outside!";
    } else if (lowerMessage.contains('time')) {
      return "I don't have access to the current time, but you can check your device clock.";
    } else {
      return "You said: \"$userMessage\". I can help translate this to sign language.";
    }
  }

  void _sendTextMessage() {
    String text = _textController.text.trim();
    if (text.isEmpty) return;
    
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
        duration: Duration(seconds: 1),
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
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Settings"),
                  backgroundColor: Colors.blue,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: const Icon(Icons.settings, color: Colors.white),
          ),
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
          _isListening ? "Listening... Speak now" : "Tap mic to speak",
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
            ),
            child: Icon(
              _isListening ? Icons.stop : Icons.mic,
              color: Colors.white,
              size: 30,
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
                color: Colors.white70,
                fontSize: 14,
                fontStyle: FontStyle.italic,
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
            "Last heard: $_lastWords",
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
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