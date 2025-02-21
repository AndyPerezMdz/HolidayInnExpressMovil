import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Holiday Inn Express',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(
            0xFF006640,
          ), // Color corporativo de Holiday Inn
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        // Personalización adicional del tema
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF006640),
          foregroundColor: Colors.white,
        ),
      ),
      navigatorKey: navigatorKey,
      initialRoute: '/', // Ruta inicial
      routes: {
        '/': (context) => LoginScreen(),
        '/main': (context) => const MainScreen(),
        // Eliminar las rutas individuales ya que ahora se manejan dentro de MainScreen
        // '/home': (context) => const HomeScreen(),
        // '/qr': (context) => const QRScreen(),
        // '/reports': (context) => const ReportsScreen(),
        // '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
