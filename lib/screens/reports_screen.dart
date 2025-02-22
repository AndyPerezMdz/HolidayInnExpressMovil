import 'package:flutter/material.dart';
import '../main.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String? _selectedYear;
  String? _selectedMonth;

  final List<String> _years = ['2025', '2026', '2027'];
  final Map<String, String> _months = {
    'all': '00',
    'Enero': '01',
    'Febrero': '02',
    'Marzo': '03',
    'Abril': '04',
    'Mayo': '05',
    'Junio': '06',
    'Julio': '07',
    'Agosto': '08',
    'Septiembre': '09',
    'Octubre': '10',
    'Noviembre': '11',
    'Diciembre': '12',
  };

  // Constantes de diseño
  static const Color primaryColor = Color.fromRGBO(35, 53, 103, 1);
  static const double borderRadius = 10.0;
  static const double iconSize = 28.0;

  static const TextStyle titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle reportTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subtitleStyle = TextStyle(fontSize: 16);

  // Lista simulada de reportes con más información
  final List<Map<String, String>> allReports = [
    {
      "title": "Reporte de Enero 2025",
      "size": "1.4MB",
      "date": "2025-01",
      "type": "Mensual",
    },
    {
      "title": "Reporte de Febrero 2025",
      "size": "1.2MB",
      "date": "2025-02",
      "type": "Mensual",
    },
    {
      "title": "Reporte de Marzo 2025",
      "size": "1.3MB",
      "date": "2025-03",
      "type": "Mensual",
    },
    {
      "title": "Reporte de Abril 2025",
      "size": "1.6MB",
      "date": "2025-04",
      "type": "Mensual",
    },
    {
      "title": "Reporte de Mayo 2025",
      "size": "1.5MB",
      "date": "2025-05",
      "type": "Mensual",
    },
    {
      "title": "Reporte de Enero 2026",
      "size": "1.4MB",
      "date": "2026-01",
      "type": "Mensual",
    },
    {
      "title": "Reporte de Febrero 2026",
      "size": "1.3MB",
      "date": "2026-02",
      "type": "Mensual",
    },
  ];

  List<Map<String, String>> get filteredReports {
    if (_selectedYear == null && _selectedMonth == null) {
      return allReports;
    }
    return allReports.where((report) {
      if (_selectedYear != null && _selectedMonth == null) {
        return report["date"]?.startsWith(_selectedYear!) ?? false;
      }
      if (_selectedYear == null && _selectedMonth != null) {
        return report["date"]?.contains("-${_months[_selectedMonth]}") ?? false;
      }
      return report["date"]?.startsWith(
            "$_selectedYear-${_months[_selectedMonth]}",
          ) ??
          false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          themeProvider.getText('reports'),
          style: titleStyle.copyWith(
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: Theme.of(context).textTheme.bodyLarge?.color,
              size: iconSize,
            ),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [_buildFilterChips(), Expanded(child: _buildReportsList())],
      ),
    );
  }

  Widget _buildFilterChips() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          FilterChip(
            label: Text(_selectedYear ?? themeProvider.getText('all_years')),
            selected: _selectedYear != null,
            onSelected: (_) => _showFilterDialog(context),
            backgroundColor: Theme.of(context).cardColor,
            selectedColor: primaryColor.withOpacity(0.2),
            labelStyle: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: Text(_selectedMonth ?? themeProvider.getText('all_months')),
            selected: _selectedMonth != null,
            onSelected: (_) => _showFilterDialog(context),
            backgroundColor: Theme.of(context).cardColor,
            selectedColor: primaryColor.withOpacity(0.2),
            labelStyle: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(
                Icons.filter_list,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
              const SizedBox(width: 10),
              Text(
                themeProvider.getText('filter_reports'),
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Año
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedYear,
                  decoration: InputDecoration(
                    labelText: themeProvider.getText('year'),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  dropdownColor: Theme.of(context).cardColor,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(themeProvider.getText('all_years')),
                    ),
                    ..._years.map((year) {
                      return DropdownMenuItem(value: year, child: Text(year));
                    }),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedYear = value);
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Mes
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedMonth,
                  decoration: InputDecoration(
                    labelText: themeProvider.getText('month'),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  dropdownColor: Theme.of(context).cardColor,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(themeProvider.getText('all_months')),
                    ),
                    ..._months.keys.where((month) => month != 'all').map((
                      month,
                    ) {
                      return DropdownMenuItem(value: month, child: Text(month));
                    }),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedMonth = value);
                  },
                ),
              ),
            ],
          ),
          actions: [
            // Botón para limpiar filtros
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectedYear = null;
                  _selectedMonth = null;
                });
                Navigator.pop(context);
              },
              icon: const Icon(Icons.clear, size: 20),
              label: Text(themeProvider.getText('clear_filters')),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
            // Botón para aplicar filtros
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.check, size: 20),
              label: Text(themeProvider.getText('apply')),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReportsList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: filteredReports.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final report = filteredReports[index];
        return _buildReportItem(
          context: context,
          title: report["title"]!,
          size: report["size"]!,
        );
      },
    );
  }

  Widget _buildReportItem({
    required BuildContext context,
    required String title,
    required String size,
  }) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Icon(
          Icons.insert_drive_file,
          color: Theme.of(context).textTheme.bodyLarge?.color,
          size: iconSize,
        ),
      ),
      title: Text(
        title,
        style: reportTitleStyle.copyWith(
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
      subtitle: Text(
        "PDF • $size",
        style: subtitleStyle.copyWith(
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.download,
          size: iconSize,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
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
