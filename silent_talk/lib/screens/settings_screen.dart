import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silent_talk/main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool offlineMode = false;
  bool hapticFeedback = true;
  bool highContrast = false;

  double textScale = 1.0;
  double speechRate = 0.5;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      offlineMode = prefs.getBool('offlineMode') ?? false;
      hapticFeedback = prefs.getBool('hapticFeedback') ?? true;
      highContrast = prefs.getBool('highContrast') ?? false;
      textScale = prefs.getDouble('textScale') ?? 1.0;
      speechRate = prefs.getDouble('speechRate') ?? 0.5;
    });
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _saveDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: highContrast ? Colors.black : const Color(0xFF0B0616),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("COMMUNICATION PREFERENCES"),
                    _preferencesCard(),
                    const SizedBox(height: 24),

                    _sectionTitle("DISPLAY & TEXT"),
                    _displayCard(),
                    const SizedBox(height: 24),

                    _sectionTitle("AUDIO FEEDBACK"),
                    _audioCard(),
                    const SizedBox(height: 24),

                    _toggleTile(
                      title: "Offline Mode",
                      subtitle: "Download translation packs for offline use.",
                      value: offlineMode,
                      onChanged: (v) {
                        setState(() => offlineMode = v);
                        _saveBool('offlineMode', v);
                      },
                    ),
                    _toggleTile(
                      title: "Haptic Feedback",
                      subtitle: "Vibrate on translation success.",
                      value: hapticFeedback,
                      onChanged: (v) {
                        setState(() => hapticFeedback = v);
                        _saveBool('hapticFeedback', v);
                      },
                    ),
                    _toggleTile(
                      title: "High Contrast",
                      subtitle: "Increase visual clarity for better readability.",
                      value: highContrast,
                      onChanged: (v) {
                        setState(() => highContrast = v);
                        _saveBool('highContrast', v);
                      },
                    ),

                    const SizedBox(height: 40),
                    Center(
                      child: Text(
                        "Silent Talk v1.0.0 (Build 100)",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Text(
            "Accessibility",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 13,
          letterSpacing: 1.1,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _preferencesCard() {
    return _card(
      Column(
        children: const [
          _PrefTile(
            icon: Icons.pan_tool_alt,
            title: "Sign Language",
            subtitle: "American Sign Language (ASL)",
          ),
          Divider(color: Colors.white10, height: 1),
          _PrefTile(
            icon: Icons.record_voice_over,
            title: "Spoken Language",
            subtitle: "English (US)",
          ),
          Divider(color: Colors.white10, height: 1),
          _PrefTile(
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
            "Text Size Preview",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Slider(
            value: textScale,
            min: 0.8,
            max: 1.5,
            divisions: 7,
            activeColor: const Color(0xFF6A3CFF),
            inactiveColor: Colors.white12,
            onChanged: (v) {
              setState(() => textScale = v);
              _saveDouble('textScale', v);
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${(textScale * 100).round()}%",
              style: const TextStyle(color: Color(0xFF6A3CFF), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _audioCard() {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Voice Playback Speed",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Slider(
            value: speechRate,
            min: 0.3,
            max: 1.0,
            divisions: 7,
            activeColor: const Color(0xFF6A3CFF),
            inactiveColor: Colors.white12,
            onChanged: (v) {
              setState(() => speechRate = v);
              _saveDouble('speechRate', v);
              flutterTts.setSpeechRate(v);
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${speechRate.toStringAsFixed(1)}×",
              style: const TextStyle(color: Color(0xFF6A3CFF), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF6A3CFF),
      activeTrackColor: const Color(0xFF6A3CFF).withOpacity(0.4),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 13)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  Widget _card(Widget child) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF120C1F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _NavItem(Icons.translate, "Translate", false),
          _NavItem(Icons.history, "History", false),
          _NavItem(Icons.settings, "Settings", true),
        ],
      ),
    );
  }
}


class _PrefTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _PrefTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF6A3CFF).withOpacity(0.15),
            child: Icon(icon, color: const Color(0xFF6A3CFF)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white38),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavItem(this.icon, this.label, this.active);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: active ? const Color(0xFF6A3CFF) : Colors.white38,
          size: 26,
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