import 'package:ecommerce/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Add in pubspec.yaml

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Simulate delay then navigate to home or login
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // colors: [Color(0xFFFF512F), Color(0xFFDD2476)],
            // begin: Alignment.topCenter,
            // end: Alignment.bottomCenter,

             colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFFFFD700)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
            tileMode: TileMode.clamp,
            

          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/icons/jeelani-logo-full.png',
            width: 350,
          )
              .animate()
              .fadeIn(duration: 1.2.seconds)
              .scale(duration: 1.2.seconds, curve: Curves.easeOutBack),
        ),
      ),
    );
  }
}
