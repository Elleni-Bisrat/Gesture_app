// import 'package:flutter/material.dart';
// import 'package:silent_talk/screens/gesture_screen.dart';
// import 'package:silent_talk/screens/voice_screen.dart';
// import 'package:silent_talk/screens/settings_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0B0715),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         leading: const Icon(Icons.people, color: Colors.white),
//         title: const Text('SilentTalk', style: TextStyle(color: Colors.white)),
//       ),
//       body: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               const Text(
//                 'Welcome Back',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Break the silence. Choose a mode to start communicating instantly.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.white70),
//               ),
//               const SizedBox(height: 32),

//               // Sign → Voice Card
//               _buildModeCard(
//                 imagePath: 'assets/images/homeSignL.png',
//                 title: 'Sign → Voice',
//                 description: 'Translate sign language gestures to spoken words instantly using your camera.',
//                 buttonText: 'Start Camera',
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const GestureScreen()),
//                 ),
//               ),

//               const SizedBox(height: 24),

//               _buildModeCard(
//                 imagePath: 'assets/images/voice.png',
//                 title: 'Voice/Text → Text/Voice',
//                 description: 'Convert spoken words or typed text into sign language display.',
//                 buttonText: 'Start Listening',
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const VoiceScreen()),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         decoration: const BoxDecoration(color: Color(0xFF14112B)),
//         child: BottomNavigationBar(
//           currentIndex: _selectedIndex,
//           onTap: (index) {
//             setState(() => _selectedIndex = index);
//             if (index == 0) {
//             } else if (index == 1) {
//             } else if (index == 2) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const SettingsScreen()),
//               );
//             }
//           },
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           type: BottomNavigationBarType.fixed,
//           selectedItemColor: const Color(0xFF7B4CFF),
//           unselectedItemColor: Colors.grey,
//           selectedFontSize: 12,
//           unselectedFontSize: 12,
//           items: const [
//             BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
//             BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'History'),
//             BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildModeCard({
//     required String imagePath,
//     required String title,
//     required String description,
//     required String buttonText,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF161027),
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(15),
//                   topRight: Radius.circular(15),
//                 ),
//                 child: Image.asset(
//                   imagePath,
//                   width: double.infinity,
//                   height: 160,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Positioned(
//                 bottom: 10,
//                 left: 10,
//                 child: Row(
//                   children: const [
//                     Icon(Icons.videocam, size: 16, color: Colors.white),
//                     SizedBox(width: 5),
//                     Text('Camera Active', style: TextStyle(color: Colors.white, fontSize: 13)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const Icon(Icons.arrow_right_alt, color: Colors.deepPurpleAccent, size: 30),
//                   ],
//                 ),
//                 const SizedBox(height: 5),
//                 Text(description, style: const TextStyle(color: Colors.white70)),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: onTap,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepPurpleAccent,
//                     foregroundColor: Colors.white,
//                     minimumSize: const Size(double.infinity, 48),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                   ),
//                   child: Text(buttonText),
//                 ),
//                 const SizedBox(height: 15),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:silent_talk/screens/gesture_screen.dart';
import 'package:silent_talk/screens/voice_screen.dart';
import 'package:silent_talk/screens/settings_screen.dart';
import 'package:silent_talk/screens/conversation_screen.dart'; // Add this import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0715),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: const Icon(Icons.people, color: Colors.white),
        title: const Text('SilentTalk', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Welcome Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Break the silence. Choose a mode to start communicating instantly.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 32),

              // Sign → Voice Card
              _buildModeCard(
                imagePath: 'assets/images/homeSignL.png',
                title: 'Sign → Voice',
                description: 'Translate sign language gestures to spoken words instantly using your camera.',
                buttonText: 'Start Camera',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GestureScreen()),
                ),
              ),

              const SizedBox(height: 24),

              // Voice/Text → Sign Card
              _buildModeCard(
                imagePath: 'assets/images/voice.png',
                title: 'Voice/Text → Sign',
                description: 'Convert spoken words or typed text into sign language display.',
                buttonText: 'Start Listening',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VoiceScreen()),
                ),
              ),

              const SizedBox(height: 24),

              // Voice → Sign (Conversation) Card
              _buildConversationCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Color(0xFF14112B)),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() => _selectedIndex = index);
            if (index == 0) {
            } else if (index == 1) {
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            }
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF7B4CFF),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'History'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard({
    required String imagePath,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161027),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Row(
                  children: const [
                    Icon(Icons.videocam, size: 16, color: Colors.white),
                    SizedBox(width: 5),
                    Text('Camera Active', style: TextStyle(color: Colors.white, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.arrow_right_alt, color: Colors.deepPurpleAccent, size: 30),
                  ],
                ),
                const SizedBox(height: 5),
                Text(description, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(buttonText),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161027),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Container(
                  width: double.infinity,
                  height: 160,
                  color: const Color(0xFF2D1B69),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 60,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Real-time Conversation',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Row(
                  children: const [
                    Icon(Icons.mic, size: 16, color: Colors.white),
                    SizedBox(width: 5),
                    Text('Voice Active', style: TextStyle(color: Colors.white, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Two way conversation',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.arrow_right_alt, color: Colors.deepPurpleAccent, size: 30),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  'Two-way conversation: Speak and see sign language responses in real-time.',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ConversationScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Start Conversation'),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}