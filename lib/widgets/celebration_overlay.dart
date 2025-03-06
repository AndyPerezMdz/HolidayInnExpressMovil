import 'dart:math';
import 'package:flutter/material.dart';

class CelebrationOverlay extends StatefulWidget {
  final Widget child;
  final bool showCelebration;

  const CelebrationOverlay({
    super.key,
    required this.child,
    required this.showCelebration,
  });

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> particles = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addListener(() {
      _updateParticles();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CelebrationOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showCelebration && !oldWidget.showCelebration) {
      _startCelebration();
    }
  }

  void _startCelebration() {
    setState(() {
      particles = List.generate(50, (index) => _createParticle());
    });
    _controller.forward(from: 0);
  }

  Particle _createParticle() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final centerX = screenWidth / 2;
    final centerY = screenHeight / 2;

    return Particle(
      x: centerX,
      y: centerY,
      color: _getRandomColor(),
      size: random.nextDouble() * 8 + 4,
      velocity: Offset(
        (random.nextDouble() - 0.5) * 15,
        (random.nextDouble() - 0.5) * 15,
      ),
      angle: random.nextDouble() * pi * 2,
      angularVelocity: (random.nextDouble() - 0.5) * 0.3,
    );
  }

  Color _getRandomColor() {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ];
    return colors[random.nextInt(colors.length)];
  }

  void _updateParticles() {
    if (!mounted) return;
    setState(() {
      for (var particle in particles) {
        particle.update();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.showCelebration)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: ParticlePainter(particles)),
            ),
          ),
      ],
    );
  }
}

class Particle {
  double x;
  double y;
  final Color color;
  final double size;
  Offset velocity;
  double angle;
  final double angularVelocity;

  Particle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.velocity,
    required this.angle,
    required this.angularVelocity,
  });

  void update() {
    x += velocity.dx;
    y += velocity.dy;
    velocity = velocity.translate(0, 0.2); // Gravedad
    angle += angularVelocity;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint =
          Paint()
            ..color = particle.color
            ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(particle.x, particle.y);
      canvas.rotate(particle.angle);

      // Dibujar una forma más interesante para cada partícula
      final path =
          Path()
            ..moveTo(0, -particle.size / 2)
            ..lineTo(particle.size / 2, particle.size / 2)
            ..lineTo(-particle.size / 2, particle.size / 2)
            ..close();

      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
