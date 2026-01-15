

import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

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
          const Icon(Icons.accessibility_new, color: Colors.white),
          const SizedBox(width: 16),
          const Icon(Icons.more_vert, color: Colors.white),
        ],
      ),
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
      ),
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
                      // Add message and speak
                      setState(() {
                        _messages.add({"sender": "user", "text": e});
                      });
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
          _circleButton(Icons.keyboard),
          _circleButton(Icons.mic, active: true),
          _circleButton(Icons.videocam),
          _circleButton(Icons.stop, danger: true),
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