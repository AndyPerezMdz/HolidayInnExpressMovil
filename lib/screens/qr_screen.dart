import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          themeProvider.getText('qr_code'),
          style: appBarTitleStyle.copyWith(
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  themeProvider.getText('scan_qr'),
                  textAlign: TextAlign.center,
                  style: titleStyle.copyWith(
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  themeProvider.getText('scan_qr_desc'),
                  textAlign: TextAlign.center,
                  style: subtitleStyle.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  "${themeProvider.getText('time_remaining')} ${_formatTime(_timeLeft)}",
                  style: timerStyle,
                ),
                const SizedBox(height: 10),

                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: _regenerateQR,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                    ),
                    child: Text(
                      themeProvider.getText('update_qr'),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  constraints: const BoxConstraints(maxWidth: 300),
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
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: QrImageView(data: qrData, version: QrVersions.auto),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
