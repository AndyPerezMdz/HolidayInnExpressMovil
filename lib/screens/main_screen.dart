import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'qr_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/illuminated_icon.dart';

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
  static const Color unselectedDarkColor = Color.fromRGBO(128, 128, 128, 1);

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const PageScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: isDarkMode ? Colors.white : primaryColor,
        unselectedItemColor: isDarkMode ? unselectedDarkColor : Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        iconSize: 24,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: IlluminatedIcon(
              icon: Icons.home,
              size: 24,
              lightModeColor: _selectedIndex == 0 ? primaryColor : Colors.grey,
              darkModeColor:
                  _selectedIndex == 0 ? Colors.white : unselectedDarkColor,
            ),
            label: themeProvider.getText('home'),
          ),
          BottomNavigationBarItem(
            icon: IlluminatedIcon(
              icon: Icons.qr_code,
              size: 24,
              lightModeColor: _selectedIndex == 1 ? primaryColor : Colors.grey,
              darkModeColor:
                  _selectedIndex == 1 ? Colors.white : unselectedDarkColor,
            ),
            label: themeProvider.getText('qr_menu'),
          ),
          BottomNavigationBarItem(
            icon: IlluminatedIcon(
              icon: Icons.insert_drive_file,
              size: 24,
              lightModeColor: _selectedIndex == 2 ? primaryColor : Colors.grey,
              darkModeColor:
                  _selectedIndex == 2 ? Colors.white : unselectedDarkColor,
            ),
            label: themeProvider.getText('reports_menu'),
          ),
          BottomNavigationBarItem(
            icon: IlluminatedIcon(
              icon: Icons.settings,
              size: 24,
              lightModeColor: _selectedIndex == 3 ? primaryColor : Colors.grey,
              darkModeColor:
                  _selectedIndex == 3 ? Colors.white : unselectedDarkColor,
            ),
            label: themeProvider.getText('settings_menu'),
          ),
        ],
      ),
    );
  }
}
