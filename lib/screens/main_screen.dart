import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'qr_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    QRScreen(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  static const Color primaryColor = Color.fromRGBO(35, 53, 103, 1);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        iconSize: 24,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: themeProvider.getText('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.qr_code),
            label: themeProvider.getText('qr_menu'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.insert_drive_file),
            label: themeProvider.getText('reports_menu'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: themeProvider.getText('settings_menu'),
          ),
        ],
      ),
    );
  }
}
