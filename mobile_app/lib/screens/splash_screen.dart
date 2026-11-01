import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101426),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF6558E8),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.school_rounded,
                color: Colors.white,
                size: 55,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'PrepMate AI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your AI-Powered Career Companion',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 35),
            const CircularProgressIndicator(color: Color(0xFF8B80FF)),
          ],
        ),
      ),
    );
  }
}
