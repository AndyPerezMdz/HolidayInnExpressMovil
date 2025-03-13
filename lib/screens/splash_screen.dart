import 'package:flutter/material.dart';
// Removed unused imports:
// import 'package:provider/provider.dart';
// import '../providers/theme_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500), // Duración de la pulsación
      vsync: this,
    )..repeat(reverse: true); // Repetir la animación

    // Navegar a la pantalla de inicio de sesión después de la animación
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                isDarkMode
                    ? [const Color(0xFF0E1A26), const Color(0xFF1B2B39)]
                    : [const Color(0xFF1B2B39), const Color(0xFF0E1A26)],
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.1).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
            ),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1), // Desplazamiento hacia arriba
                end: Offset.zero,
              ).animate(_controller),
              child: Image.asset('assets/icon_logo.png', height: 100),
            ),
          ),
        ),
      ),
    );
  }
}
