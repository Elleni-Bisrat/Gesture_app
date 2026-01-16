// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:flutter_tts/flutter_tts.dart';

// class ConversationScreen extends StatefulWidget {
//   const ConversationScreen({super.key});

//   @override
//   State<ConversationScreen> createState() => _ConversationScreenState();
// }

// class _ConversationScreenState extends State<ConversationScreen> {
//   final List<Map<String, String>> _messages = [
//     {"sender": "assistant", "text": "Hello! How can I help you today?"},
//     {"sender": "user", "text": "I need directions to the nearest pharmacy."},
//     {"sender": "assistant", "text": "Sure! The closest one is 5 minutes walk from here."},
//   ];

//   bool _isDetecting = false;
//   bool _isVideoActive = false;
//   bool _isMicActive = false;
  
//   final SpeechToText _speech = SpeechToText();
//   bool _speechAvailable = false;
//   bool _isListening = false;
  
//   final FlutterTts _tts = FlutterTts();

//   @override
//   void initState() {
//     super.initState();
//     _initSpeech();
//     _initTTS();
//   }

//   Future<void> _initSpeech() async {
//     _speechAvailable = await _speech.initialize(
//       onStatus: (status) {
//         debugPrint("Speech status: $status");
//         if (status == "done" || status == "notListening" || status == "listeningStopped") {
//           if (mounted) {
//             setState(() {
//               _isListening = false;
//               _isMicActive = false;
//             });
//           }
//         }
//       },
//       onError: (error) {
//         debugPrint("Speech error: $error");
//         if (mounted) {
//           setState(() {
//             _isListening = false;
//             _isMicActive = false;
//           });
//         }
//       },
//     );
//   }

//   Future<void> _initTTS() async {
//     await _tts.setLanguage("en-US");
//     await _tts.setSpeechRate(0.5);
//   }

//   Future<void> _startListening() async {
//     if (!_speechAvailable) {
//       debugPrint("Speech not available");
//       return;
//     }

//     setState(() {
//       _isListening = true;
//       _isMicActive = true;
//     });

//     await _speech.listen(
//       onResult: (result) {
//         if (result.finalResult && result.recognizedWords.isNotEmpty) {
//           _addUserMessage(result.recognizedWords);
//         }
//       },
//       listenFor: const Duration(seconds: 30),
//       pauseFor: const Duration(seconds: 3),
//     );
//   }

//   Future<void> _stopListening() async {
//     await _speech.stop();
//     setState(() {
//       _isListening = false;
//       _isMicActive = false;
//     });
//   }

//   void _addUserMessage(String text) {
//     if (text.trim().isEmpty) return;
    
//     setState(() {
//       _messages.add({"sender": "user", "text": text});
//     });
    
//     _simulateAssistantResponse(text);
//   }

//   Future<void> _simulateAssistantResponse(String userMessage) async {
//     await Future.delayed(const Duration(seconds: 1));
    
//     String response = _generateResponse(userMessage);
    
//     setState(() {
//       _messages.add({"sender": "assistant", "text": response});
//     });
    
//     await _tts.speak(response);
//   }

//   String _generateResponse(String userMessage) {
//     userMessage = userMessage.toLowerCase();
    
//     if (userMessage.contains('hello') || userMessage.contains('hi')) {
//       return "Hello there! Nice to meet you.";
//     } else if (userMessage.contains('how are you')) {
//       return "I'm doing well, thank you for asking! How can I assist you today?";
//     } else if (userMessage.contains('thank') || userMessage.contains('thanks')) {
//       return "You're welcome! Is there anything else I can help with?";
//     } else if (userMessage.contains('yes')) {
//       return "Great! What would you like to know?";
//     } else if (userMessage.contains('no')) {
//       return "Alright. Let me know if you need anything.";
//     } else if (userMessage.contains('pharmacy') || userMessage.contains('medicine')) {
//       return "The nearest pharmacy is about 10 minutes walk from here. It's open until 9 PM.";
//     } else if (userMessage.contains('time')) {
//       return "It's currently 3:30 PM. The pharmacy closes at 9 PM.";
//     } else if (userMessage.contains('name')) {
//       return "I'm your conversation assistant. You can call me Sarah.";
//     } else {
//       return "I understand you said: \"$userMessage\". How else can I assist you?";
//     }
//   }

//   void _showKeyboardInput() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: const Color(0xFF1C162C),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               "Type a message",
//               style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               autofocus: true,
//               style: const TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 hintText: "Enter your message...",
//                 hintStyle: const TextStyle(color: Colors.white54),
//                 filled: true,
//                 fillColor: const Color(0xFF0B0616),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//               ),
//               onSubmitted: (text) {
//                 if (text.trim().isNotEmpty) {
//                   _addUserMessage(text.trim());
//                   Navigator.pop(context);
//                 }
//               },
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => Navigator.pop(context),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.grey[800],
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     child: const Text("Cancel"),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       final textController = TextEditingController();
//                       if (textController.text.trim().isNotEmpty) {
//                         _addUserMessage(textController.text.trim());
//                         Navigator.pop(context);
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF6A3CFF),
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     child: const Text("Send"),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }

//   void _toggleVideo() {
//     setState(() {
//       _isVideoActive = !_isVideoActive;
//     });
    
//     if (_isVideoActive) {
//       _showToast("Video turned ON");
//     } else {
//       _showToast("Video turned OFF");
//     }
//   }

//   void _showToast(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: const Color(0xFF6A3CFF),
//         duration: const Duration(seconds: 1),
//       ),
//     );
//   }

//   void _stopConversation() {
//     _speech.stop();
//     _tts.stop();
//     setState(() {
//       _isDetecting = false;
//       _isVideoActive = false;
//       _isMicActive = false;
//       _isListening = false;
//     });
//     _showToast("Conversation stopped");
//   }

//   @override
//   void dispose() {
//     _speech.stop();
//     _tts.stop();
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
//             _statusChip(),
//             const SizedBox(height: 16),
//             Expanded(child: _chatArea()),
//             _quickReplies(),
//             const SizedBox(height: 12),
//             _bottomControls(),
//             const SizedBox(height: 8),
//             const Text(
//               "AI TRANSLATION ACTIVE",
//               style: TextStyle(
//                 color: Colors.white38,
//                 fontSize: 11,
//                 letterSpacing: 1,
//               ),
//             ),
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _topBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: const Icon(Icons.arrow_back, color: Colors.white),
//           ),
//           const SizedBox(width: 12),
//           const Text(
//             "Sarah",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(width: 6),
//           Container(
//             width: 8,
//             height: 8,
//             decoration: const BoxDecoration(
//               color: Colors.green,
//               shape: BoxShape.circle,
//             ),
//           ),
//           const SizedBox(width: 6),
//           const Text(
//             "CONNECTED • REAL-TIME",
//             style: TextStyle(color: Colors.white38, fontSize: 11),
//           ),
//           const Spacer(),
//           GestureDetector(
//             onTap: () {
//               _showToast("Accessibility settings");
//             },
//             child: const Icon(Icons.accessibility_new, color: Colors.white),
//           ),
//           const SizedBox(width: 16),
//           GestureDetector(
//             onTap: () {
//               showModalBottomSheet(
//                 context: context,
//                 backgroundColor: const Color(0xFF1C162C),
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                 ),
//                 builder: (context) => Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text(
//                         "More Options",
//                         style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 20),
//                       _buildMenuOption(Icons.settings, "Settings", () {
//                         Navigator.pop(context);
//                         _showToast("Opening settings");
//                       }),
//                       _buildMenuOption(Icons.history, "Conversation History", () {
//                         Navigator.pop(context);
//                         _showToast("Showing history");
//                       }),
//                       _buildMenuOption(Icons.volume_up, "Volume Control", () {
//                         Navigator.pop(context);
//                         _showToast("Adjusting volume");
//                       }),
//                       _buildMenuOption(Icons.help, "Help", () {
//                         Navigator.pop(context);
//                         _showToast("Opening help");
//                       }),
//                       const SizedBox(height: 10),
//                     ],
//                   ),
//                 ),
//               );
//             },
//             child: const Icon(Icons.more_vert, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMenuOption(IconData icon, String text, VoidCallback onTap) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.white),
//       title: Text(text, style: const TextStyle(color: Colors.white)),
//       onTap: onTap,
//     );
//   }

//   Widget _statusChip() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: const Text(
//         "Translation active",
//         style: TextStyle(color: Colors.white70, fontSize: 12),
//       ),
//     );
//   }

//   Widget _chatArea() {
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       itemCount: _messages.length,
//       itemBuilder: (context, index) {
//         final msg = _messages[index];
//         if (msg["sender"] == "assistant") {
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: _assistantBubble(msg["text"]!),
//           );
//         } else {
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: _userBubble(msg["text"]!),
//           );
//         }
//       },
//     );
//   }

//   Widget _assistantBubble(String text) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const CircleAvatar(
//           radius: 18,
//           backgroundColor: Color(0xFF6A3CFF),
//           child: Icon(Icons.person, color: Colors.white),
//         ),
//         const SizedBox(width: 10),
//         Container(
//           padding: const EdgeInsets.all(14),
//           constraints: const BoxConstraints(maxWidth: 240),
//           decoration: BoxDecoration(
//             color: const Color(0xFF1C162C),
//             borderRadius: BorderRadius.circular(14),
//           ),
//           child: Text(
//             text,
//             style: const TextStyle(color: Colors.white, fontSize: 14),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _userBubble(String text) {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         constraints: const BoxConstraints(maxWidth: 240),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFF6A3CFF), Color(0xFF4E2BD9)],
//           ),
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: Text(
//           text,
//           style: const TextStyle(color: Colors.white, fontSize: 14),
//         ),
//       ),
//     );
//   }

//   Widget _quickReplies() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "QUICK REPLY",
//             style: TextStyle(color: Colors.white38, fontSize: 11),
//           ),
//           const SizedBox(height: 8),
//           Wrap(
//             spacing: 8,
//             children: ["Yes", "No", "Thanks", "One moment"]
//                 .map(
//                   (e) => GestureDetector(
//                     onTap: () {
//                       _addUserMessage(e);
//                     },
//                     child: Chip(
//                       backgroundColor: const Color(0xFF1C162C),
//                       label: Text(e, style: const TextStyle(color: Colors.white)),
//                     ),
//                   ),
//                 )
//                 .toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _bottomControls() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 32),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: _showKeyboardInput,
//             child: _circleButton(Icons.keyboard),
//           ),
//           GestureDetector(
//             onTap: () {
//               if (_isListening) {
//                 _stopListening();
//               } else {
//                 _startListening();
//               }
//             },
//             child: _circleButton(Icons.mic, active: _isMicActive),
//           ),
//           GestureDetector(
//             onTap: _toggleVideo,
//             child: _circleButton(Icons.videocam, active: _isVideoActive),
//           ),
//           GestureDetector(
//             onTap: _stopConversation,
//             child: _circleButton(Icons.stop, danger: true),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _circleButton(IconData icon, {bool active = false, bool danger = false}) {
//     return Container(
//       width: 54,
//       height: 54,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: danger
//             ? Colors.red
//             : active
//                 ? const Color(0xFF6A3CFF)
//                 : const Color(0xFF1C162C),
//       ),
//       child: Icon(icon, color: Colors.white),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:silent_talk/screens/settings_screen.dart'; // Add this import
import 'package:silent_talk/screens/gesture_screen.dart'; // Add this import

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final List<Map<String, String>> _messages = [
    {"sender": "assistant", "text": "Hello! How can I help you today?"},
    {"sender": "user", "text": "I need directions to the nearest pharmacy."},
    {"sender": "assistant", "text": "Sure! The closest one is 5 minutes walk from here."},
  ];

  bool _isDetecting = false;
  bool _isVideoActive = false;
  bool _isMicActive = false;
  
  final SpeechToText _speech = SpeechToText();
  bool _speechAvailable = false;
  bool _isListening = false;
  
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initTTS();
  }

  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onStatus: (status) {
        debugPrint("Speech status: $status");
        if (status == "done" || status == "notListening" || status == "listeningStopped") {
          if (mounted) {
            setState(() {
              _isListening = false;
              _isMicActive = false;
            });
          }
        }
      },
      onError: (error) {
        debugPrint("Speech error: $error");
        if (mounted) {
          setState(() {
            _isListening = false;
            _isMicActive = false;
          });
        }
      },
    );
  }

  Future<void> _initTTS() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5);
  }

  Future<void> _startListening() async {
    if (!_speechAvailable) {
      debugPrint("Speech not available");
      return;
    }

    setState(() {
      _isListening = true;
      _isMicActive = true;
    });

    await _speech.listen(
      onResult: (result) {
        if (result.finalResult && result.recognizedWords.isNotEmpty) {
          _addUserMessage(result.recognizedWords);
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
    );
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() {
      _isListening = false;
      _isMicActive = false;
    });
  }

  void _addUserMessage(String text) {
    if (text.trim().isEmpty) return;
    
    setState(() {
      _messages.add({"sender": "user", "text": text});
    });
    
    _simulateAssistantResponse(text);
  }

  Future<void> _simulateAssistantResponse(String userMessage) async {
    await Future.delayed(const Duration(seconds: 1));
    
    String response = _generateResponse(userMessage);
    
    setState(() {
      _messages.add({"sender": "assistant", "text": response});
    });
    
    await _tts.speak(response);
  }

  String _generateResponse(String userMessage) {
    userMessage = userMessage.toLowerCase();
    
    if (userMessage.contains('hello') || userMessage.contains('hi')) {
      return "Hello there! Nice to meet you.";
    } else if (userMessage.contains('how are you')) {
      return "I'm doing well, thank you for asking! How can I assist you today?";
    } else if (userMessage.contains('thank') || userMessage.contains('thanks')) {
      return "You're welcome! Is there anything else I can help with?";
    } else if (userMessage.contains('yes')) {
      return "Great! What would you like to know?";
    } else if (userMessage.contains('no')) {
      return "Alright. Let me know if you need anything.";
    } else if (userMessage.contains('pharmacy') || userMessage.contains('medicine')) {
      return "The nearest pharmacy is about 10 minutes walk from here. It's open until 9 PM.";
    } else if (userMessage.contains('time')) {
      return "It's currently 3:30 PM. The pharmacy closes at 9 PM.";
    } else if (userMessage.contains('name')) {
      return "I'm your conversation assistant. You can call me Sarah.";
    } else {
      return "I understand you said: \"$userMessage\". How else can I assist you?";
    }
  }

  void _showKeyboardInput() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C162C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Type a message",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter your message...",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF0B0616),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onSubmitted: (text) {
                if (text.trim().isNotEmpty) {
                  _addUserMessage(text.trim());
                  Navigator.pop(context);
                }
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final textController = TextEditingController();
                      if (textController.text.trim().isNotEmpty) {
                        _addUserMessage(textController.text.trim());
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A3CFF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("Send"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _toggleVideo() {
    setState(() {
      _isVideoActive = !_isVideoActive;
    });
    
    if (_isVideoActive) {
      // Navigate to GestureScreen when video is turned ON
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const GestureScreen()),
      );
      _showToast("Video turned ON - Camera activated");
    } else {
      _showToast("Video turned OFF");
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF6A3CFF),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _stopConversation() {
    _speech.stop();
    _tts.stop();
    setState(() {
      _isDetecting = false;
      _isVideoActive = false;
      _isMicActive = false;
      _isListening = false;
    });
    _showToast("Conversation stopped");
  }

  @override
  void dispose() {
    _speech.stop();
    _tts.stop();
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
            _statusChip(),
            const SizedBox(height: 16),
            Expanded(child: _chatArea()),
            _quickReplies(),
            const SizedBox(height: 12),
            _bottomControls(),
            const SizedBox(height: 8),
            const Text(
              "AI TRANSLATION ACTIVE",
              style: TextStyle(
                color: Colors.white38,
                fontSize: 11,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Text(
            "Sarah",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            "CONNECTED • REAL-TIME",
            style: TextStyle(color: Colors.white38, fontSize: 11),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              _showToast("Accessibility settings");
            },
            child: const Icon(Icons.accessibility_new, color: Colors.white),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: const Color(0xFF1C162C),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "More Options",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      _buildMenuOption(Icons.settings, "Settings", () {
                        Navigator.pop(context); // Close the bottom sheet
                        // Navigate to SettingsScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SettingsScreen()),
                        );
                      }),
                      _buildMenuOption(Icons.history, "Conversation History", () {
                        Navigator.pop(context);
                        _showToast("Showing history");
                      }),
                      _buildMenuOption(Icons.volume_up, "Volume Control", () {
                        Navigator.pop(context);
                        _showToast("Adjusting volume");
                      }),
                      _buildMenuOption(Icons.help, "Help", () {
                        Navigator.pop(context);
                        _showToast("Opening help");
                      }),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
            child: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  Widget _statusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "Translation active",
        style: TextStyle(color: Colors.white70, fontSize: 12),
      )
    );
  }

  Widget _chatArea() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        if (msg["sender"] == "assistant") {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _assistantBubble(msg["text"]!),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _userBubble(msg["text"]!),
          );
        }
      },
    );
  }

  Widget _assistantBubble(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xFF6A3CFF),
          child: Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(14),
          constraints: const BoxConstraints(maxWidth: 240),
          decoration: BoxDecoration(
            color: const Color(0xFF1C162C),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _userBubble(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 240),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6A3CFF), Color(0xFF4E2BD9)],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  Widget _quickReplies() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "QUICK REPLY",
            style: TextStyle(color: Colors.white38, fontSize: 11),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ["Yes", "No", "Thanks", "One moment"]
                .map(
                  (e) => GestureDetector(
                    onTap: () {
                      _addUserMessage(e);
                    },
                    child: Chip(
                      backgroundColor: const Color(0xFF1C162C),
                      label: Text(e, style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _bottomControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _showKeyboardInput,
            child: _circleButton(Icons.keyboard),
          ),
          GestureDetector(
            onTap: () {
              if (_isListening) {
                _stopListening();
              } else {
                _startListening();
              }
            },
            child: _circleButton(Icons.mic, active: _isMicActive),
          ),
          GestureDetector(
            onTap: _toggleVideo,
            child: _circleButton(Icons.videocam, active: _isVideoActive),
          ),
          GestureDetector(
            onTap: _stopConversation,
            child: _circleButton(Icons.stop, danger: true),
          ),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, {bool active = false, bool danger = false}) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: danger
            ? Colors.red
            : active
                ? const Color(0xFF6A3CFF)
                : const Color(0xFF1C162C),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}