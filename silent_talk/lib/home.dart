import 'package:flutter/material.dart';
import 'gesture_screen.dart';
import 'voice_screen.dart';

void main() {
  runApp(const SilentTalk());
}

class SilentTalk extends StatelessWidget {
  const SilentTalk({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SilentHome(),
    );
  }
}

class SilentHome extends StatefulWidget {
  const SilentHome({super.key});

  @override
  State<SilentHome> createState() => _SilentHomeState();
}

class _SilentHomeState extends State<SilentHome> {
  int selectedIndex = 0;
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
          padding: EdgeInsets.all(20),
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

              const SizedBox(height: 20),

              // SIGN -> VOICE
              Container(
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
                            'assets/images/homeSignL.png',
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
                              Icon(
                                Icons.videocam,
                                size: 16,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Camera Active',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Sign -> Voice',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.arrow_right_alt,
                                color: Colors.deepPurpleAccent,
                                size: 30,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          const Text(
                            'Translate sign language gestures to spoken words instantly using your camera.',
                            style: TextStyle(color: Colors.white70),
                          ),

                          SizedBox(height: 15),

                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GestureScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 110,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Start Camera'),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              //voice to sign
              Container(
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
                            'assets/images/voice.png',
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
                              Icon(Icons.mic, size: 16, color: Colors.white),
                              SizedBox(width: 5),
                              Text(
                                'Microphone Ready',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Voice/Text -> Sign',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.arrow_right_alt,
                                color: Colors.deepPurpleAccent,
                                size: 30,
                              ),
                            ],
                          ),

                          SizedBox(height: 5),

                          const Text(
                            'Translate sign language gestures to spoken words instantly using your camera.',
                            style: TextStyle(color: Colors.white70),
                          ),

                          SizedBox(height: 15),

                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const VoiceScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 100,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Start Listening'),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Color(0xFF14112B)),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SilentHome()),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VoiceScreen()),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VoiceScreen()),
              );
            }
          },

          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,

          selectedItemColor: Color(0xFF7B4CFF),
          unselectedItemColor: Colors.grey,

          selectedFontSize: 12,
          unselectedFontSize: 12,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
