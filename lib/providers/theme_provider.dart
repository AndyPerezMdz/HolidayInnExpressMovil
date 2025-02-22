import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  String _currentLanguage = 'Español';
  final Map<String, Map<String, String>> _translations = {
    'Español': {
      'welcome': 'Bienvenido',
      'settings': 'Configuración',
      'profile': 'Perfil',
      'notifications': 'Notificaciones',
      'preferences': 'Preferencias',
      'security': 'Seguridad',
      'information': 'Información',
      'personal_info': 'Información personal',
      'personal_info_desc': 'Nombre, ID de empleado, Departamento',
      'dark_mode': 'Modo oscuro',
      'language': 'Idioma',
      'check_in_reminders': 'Recordatorios de check-in',
      'change_password': 'Cambiar contraseña',
      'change_password_desc': 'Actualiza tu contraseña de acceso',
      'help': 'Ayuda y soporte',
      'help_desc': 'Preguntas frecuentes y contacto',
      'about': 'Acerca de',
      'about_desc': 'Versión 1.0.0',
      'logout': 'Salir',
      'logout_confirm': '¿Estás seguro que deseas cerrar sesión?',
      'cancel': 'Cancelar',
      'ok': 'OK',
      'reports': 'Mis reportes',
      'filter_reports': 'Filtrar reportes',
      'year': 'Año',
      'month': 'Mes',
      'apply': 'Aplicar',
      'download_success': 'Descarga exitosa:',
      'january': 'Enero',
      'february': 'Febrero',
      'march': 'Marzo',
      'april': 'Abril',
      'may': 'Mayo',
      'june': 'Junio',
      'july': 'Julio',
      'august': 'Agosto',
      'september': 'Septiembre',
      'october': 'Octubre',
      'november': 'Noviembre',
      'december': 'Diciembre',
      'qr_code': 'Check in/out',
      'scan_qr': 'Código QR',
      'scan_qr_desc': 'Escanea este QR para hacer tu Check in/out',
      'update_qr': 'Actualizar QR',
      'time_remaining': 'Tiempo restante:',
      'last_entry': 'Última entrada',
      'last_exit': 'Última salida',
      'announcements': 'Anuncios',
      'select_language': 'Seleccionar idioma',
      'profile_info': 'Información del Perfil',
      'employee_info': 'Información del Empleado',
      'contact_info': 'Información de Contacto',
      'work_info': 'Información Laboral',
      'department': 'Departamento',
      'start_date': 'Fecha de Ingreso',
      'email': 'Correo',
      'phone': 'Teléfono',
      'schedule': 'Horario',
      'supervisor': 'Supervisor',
      'faq_title': 'Preguntas Frecuentes',
      'contact_title': 'Contacto',
      'support_email': 'Correo de soporte',
      'support_phone': 'Teléfono de soporte',
      'support_hours': 'Horario de atención',
      'faq_checkin_question': '¿Cómo funciona el check-in/out?',
      'faq_checkin_answer':
          'El check-in/out se realiza escaneando el código QR en la sección correspondiente. El código se actualiza cada 5 minutos por seguridad.',
      'faq_reports_question': '¿Cómo puedo ver mis reportes?',
      'faq_reports_answer':
          'Los reportes están disponibles en la sección "Reportes". Puedes filtrarlos por mes y año, y descargarlos en formato PDF.',
      'faq_password_question': '¿Cómo cambio mi contraseña?',
      'faq_password_answer':
          'Puedes cambiar tu contraseña en la sección "Seguridad" dentro de "Ajustes", o usar la opción "Olvidé mi contraseña" en la pantalla de inicio de sesión.',
      'faq_notifications_question': '¿Cómo funcionan las notificaciones?',
      'faq_notifications_answer':
          'Las notificaciones te recordarán realizar tu check-in/out. Puedes activarlas o desactivarlas en la sección "Notificaciones" de "Ajustes".',
      'home': 'Inicio',
      'qr_menu': 'Código QR',
      'reports_menu': 'Reportes',
      'settings_menu': 'Ajustes',
      'all_years': 'Todos los años',
      'all_months': 'Todos los meses',
      'clear_filters': 'Limpiar filtros',
      'features': 'Características',
      'feature_qr': 'Check-in/out con QR',
      'feature_qr_desc':
          'Sistema de registro de entrada/salida mediante código QR con actualización automática.',
      'feature_reports': 'Reportes mensuales',
      'feature_reports_desc':
          'Acceso a reportes mensuales con filtros por año y mes.',
      'feature_theme': 'Tema claro/oscuro',
      'feature_theme_desc': 'Personalización del tema de la aplicación.',
      'feature_language': 'Multilenguaje',
      'feature_language_desc': 'Soporte para español e inglés.',
      'feature_notifications': 'Notificaciones',
      'feature_notifications_desc':
          'Sistema de recordatorios para check-in/out.',
    },
    'English': {
      'welcome': 'Welcome',
      'settings': 'Settings',
      'profile': 'Profile',
      'notifications': 'Notifications',
      'preferences': 'Preferences',
      'security': 'Security',
      'information': 'Information',
      'personal_info': 'Personal Information',
      'personal_info_desc': 'Name, Employee ID, Department',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'check_in_reminders': 'Check-in Reminders',
      'change_password': 'Change Password',
      'change_password_desc': 'Update your password',
      'help': 'Help & Support',
      'help_desc': 'FAQ and contact',
      'about': 'About',
      'about_desc': 'Version 1.0.0',
      'logout': 'Logout',
      'logout_confirm': 'Are you sure you want to log out?',
      'cancel': 'Cancel',
      'ok': 'OK',
      'reports': 'My Reports',
      'filter_reports': 'Filter Reports',
      'year': 'Year',
      'month': 'Month',
      'apply': 'Apply',
      'download_success': 'Download successful:',
      'january': 'January',
      'february': 'February',
      'march': 'March',
      'april': 'April',
      'may': 'May',
      'june': 'June',
      'july': 'July',
      'august': 'August',
      'september': 'September',
      'october': 'October',
      'november': 'November',
      'december': 'December',
      'qr_code': 'Check in/out',
      'scan_qr': 'QR Code',
      'scan_qr_desc': 'Scan this QR to check in/out',
      'update_qr': 'Update QR',
      'time_remaining': 'Time remaining:',
      'last_entry': 'Last entry',
      'last_exit': 'Last exit',
      'announcements': 'Announcements',
      'select_language': 'Select language',
      'profile_info': 'Profile Information',
      'employee_info': 'Employee Information',
      'contact_info': 'Contact Information',
      'work_info': 'Work Information',
      'department': 'Department',
      'start_date': 'Start Date',
      'email': 'Email',
      'phone': 'Phone',
      'schedule': 'Schedule',
      'supervisor': 'Supervisor',
      'faq_title': 'Frequently Asked Questions',
      'contact_title': 'Contact',
      'support_email': 'Support email',
      'support_phone': 'Support phone',
      'support_hours': 'Support hours',
      'faq_checkin_question': 'How does check-in/out work?',
      'faq_checkin_answer':
          'Check-in/out is done by scanning the QR code in the corresponding section. The code updates every 5 minutes for security.',
      'faq_reports_question': 'How can I view my reports?',
      'faq_reports_answer':
          'Reports are available in the "Reports" section. You can filter them by month and year, and download them in PDF format.',
      'faq_password_question': 'How do I change my password?',
      'faq_password_answer':
          'You can change your password in the "Security" section within "Settings", or use the "Forgot Password" option on the login screen.',
      'faq_notifications_question': 'How do notifications work?',
      'faq_notifications_answer':
          'Notifications will remind you to do your check-in/out. You can enable or disable them in the "Notifications" section of "Settings".',
      'home': 'Home',
      'qr_menu': 'QR Code',
      'reports_menu': 'Reports',
      'settings_menu': 'Settings',
      'all_years': 'All years',
      'all_months': 'All months',
      'clear_filters': 'Clear filters',
      'features': 'Features',
      'feature_qr': 'QR Check-in/out',
      'feature_qr_desc':
          'Entry/exit registration system using QR code with automatic updates.',
      'feature_reports': 'Monthly Reports',
      'feature_reports_desc':
          'Access to monthly reports with year and month filters.',
      'feature_theme': 'Light/Dark theme',
      'feature_theme_desc': 'App theme customization.',
      'feature_language': 'Multi-language',
      'feature_language_desc': 'Support for Spanish and English.',
      'feature_notifications': 'Notifications',
      'feature_notifications_desc': 'Check-in/out reminder system.',
    },
  };

  bool get isDarkMode => _isDarkMode;
  String get currentLanguage => _currentLanguage;

  String getText(String key) {
    return _translations[_currentLanguage]?[key] ?? key;
  }

  ThemeData get currentTheme =>
      _isDarkMode
          ? ThemeData.dark().copyWith(
            primaryColor: const Color.fromRGBO(35, 53, 103, 1),
            scaffoldBackgroundColor: Colors.grey[900],
            cardColor: Colors.grey[850],
            textTheme: const TextTheme(
              titleLarge: TextStyle(color: Colors.white),
              bodyLarge: TextStyle(color: Colors.white70),
              bodyMedium: TextStyle(color: Colors.white70),
            ),
          )
          : ThemeData.light().copyWith(
            primaryColor: const Color.fromRGBO(35, 53, 103, 1),
            scaffoldBackgroundColor: Colors.white,
            cardColor: Colors.white,
            textTheme: const TextTheme(
              titleLarge: TextStyle(color: Colors.black),
              bodyLarge: TextStyle(color: Colors.black87),
              bodyMedium: TextStyle(color: Colors.black87),
            ),
          );

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setLanguage(String language) {
    if (_translations.containsKey(language)) {
      _currentLanguage = language;
      notifyListeners();
    }
  }
}
