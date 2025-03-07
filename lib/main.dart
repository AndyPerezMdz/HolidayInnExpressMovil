import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/password_recovery_screen.dart';
import 'screens/splash_screen.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'widgets/auth_wrapper.dart';
import 'utils/page_transition.dart';

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
          initialRoute: '/splash',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/splash':
                return SlideLeftTransition(page: const SplashScreen());
              case '/login':
                return SlideLeftTransition(page: const LoginScreen());
              case '/main':
                return SlideLeftTransition(page: const AuthWrapper());
              case '/forgot-password':
                return SlideLeftTransition(page: const ForgotPasswordScreen());
              case '/password-recovery':
                return SlideLeftTransition(
                  page: const PasswordRecoveryScreen(),
                );
              default:
                return null;
            }
          },
        );
      },
    );
  }
}
