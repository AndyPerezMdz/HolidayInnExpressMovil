import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/illuminated_icon.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const Color primaryColor = Color.fromRGBO(35, 53, 103, 1);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final List<Map<String, String>> features = [
      {
        'title': themeProvider.getText('feature_qr'),
        'desc': themeProvider.getText('feature_qr_desc'),
      },
      {
        'title': themeProvider.getText('feature_reports'),
        'desc': themeProvider.getText('feature_reports_desc'),
      },
      {
        'title': themeProvider.getText('feature_theme'),
        'desc': themeProvider.getText('feature_theme_desc'),
      },
      {
        'title': themeProvider.getText('feature_language'),
        'desc': themeProvider.getText('feature_language_desc'),
      },
      {
        'title': themeProvider.getText('feature_notifications'),
        'desc': themeProvider.getText('feature_notifications_desc'),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: IlluminatedIcon(
            icon: Icons.arrow_back,
            size: 24,
            lightModeColor: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          themeProvider.getText('about'),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset('assets/logo.png', height: 100),
                  const SizedBox(height: 16),
                  Text(
                    themeProvider.getText('holiday_inn_express'), 
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  Text(
                    'v1.0.8',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              themeProvider.getText('features'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 16),
            ...features.map((feature) => _buildFeatureCard(context, feature)),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  Text(
                    themeProvider.getText('developed_by'), // Cambiar "Desarrollado por"
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'assets/DevMaceLogoW.png'
                        : 'assets/DevMaceLogoB.png',
                    height: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, Map<String, String> feature) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Theme.of(context).cardColor,
      child: ListTile(
        leading: IlluminatedIcon(
          icon: Icons.check_circle,
          size: 24,
          lightModeColor: Theme.of(context).primaryColor,
        ),
        title: Text(
          feature['title']!,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        subtitle: Text(
          feature['desc']!,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ),
    );
  }
}
