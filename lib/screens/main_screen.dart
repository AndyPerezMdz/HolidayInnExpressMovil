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
    });
    _pageController.jumpToPage(index);
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
        physics: const BouncingScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.topCenter,
        children: [
          BottomNavigationBar(
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
                icon: _buildIcon(Icons.home, 0, themeProvider),
                label: themeProvider.getText('home'),
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.qr_code, 1, themeProvider),
                label: themeProvider.getText('qr_menu'),
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.insert_drive_file, 2, themeProvider),
                label: themeProvider.getText('reports_menu'),
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.settings, 3, themeProvider),
                label: themeProvider.getText('settings_menu'),
              ),
            ],
          ),
          // Línea en la orilla de la barra de navegación
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: 0,
            left: MediaQuery.of(context).size.width / 4 * _selectedIndex,
            child: Container(
              height: 4, // Altura de la línea
              width:
                  MediaQuery.of(context).size.width /
                  4, // Ancho de la línea igual al ancho de un ícono
              color: primaryColor, // Color de la línea
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index, ThemeProvider themeProvider) {
    bool isSelected = _selectedIndex == index;
    return IlluminatedIcon(
      icon: icon,
      size: 24,
      lightModeColor: isSelected ? primaryColor : Colors.grey,
      darkModeColor: isSelected ? Colors.white : unselectedDarkColor,
    );
  }
}
