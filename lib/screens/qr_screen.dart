import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  // Constantes de diseño
  static const Color primaryColor = Color.fromRGBO(35, 53, 103, 1);
  static const double borderRadius = 20.0;
  static const TextStyle titleStyle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    color: Colors.black54,
  );
  static const TextStyle timerStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.red,
  );
  static const TextStyle appBarTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  // Variables de estado
  String qrData = "https://example.com/employee/12345";
  late Timer _timer;
  int _timeLeft = 300;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _regenerateQR();
        }
      });
    });
  }

  void _regenerateQR() {
    setState(() {
      qrData =
          "https://example.com/employee/${DateTime.now().millisecondsSinceEpoch}";
      _timeLeft = 300;
    });
  }

  String _formatTime(int timeInSeconds) {
    final minutes = timeInSeconds ~/ 60;
    final seconds = (timeInSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Check in/out', style: appBarTitleStyle),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Código QR",
              textAlign: TextAlign.center,
              style: titleStyle,
            ),
            const SizedBox(height: 8),
            const Text(
              "Escanea este QR para hacer tu Check in/out",
              textAlign: TextAlign.center,
              style: subtitleStyle,
            ),
            const SizedBox(height: 20),

            Text(
              "Tiempo restante: ${_formatTime(_timeLeft)}",
              style: timerStyle,
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _regenerateQR,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: const Text(
                "Actualizar QR",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: QrImageView(
                data: qrData,
                size: 200,
                version: QrVersions.auto,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
