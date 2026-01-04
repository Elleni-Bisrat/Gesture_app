import 'package:flutter/material.dart';

class VoiceScreen extends StatelessWidget {
  const VoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const VocicescreenUi(),
    );
  }
}

class VocicescreenUi extends StatelessWidget {
  const VocicescreenUi({super.key});

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
            _navigationCard(),
            const SizedBox(height: 16),
            _listeningSection(),
            const SizedBox(height: 12),
            _bottomActions(),
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
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF6A3CFF),
            child: const Icon(Icons.graphic_eq, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          const Text(
            "Silent Talk",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          const Icon(Icons.text_fields, color: Colors.white),
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
      child: ListView(
        children: [
          _assistantMessage(
            "Hello! I'm listening. How can I help you today?",
            "10:32 AM",
          ),
          const SizedBox(height: 12),
          _userMessage(
            "I need directions to the nearest pharmacy.",
            "10:33 AM",
          ),
          const SizedBox(height: 12),
          _assistantMessage(
            "I found several nearby. The closest one is "
                "CVS Pharmacy on 4th Street. It's about a 5-minute walk.",
            "10:33 AM",
            highlight: "CVS Pharmacy",
          ),
        ],
      ),
    );
  }

  Widget _assistantMessage(String text, String time, {String? highlight}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Assistant  $time",
          style: const TextStyle(color: Colors.white38, fontSize: 11),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1C162C),
            borderRadius: BorderRadius.circular(14),
          ),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white, fontSize: 14),
              children: [
                if (highlight != null)
                  TextSpan(text: text.replaceAll(highlight, "")),
                if (highlight != null)
                  TextSpan(
                    text: highlight,
                    style: const TextStyle(
                      color: Color(0xFF6A3CFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _userMessage(String text, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "Me  $time",
          style: const TextStyle(color: Colors.white38, fontSize: 11),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
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
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 14,
              backgroundColor: const Color(0xFF1C162C),
              child: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _navigationCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.navigation),
              label: const Text("Start Navigation"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C162C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 6,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6A3CFF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listeningSection() {
    return Column(
      children: [
        const Text(
          "Listening...",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF6A3CFF), Color(0xFF4E2BD9)],
            ),
          ),
          child: const Icon(Icons.mic, color: Colors.white, size: 30),
        ),
      ],
    );
  }

  Widget _bottomActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Column(
            children: [
              Icon(Icons.keyboard, color: Colors.white),
              SizedBox(height: 4),
              Text(
                "TYPE",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          Column(
            children: [
              Icon(Icons.front_hand, color: Colors.white),
              SizedBox(height: 4),
              Text(
                "SIGN",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
