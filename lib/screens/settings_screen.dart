import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../screens/profile_screen.dart';
import '../screens/help_screen.dart';
import '../screens/about_screen.dart';
import '../providers/auth_provider.dart';
import '../utils/page_transition.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true; // Nuevo estado

  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    // Aquí iría la lógica para habilitar/deshabilitar notificaciones
  }

  // Constantes de diseño
  static const Color primaryColor = Color.fromRGBO(35, 53, 103, 1);
  static const double borderRadius = 8.0;

  TextStyle _getTitleStyle(BuildContext context) {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).textTheme.titleLarge?.color,
    );
  }

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      title: Text(
        themeProvider.getText('settings'),
        style: _getTitleStyle(context),
      ),
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildBody(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de Perfil
            Text(
              themeProvider.getText('profile'),
              style: _getTitleStyle(context),
            ),
            const SizedBox(height: 8),
            _buildSettingCard(
              context,
              icon: Icons.person,
              title: themeProvider.getText('personal_info'),
              subtitle: themeProvider.getText('personal_info_desc'),
              onTap: () {
                Navigator.push(
                  context,
                  SlideLeftTransition(page: const ProfileScreen()),
                );
              },
            ),

            const SizedBox(height: 20),
            // Sección de Notificaciones
            Text(
              themeProvider.getText('notifications'),
              style: _getTitleStyle(context),
            ),
            const SizedBox(height: 8),
            _buildSwitchCard(
              context,
              icon: Icons.notifications,
              title: themeProvider.getText('check_in_reminders'),
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
            ),

            const SizedBox(height: 20),
            // Sección de Preferencias
            Text(
              themeProvider.getText('preferences'),
              style: _getTitleStyle(context),
            ),
            const SizedBox(height: 8),
            _buildSettingCard(
              context,
              icon: Icons.language,
              title: themeProvider.getText('language'),
              subtitle: themeProvider.currentLanguage,
              onTap: () => _showLanguageDialog(context),
            ),
            _buildSwitchCard(
              context,
              icon: Icons.dark_mode,
              title: themeProvider.getText('dark_mode'),
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),

            const SizedBox(height: 20),
            // Sección de Seguridad
            Text("Seguridad", style: _getTitleStyle(context)),
            const SizedBox(height: 8),
            _buildSettingCard(
              context,
              icon: Icons.lock,
              title: "Cambiar contraseña",
              subtitle: "Actualiza tu contraseña de acceso",
              onTap: () {
                Navigator.push(
                  context,
                  SlideLeftTransition(page: const ForgotPasswordScreen()),
                );
              },
            ),

            const SizedBox(height: 20),
            // Sección de Información
            Text(themeProvider.getText('help'), style: _getTitleStyle(context)),
            const SizedBox(height: 8),
            _buildSettingCard(
              context,
              icon: Icons.help,
              title: themeProvider.getText('help'),
              subtitle: themeProvider.getText('help_desc'),
              onTap: () {
                Navigator.push(
                  context,
                  SlideLeftTransition(page: const HelpScreen()),
                );
              },
            ),
            _buildSettingCard(
              context,
              icon: Icons.info,
              title: themeProvider.getText('about'),
              subtitle: themeProvider.getText('about_desc'),
              onTap: () {
                Navigator.push(
                  context,
                  SlideLeftTransition(page: const AboutScreen()),
                );
              },
            ),

            const SizedBox(height: 20),
            // Botón de cierre de sesión
            _buildLogoutButton(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: () => _showLogoutConfirmation(context),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.white),
            SizedBox(width: 8),
            Text("Salir", style: buttonTextStyle),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      color: Theme.of(context).cardColor,
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ListTile(
        leading: Icon(icon, color: primaryColor),
        title: Text(title),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: primaryColor,
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            themeProvider.getText('logout'),
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            themeProvider.getText('logout_confirm'),
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                themeProvider.getText('cancel'),
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _handleLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: Text(
                themeProvider.getText('logout'),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            themeProvider.getText('select_language'),
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Español',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                onTap: () {
                  themeProvider.setLanguage('Español');
                  Navigator.pop(dialogContext);
                },
              ),
              ListTile(
                title: Text(
                  'English',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                onTap: () {
                  themeProvider.setLanguage('English');
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleLogout() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.logout();
    Navigator.pushAndRemoveUntil(
      context,
      SlideLeftTransition(page: const LoginScreen()),
      (route) => false,
    );
  }
}
