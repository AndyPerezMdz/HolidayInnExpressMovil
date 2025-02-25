import 'dart:math';
import 'package:flutter/material.dart';

class CelebrationOverlay extends StatefulWidget {
  final Widget child;
  final bool showCelebration;

  const CelebrationOverlay({
    super.key,
    required this.child,
    this.showCelebration = false,
  });

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(() {
      for (var particle in _particles) {
        particle.update();
      }
      setState(() {});
    });

    if (widget.showCelebration) {
      _startCelebration();
    }
  }

  @override
  void didUpdateWidget(CelebrationOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showCelebration && !oldWidget.showCelebration) {
      _startCelebration();
    }
  }

  void _startCelebration() {
    _particles.clear();
    for (int i = 0; i < 50; i++) {
      _particles.add(
        Particle(
          random: _random,
          screenSize: Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height,
          ),
        ),
      );
    }
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        widget.child,
        if (widget.showCelebration)
          LayoutBuilder(
            builder: (context, constraints) {
              return CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: ParticlePainter(
                  particles: _particles,
                  progress: _controller.value,
                  screenSize: Size(constraints.maxWidth, constraints.maxHeight),
                ),
              );
            },
          ),
      ],
    );
  }
}

class Particle {
  late double x;
  late double y;
  late Color color;
  late double speed;
  late double theta;
  late double radius;
  final Random random;
  final Size screenSize;

  Particle({required this.random, required this.screenSize}) {
    reset();
  }

  void reset() {
    x = screenSize.width / 2;
    y = screenSize.height / 2;
    color = Colors.primaries[random.nextInt(Colors.primaries.length)];
    speed = 1 + random.nextDouble() * 4;
    theta = random.nextDouble() * 2 * pi;
    radius = 2 + random.nextDouble() * 3;
  }

  void update() {
    x += speed * cos(theta);
    y += speed * sin(theta);
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  final Size screenSize;

  ParticlePainter({
    required this.particles,
    required this.progress,
    required this.screenSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint =
          Paint()
            ..color = particle.color.withOpacity(1 - progress)
            ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(particle.x, particle.y), particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
