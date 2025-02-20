import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de reportes (simulada)
    final List<Map<String, String>> reports = [
      {"title": "Reporte de Enero 2025", "size": "1.4MB"},
      {"title": "Reporte de Febrero 2025", "size": "1.2MB"},
      {"title": "Reporte de Marzo 2025", "size": "1.3MB"},
      {"title": "Reporte de Abril 2025", "size": "1.6MB"},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Oculta el botón de retroceso        
        title: const Text(
          "My Reports",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black, size: 28),
            onPressed: () {
              // Acción para buscar reportes
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,

      // Lista de reportes
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: reports.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final report = reports[index];
          return _buildReportItem(
            title: report["title"]!,
            size: report["size"]!,
          );
        },
      ),

      // 🔹 Agregamos el menú de navegación igual al de Home y QR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          }
          if (index == 1) {
            Navigator.pushNamed(context, '/qr');
          }
          if (index == 3) {
            Navigator.pushNamed(context, '/settings');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'QR Code',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.picture_as_pdf),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  // Widget para construir cada reporte
  Widget _buildReportItem({required String title, required String size}) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.insert_drive_file, color: Colors.black54, size: 28),
      ),
      title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
      subtitle: Text("PDF • $size", style: const TextStyle(fontSize: 16, color: Colors.black54)),
      trailing: IconButton(
        icon: const Icon(Icons.download, size: 28, color: Colors.black),
        onPressed: () {
          // Acción de descarga
        },
      ),
    );
  }
}
