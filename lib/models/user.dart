import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String employeeName;
  final int department;
  final String email;
  final String address;
  final String status;
  final String role;
  final String lastCheckIn;
  final String lastCheckOut;
  final String? token;
  final bool forcePasswordReset;

  static const Map<int, String> departmentNames = {
    1: 'Administración',
    2: 'Ama de llaves',
    3: 'Alimentos y Bebidas',
    4: 'Mantenimiento',
    5: 'Seguridad',
    6: 'Ventas',
    7: 'RRHH',
    8: 'Recepción',
  };

  User({
    required this.id,
    required this.employeeName,
    required this.email,
    required this.department,
    required this.address,
    required this.status,
    required this.role,
    required this.lastCheckIn,
    required this.lastCheckOut,
    this.token,
    this.forcePasswordReset = false,
  });

  String get departmentName =>
      departmentNames[department] ?? 'Departamento $department';

  factory User.fromJson(Map<String, dynamic> json) {
    debugPrint('Creando User desde JSON: $json');

    // Convertir el departamento a número
    int departmentNumber = 0;
    var deptValue = json['department'];
    if (deptValue is String) {
      // Mapear nombres de departamentos a números
      departmentNumber =
          departmentNames.entries
              .firstWhere(
                (entry) => entry.value.toLowerCase() == deptValue.toLowerCase(),
                orElse: () => const MapEntry(0, ''),
              )
              .key;
    } else if (deptValue is int) {
      departmentNumber = deptValue;
    }

    return User(
      id: json['id_employee']?.toString() ?? '',
      employeeName: json['employeeName'] ?? '',
      email: json['email'] ?? '',
      department: departmentNumber,
      address: json['address'] ?? 'Sin dirección registrada',
      status: json['status']?.toString().toLowerCase() ?? 'activo',
      role: json['role'] ?? 'Employee',
      lastCheckIn: json['lastCheckIn'] ?? 'SIN REGISTRO',
      lastCheckOut: json['lastCheckOut'] ?? 'SIN REGISTRO',
      token: json['token'],
      forcePasswordReset: json['forcePasswordReset'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_employee': id,
      'employeeName': employeeName,
      'email': email,
      'department': department,
      'address': address,
      'status': status,
      'role': role,
      'lastCheckIn': lastCheckIn,
      'lastCheckOut': lastCheckOut,
      'token': token,
      'forcePasswordReset': forcePasswordReset,
    };
  }
}
