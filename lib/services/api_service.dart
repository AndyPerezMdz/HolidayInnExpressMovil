import 'api_client.dart';
import '../models/check_record.dart';
import '../models/advertisement.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  final ApiClient _client;

  factory ApiService() {
    return _instance;
  }

  String? get token => _client.token;

  ApiService._internal() : _client = ApiClient() {
    // Configurar timeouts para todas las peticiones
    _client.dio.options.connectTimeout = const Duration(seconds: 30);
    _client.dio.options.receiveTimeout = const Duration(seconds: 30);
    _client.dio.options.sendTimeout = const Duration(seconds: 30);
  }

  // Auth endpoints
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _client.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException(
            'El servidor está tardando en responder. Por favor, espera un momento.',
          );
        },
      );

      debugPrint('Respuesta completa de login: ${response.data}');

      if (response.data['token'] != null) {
        final token = response.data['token'];
        _client.setToken(token);
        return {
          'token': token,
          'forcePasswordReset': response.data['forcePasswordReset'] ?? false,
        };
      }

      throw Exception('Token no recibido en la respuesta de login');
    } catch (e) {
      debugPrint('Error en login: $e');
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          throw TimeoutException(
            'El servidor está tardando en responder. Por favor, espera un momento.',
          );
        }
        if (e.response?.statusCode == 401) {
          final errorMessage =
              e.response?.data['message'] ?? 'Credenciales inválidas';
          throw Exception(errorMessage);
        } else if (e.response?.statusCode == 404) {
          throw Exception('La ruta de autenticación no está disponible');
        } else if (e.response?.statusCode == 400) {
          final errorMessage =
              e.response?.data['message'] ?? 'Error en los datos enviados';
          throw Exception(errorMessage);
        } else if (e.response?.statusCode == 500) {
          throw Exception(
            'Error interno del servidor: Por favor, intente más tarde',
          );
        }
      }
      throw Exception('Error de conexión: Verifique su conexión a internet');
    }
  }

  Future<void> logout() async {
    try {
      await _client.post('/auth/logout');
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  Future<void> requestPasswordReset(String email) async {
    try {
      await _client.post(
        '/auth/request-password-reset',
        data: {'email': email},
      );
    } catch (e) {
      throw Exception('Error al solicitar recuperación de contraseña: $e');
    }
  }

  // Employee endpoints
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      debugPrint('Iniciando getUserProfile...');
      final response = await _client.get('/api/employees/profile');
      debugPrint('Respuesta completa del perfil: ${response.data}');

      if (response.data is Map) {
        final userData = response.data;
        debugPrint('Datos del usuario: $userData');
        return userData; // Retornamos directamente los datos del perfil
      } else {
        debugPrint('Error: La respuesta no tiene el formato esperado');
        throw Exception('Formato de respuesta inválido');
      }
    } catch (e) {
      debugPrint('Error detallado en getUserProfile: $e');
      if (e is DioException) {
        debugPrint(
          'Headers en la petición fallida: ${_client.dio.options.headers}',
        );
        debugPrint('Response completo del error: ${e.response?.data}');
        if (e.response?.statusCode == 401) {
          throw Exception('Sesión expirada o token inválido');
        }
      }
      rethrow;
    }
  }

  Future<String> generateQR(String employeeId) async {
    try {
      debugPrint('Generando QR para empleado: $employeeId');

      // Configurar las opciones para recibir la respuesta como una URL
      final qrUrl = '${ApiClient.baseUrl}/api/employees/$employeeId/qr';

      // Retornar la URL con el header de autorización
      return qrUrl;
    } catch (e) {
      debugPrint('Error al generar QR: $e');
      if (e is DioException) {
        debugPrint('Response error: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<void> downloadAttendanceReport() async {
    try {
      await _client.get('/api/employees/profile/report');
    } catch (e) {
      throw Exception('Error al descargar reporte: $e');
    }
  }

  // Security Booth endpoints
  Future<Map<String, dynamic>> registerCheckInOut(String qrData) async {
    try {
      final response = await _client.post(
        '/api/securityBooth/register',
        data: {'qrData': qrData},
      );
      return response.data;
    } catch (e) {
      throw Exception('Error al registrar asistencia: $e');
    }
  }

  Future<List<CheckRecord>> getAttendanceHistory(String employeeId) async {
    try {
      debugPrint('Obteniendo historial para empleado: $employeeId');
      debugPrint('Headers actuales: ${_client.dio.options.headers}');

      final response = await _client.get(
        '/api/securityBooth/history/$employeeId',
      );
      debugPrint('Respuesta del historial: ${response.data}');

      final List<dynamic> records = response.data['records'];
      return records.map((record) => CheckRecord.fromJson(record)).toList();
    } catch (e) {
      debugPrint('Error al obtener historial: $e');
      if (e is DioException) {
        debugPrint('Response error: ${e.response?.data}');
      }
      throw Exception('Error al obtener historial: $e');
    }
  }

  Future<Map<String, dynamic>> getLastCheckInOut(String userId) async {
    final response = await http.get(
      Uri.parse('https://devmace.onrender.com/api/employees/profile/$userId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar datos');
    }
  }

  // Advertisements endpoints
  Future<List<Advertisement>> getAdvertisements(String department) async {
    try {
      final response = await _client.get('/api/advertisements');
      debugPrint('Respuesta completa de anuncios: ${response.data}');

      if (response.data != null) {
        List<dynamic> advertisementsList;
        if (response.data is List) {
          advertisementsList = response.data;
        } else if (response.data is Map) {
          advertisementsList = response.data['data'] ?? [];
        } else {
          advertisementsList = [];
        }

        // Filtrar anuncios según el departamento
        final filteredAds =
            advertisementsList
                .map((ad) => Advertisement.fromJson(ad))
                .where((ad) => ad.departments == department)
                .toList();

        debugPrint(
          'Anuncios filtrados para el departamento $department: $filteredAds',
        );

        return filteredAds;
      }

      debugPrint('No se encontró estructura conocida en la respuesta');
      return [];
    } catch (e) {
      debugPrint('Error en getAdvertisements: $e');
      if (e is DioException) {
        debugPrint('DioError response: ${e.response?.data}');
      }
      throw Exception('Error al obtener anuncios: $e');
    }
  }

  Future<Uint8List> getEmployeeQR(String token) async {
    try {
      Response response = await _client.dio.get(
        '/api/employees/profile/qr',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes, // 👈 Importante para imágenes
        ),
      );

      return Uint8List.fromList(response.data);
    } catch (e) {
      throw Exception('Error al obtener el QR: $e');
    }
  }
}
