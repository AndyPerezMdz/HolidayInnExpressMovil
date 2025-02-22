import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'widgets/auth_wrapper.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Holiday Inn Express',
          theme: themeProvider.currentTheme,
          navigatorKey: navigatorKey,
          initialRoute: '/', // Ruta inicial
          routes: {
            '/': (context) => const LoginScreen(),
            '/main': (context) => const AuthWrapper(),
            '/forgot-password': (context) => const ForgotPasswordScreen(),
          },
        );
      },
    );
  }
}
