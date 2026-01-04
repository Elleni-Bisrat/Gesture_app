import 'dart:ui';
import 'package:flutter/material.dart';

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
          /// 🔹 Background Image (Camera Placeholder)
          Positioned.fill(
            // child: Image.network(
            //   "https://images.unsplash.com/photo-1515378791036-0648a3ef77b2",
            //   fit: BoxFit.cover,
            // ),
            child: Image.asset(
              'assets/images/holdPen.jpg',
              // width: double.infinity,
              // height: 160,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
