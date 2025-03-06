import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ParallaxBox extends StatefulWidget {
  final Widget child;
  final double depth;

  const ParallaxBox({super.key, required this.child, this.depth = 0.5});

  @override
  State<ParallaxBox> createState() => _ParallaxBoxState();
}

class _ParallaxBoxState extends State<ParallaxBox> {
  double _offsetX = 0;
  double _offsetY = 0;

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _offsetX += details.delta.dx * widget.depth;
      _offsetY += details.delta.dy * widget.depth;

      // Limitar el movimiento
      _offsetX = _offsetX.clamp(-20.0, 20.0);
      _offsetY = _offsetY.clamp(-20.0, 20.0);
    });
    HapticFeedback.selectionClick();
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _offsetX = 0;
      _offsetY = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform:
            Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(_offsetY * 0.01)
              ..rotateY(-_offsetX * 0.01),
        child: widget.child,
      ),
    );
  }
}
