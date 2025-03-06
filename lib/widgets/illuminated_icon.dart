import 'package:flutter/material.dart';

class IlluminatedIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? lightModeColor;
  final Color? darkModeColor;

  const IlluminatedIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.lightModeColor,
    this.darkModeColor,
  });

  static const Color primaryColor = Color.fromRGBO(35, 53, 103, 1);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final effectiveDarkModeColor = darkModeColor ?? Colors.white;

    return Icon(
      icon,
      size: size,
      color:
          isDarkMode ? effectiveDarkModeColor : lightModeColor ?? primaryColor,
    );
  }
}
