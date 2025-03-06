import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  final Dio dio;
  String? _token;
  static const String baseUrl = 'https://devmace.onrender.com';

  factory ApiClient() {
    return _instance;
  }

  String? get token => _token;

  ApiClient._internal()
      : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 5),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

  void setToken(String token) {
    _token = token;
    debugPrint('Configurando token: Bearer $token');
    
    dio.options.headers['Authorization'] = 'Bearer $token';

    // Asegurar que los interceptores se actualicen correctamente
    dio.interceptors.clear();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('Headers en petición: ${options.headers}');
          return handler.next(options);
        },
        onError: (error, handler) {
          debugPrint('Error en petición: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      debugPrint('GET Request a: $path');
      final response = await dio.get(path, queryParameters: queryParameters);
      debugPrint('GET Response data: ${response.data}');
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      debugPrint('POST Request a: $path');
      final response = await dio.post(path, data: data);
      debugPrint('POST Response data: ${response.data}');
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    if (error.response?.statusCode == 401) {
      return Exception('Error de autenticación: Token inválido o expirado.');
    }
    return Exception('Error en la conexión o en la solicitud.');
  }
}
