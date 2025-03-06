import 'package:flutter/foundation.dart';

class Advertisement {
  final int id;
  final String title;
  final String description;
  final String status;
  final DateTime issueDate;
  final DateTime expirationDate;
  final String departments;

  Advertisement({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.issueDate,
    required this.expirationDate,
    required this.departments,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    debugPrint('Creando Advertisement desde JSON: $json');
    return Advertisement(
      id: json['id_advertisements'] ?? 0,
      title: json['title'] ?? 'Sin título',
      description: json['description'] ?? 'Sin descripción',
      status: json['status'] ?? 'sin estado',
      issueDate: DateTime.parse(
        json['issue_date'] ?? DateTime.now().toIso8601String(),
      ),
      expirationDate: DateTime.parse(
        json['expiration_date'] ?? DateTime.now().toIso8601String(),
      ),
      departments: json['departments'] ?? 'Todos',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_advertisements': id,
      'title': title,
      'description': description,
      'status': status,
      'issue_date': issueDate.toIso8601String(),
      'expiration_date': expirationDate.toIso8601String(),
      'departments': departments,
    };
  }
}
