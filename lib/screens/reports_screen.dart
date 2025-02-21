import 'package:flutter/material.dart';
import '../main.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  // Constantes de diseño
  static const Color primaryColor = Color.fromRGBO(35, 53, 103, 1);
  static const double borderRadius = 10.0;
  static const double iconSize = 28.0;

  static const TextStyle titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  static const TextStyle reportTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    color: Colors.black54,
  );

  // Lista simulada de reportes
  final List<Map<String, String>> reports = const [
    {"title": "Reporte de Enero 2025", "size": "1.4MB"},
    {"title": "Reporte de Febrero 2025", "size": "1.2MB"},
    {"title": "Reporte de Marzo 2025", "size": "1.3MB"},
    {"title": "Reporte de Abril 2025", "size": "1.6MB"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: _buildReportsList(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const Text("Mis reportes", style: titleStyle),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black, size: iconSize),
          onPressed: () {
            // Acción para buscar reportes
          },
        ),
      ],
    );
  }

  Widget _buildReportsList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: reports.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final report = reports[index];
        return _buildReportItem(title: report["title"]!, size: report["size"]!);
      },
    );
  }

  Widget _buildReportItem({required String title, required String size}) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: const Icon(
          Icons.insert_drive_file,
          color: Colors.black54,
          size: iconSize,
        ),
      ),
      title: Text(title, style: reportTitleStyle),
      subtitle: Text("PDF • $size", style: subtitleStyle),
      trailing: IconButton(
        icon: const Icon(Icons.download, size: iconSize, color: Colors.black),
        onPressed: () {
          _showDownloadNotification(title);
        },
      ),
    );
  }

  void _showDownloadNotification(String reportTitle) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Descarga exitosa: $reportTitle',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }
}
