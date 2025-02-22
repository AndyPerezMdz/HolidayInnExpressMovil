import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const Color primaryColor = Color.fromRGBO(35, 53, 103, 1);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final List<Map<String, String>> faqs = [
      {
        'question': themeProvider.getText('faq_checkin_question'),
        'answer': themeProvider.getText('faq_checkin_answer'),
      },
      {
        'question': themeProvider.getText('faq_reports_question'),
        'answer': themeProvider.getText('faq_reports_answer'),
      },
      {
        'question': themeProvider.getText('faq_password_question'),
        'answer': themeProvider.getText('faq_password_answer'),
      },
      {
        'question': themeProvider.getText('faq_notifications_question'),
        'answer': themeProvider.getText('faq_notifications_answer'),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          themeProvider.getText('help'),
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
            // Sección de FAQ
            Text(
              themeProvider.getText('faq_title'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 16),
            ...faqs.map((faq) => _buildFAQCard(context, faq)),
            const SizedBox(height: 24),

            // Sección de Contacto
            Text(
              themeProvider.getText('contact_title'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              context,
              icon: Icons.email,
              title: themeProvider.getText('support_email'),
              subtitle: 'soporte@holidayinn.com',
              onTap: () {
                // Implementar envío de correo
              },
            ),
            _buildContactCard(
              context,
              icon: Icons.phone,
              title: themeProvider.getText('support_phone'),
              subtitle: '(555) 123-4567',
              onTap: () {
                // Implementar llamada
              },
            ),
            _buildContactCard(
              context,
              icon: Icons.access_time,
              title: themeProvider.getText('support_hours'),
              subtitle: 'Lun-Vie: 9:00 - 18:00',
              onTap: null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQCard(BuildContext context, Map<String, String> faq) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Theme.of(context).cardColor,
      child: ExpansionTile(
        title: Text(
          faq['question']!,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              faq['answer']!,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Theme.of(context).cardColor,
      child: ListTile(
        leading: Icon(icon, color: primaryColor),
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
        onTap: onTap,
      ),
    );
  }
}
