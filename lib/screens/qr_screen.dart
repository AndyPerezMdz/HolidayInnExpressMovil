import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  String qrData = "https://example.com/employee/12345"; // Código QR inicial
  late Timer _timer;
  int _timeLeft = 300; // 5 minutos en segundos (5 * 60)

  @override
  void initState() {
    super.initState();
    _startTimer(); // Inicia el temporizador
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Función para iniciar el temporizador
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _regenerateQR(); // Cuando el tiempo llega a 0, regenera el QR
      }
    });
  }

  // Función para regenerar el código QR
  void _regenerateQR() {
    setState(() {
      qrData = "https://example.com/employee/${DateTime.now().millisecondsSinceEpoch}";
      _timeLeft = 300; // Reinicia el tiempo a 5 minutos
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Quick Response.',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        automaticallyImplyLeading: false, // Oculta el botón de retroceso
      ),
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "QR Code",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),
            const Text(
              "Scan this code for check-in and check-out.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // Contador de tiempo restante
            Text(
              "Time left: ${_timeLeft ~/ 60}:${(_timeLeft % 60).toString().padLeft(2, '0')}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 10),

            // Botón para regenerar manualmente el código QR
            ElevatedButton(
              onPressed: _regenerateQR,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text("Refresh QR", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),

            // Código QR
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withValues(),
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

      // 🔹 Barra de navegación inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          }
          if (index == 2) {
            Navigator.pushNamed(context, '/reports');
          }
          if (index == 3) {
            Navigator.pushNamed(context, '/settings');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'QR Code'),
          BottomNavigationBarItem(icon: Icon(Icons.picture_as_pdf), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
