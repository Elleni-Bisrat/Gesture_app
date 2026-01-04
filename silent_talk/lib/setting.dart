import 'package:flutter/material.dart';

class AccessibilityScreen extends StatelessWidget {
  const AccessibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0616),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _sectionTitle("COMMUNICATION PREFERENCES"),
                    _preferencesCard(),
                    const SizedBox(height: 20),
                    _sectionTitle("DISPLAY & TEXT"),
                    _displayCard(),
                    const SizedBox(height: 20),
                    _sectionTitle("AUDIO FEEDBACK"),
                    _audioCard(),
                    const SizedBox(height: 20),
                    _toggleTile(
                      "Offline Mode",
                      "Download translation packs for use without internet connection.",
                      false,
                    ),
                    _toggleTile(
                      "Haptic Feedback",
                      "Vibrate on translation success.",
                      true,
                    ),
                    _toggleTile(
                      "High Contrast",
                      "Increase visual distinction.",
                      false,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Silent Talk v2.4.0 (Build 302)",
                      style: TextStyle(color: Colors.white24, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
            _bottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: const [
          Icon(Icons.arrow_back, color: Colors.white),
          SizedBox(width: 12),
          Text(
            "Accessibility",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _preferencesCard() {
    return _card(
      Column(
        children: const [
          _prefTile(
            icon: Icons.pan_tool_alt,
            title: "Sign Language",
            subtitle: "American Sign Language (ASL)",
          ),
          Divider(color: Colors.white10),
          _prefTile(
            icon: Icons.record_voice_over,
            title: "Spoken Language",
            subtitle: "English (US)",
          ),
          Divider(color: Colors.white10),
          _prefTile(
            icon: Icons.graphic_eq,
            title: "Voice Output",
            subtitle: "Neutral (Natural)",
          ),
        ],
      ),
    );
  }

  Widget _displayCard() {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Hello, how are you today?",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 6),
          const Text(
            "Translating...",
            style: TextStyle(color: Color(0xFF6A3CFF), fontSize: 13),
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              Text("TT", style: TextStyle(color: Colors.white54)),
              Expanded(
                child: Slider(
                  value: 0.6,
                  onChanged: null,
                  activeColor: Color(0xFF6A3CFF),
                  inactiveColor: Colors.white24,
                ),
              ),
              Text("TT", style: TextStyle(color: Colors.white)),
            ],
          ),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              "110%",
              style: TextStyle(color: Color(0xFF6A3CFF)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _audioCard() {
    return _card(
      Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Voice Playback Speed",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Row(
            children: const [
              Icon(Icons.directions_walk, color: Colors.white54),
              Expanded(
                child: Slider(
                  value: 0.5,
                  onChanged: null,
                  activeColor: Color(0xFF6A3CFF),
                  inactiveColor: Colors.white24,
                ),
              ),
              Icon(Icons.directions_run, color: Colors.white),
            ],
          ),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              "1.0x",
              style: TextStyle(color: Color(0xFF6A3CFF)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleTile(String title, String subtitle, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SwitchListTile(
        value: value,
        onChanged: (_) {},
        activeColor: const Color(0xFF6A3CFF),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ),
    );
  }

  Widget _card(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C162C),
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }

  Widget _bottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF120C1F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _navItem(Icons.translate, "Translate", false),
          _navItem(Icons.history, "History", false),
          _navItem(Icons.settings, "Settings", true),
        ],
      ),
    );
  }
}


class _prefTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _prefTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFF6A3CFF).withOpacity(0.15),
          child: Icon(icon, color: const Color(0xFF6A3CFF)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
              Text(subtitle,
                  style:
                      const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.white38),
      ],
    );
  }
}

class _navItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _navItem(this.icon, this.label, this.active);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: active ? const Color(0xFF6A3CFF) : Colors.white38,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: active ? const Color(0xFF6A3CFF) : Colors.white38,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
