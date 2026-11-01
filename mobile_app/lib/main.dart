import 'package:flutter/material.dart';

void main() {
  runApp(const PrepMateApp());
}

class PrepMateApp extends StatelessWidget {
  const PrepMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PrepMate AI',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF1EEFF),
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8F6FF), Color(0xFFE9E2FF), Color(0xFFF1EEFF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 175,
                height: 175,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7651F5).withValues(alpha: 0.15),
                      blurRadius: 30,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(child: PrepMateLogo()),
              ),

              const SizedBox(height: 30),

              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'PrepMate ',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF21164D),
                      ),
                    ),
                    TextSpan(
                      text: 'AI',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7651F5),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Your AI-Powered Career Companion',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF625B7A),
                  letterSpacing: 0.3,
                ),
              ),

              const SizedBox(height: 55),

              const SizedBox(
                height: 28,
                width: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Color(0xFF7651F5),
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'Preparing your future...',
                style: TextStyle(fontSize: 13, color: Color(0xFF77708F)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrepMateLogo extends StatelessWidget {
  const PrepMateLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 145,
      height: 145,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) {
              return const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF9B6DFF), Color(0xFF4930C9)],
              ).createShader(bounds);
            },
            child: const Text(
              'P',
              style: TextStyle(
                fontSize: 112,
                fontWeight: FontWeight.w900,
                height: 1,
                color: Colors.white,
              ),
            ),
          ),

          const Positioned(
            top: 2,
            child: Icon(Icons.school, size: 46, color: Color(0xFF24136F)),
          ),

          Positioned.fill(child: CustomPaint(painter: LogoOrbitPainter())),

          const Positioned(
            right: 3,
            top: 32,
            child: Icon(Icons.auto_awesome, color: Color(0xFF7651F5), size: 23),
          ),
        ],
      ),
    );
  }
}

class LogoOrbitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7952E8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2 + 8),
      width: 125,
      height: 37,
    );

    canvas.drawArc(rect, 0.2, 2.7, false, paint);
  }

  @override
  bool shouldRepaint(covariant LogoOrbitPainter oldDelegate) {
    return false;
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1EEFF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 65,
                color: Color(0xFF7651F5),
              ),

              const SizedBox(height: 25),

              const Text(
                'Welcome to PrepMate AI!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF21164D),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Your journey towards your dream career starts here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Color(0xFF625B7A)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
