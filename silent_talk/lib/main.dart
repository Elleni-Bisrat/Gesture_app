import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:silent_talk/screens/splash_screen.dart';

final FlutterTts flutterTts = FlutterTts();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await flutterTts.setLanguage("en-US");
  await flutterTts.setSpeechRate(0.5);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Silent Talk',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF6A3CFF),
        scaffoldBackgroundColor: const Color(0xFF0B0715),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6A3CFF),
          brightness: Brightness.dark,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}