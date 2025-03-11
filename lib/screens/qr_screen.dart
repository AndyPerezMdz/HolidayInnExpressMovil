import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/celebration_overlay.dart';
import '../widgets/pulse_animation.dart';
import '../services/api_service.dart';
import '../widgets/illuminated_icon.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen>
    with SingleTickerProviderStateMixin {
  static const Color primaryColor = Color.fromRGBO(35, 53, 103, 1);
  static const double borderRadius = 20.0;

  final ApiService _apiService = ApiService();
  Uint8List? qrImage;
  late Timer _timer;
  int _timeLeft = 15;
  final int _checkInStreak = 0;
  final bool _showCelebration = false;
  bool _isLoading = false;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _disableScreenshot();
    _startTimer();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _generateQRData();
  }

  @override
  void dispose() {
    _timer.cancel();
    _rotationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft -= 1;
        } else {
          _regenerateQR();
        }
      });
    });
  }

  Future<void> _generateQRData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.token;

      if (token == null) {
        throw Exception('Token no disponible. Inicia sesión nuevamente.');
      }

      Uint8List qrBytes = await _apiService.getEmployeeQR(token);
      setState(() {
        qrImage = qrBytes;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al generar QR: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _regenerateQR() async {
    await _generateQRData();
    setState(() {
      _timeLeft = 15;
    });
    _rotationController.forward(from: 0.0);
    HapticFeedback.mediumImpact();
  }

  Future<void> _disableScreenshot() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
  }

  String _formatTime(int timeInSeconds) {
    final minutes = timeInSeconds ~/ 60;
    final seconds = (timeInSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Stack(
      children: [
        CelebrationOverlay(
          showCelebration: _showCelebration,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(
                themeProvider.getText('qr_code'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              elevation: 0,
              automaticallyImplyLeading: false,
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        themeProvider.getText('scan_qr_desc'),
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 10),
                      Text(
                        themeProvider.getText('help_desc'),
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      PulseAnimation(
                        child: GestureDetector(
                          onTap: _isLoading ? null : _regenerateQR,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(borderRadius),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RotationTransition(
                                  turns: Tween<double>(
                                    begin: 0,
                                    end: 1,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _rotationController,
                                      curve: Curves.linear,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  themeProvider.getText('update_qr'),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      PulseAnimation(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFF2A2A2A)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(borderRadius),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? const Color.fromARGB(
                                          31,
                                          0,
                                          0,
                                          0,
                                        ).withValues(
                                          alpha: 128,
                                          red: 0,
                                          green: 0,
                                          blue: 0,
                                        )
                                        : Colors.grey.withAlpha(26),
                                blurRadius: 10,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child:
                              qrImage == null
                                  ? const CircularProgressIndicator()
                                  : Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                            255,
                                            254,
                                            232,
                                            198,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IlluminatedIcon(
                                              icon: Icons.local_fire_department,
                                              size: 28,
                                              lightModeColor: Colors.orange,
                                              darkModeColor:
                                                  Colors.orange.shade300,
                                            ),
                                            const SizedBox(width: 20),
                                            Text(
                                              "$_checkInStreak ${themeProvider.getText('consecutive_days')}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Image.memory(
                                        qrImage!,
                                        width: 250,
                                        height: 250,
                                      ),
                                    ],
                                  ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${themeProvider.getText('time_remaining')} ${_formatTime(_timeLeft)}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
