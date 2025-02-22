import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color primaryColor = Color.fromRGBO(35, 53, 103, 1);
  static const double borderRadius = 8.0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Datos simulados del empleado
    final employeeData = {
      'name': 'Juan Pérez',
      'id': 'EMP-2024-001',
      'department': 'Recepción',
      'position': 'Recepcionista Senior',
      'email': 'juan.perez@holidayinn.com',
      'phone': '+52 (555) 123-4567',
      'startDate': '15/01/2020',
      'schedule': 'Lunes a Viernes, 9:00 - 18:00',
      'supervisor': 'María González',
    };

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
          themeProvider.getText('profile_info'),
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
            // Foto de perfil y nombre
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: primaryColor,
                    child: Text(
                      employeeData['name']!.substring(0, 2).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    employeeData['name']!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  Text(
                    employeeData['position']!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Información del empleado
            _buildInfoSection(
              context,
              themeProvider.getText('employee_info'),
              [
                _buildInfoRow(context, 'ID', employeeData['id']!),
                _buildInfoRow(context, themeProvider.getText('department'), employeeData['department']!),
                _buildInfoRow(context, themeProvider.getText('start_date'), employeeData['startDate']!),
              ],
            ),
            const SizedBox(height: 16),

            _buildInfoSection(
              context,
              themeProvider.getText('contact_info'),
              [
                _buildInfoRow(context, themeProvider.getText('email'), employeeData['email']!),
                _buildInfoRow(context, themeProvider.getText('phone'), employeeData['phone']!),
              ],
            ),
            const SizedBox(height: 16),

            _buildInfoSection(
              context,
              themeProvider.getText('work_info'),
              [
                _buildInfoRow(context, themeProvider.getText('schedule'), employeeData['schedule']!),
                _buildInfoRow(context, themeProvider.getText('supervisor'), employeeData['supervisor']!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
} 