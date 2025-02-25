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
  final _pageController = PageController();

  static const List<Widget> _screens = [
    HomeScreen(),
    QRScreen(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  static const Color primaryColor = Color.fromRGBO(35, 53, 103, 1);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics:
            const NeverScrollableScrollPhysics(), // Desactivar el deslizamiento manual
        children: _screens,
      ),
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
