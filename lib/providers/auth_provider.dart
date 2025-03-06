import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoggedIn = false;
  User? _currentUser;
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUserId = 'userId';
  static const String _keyEmail = 'savedEmail';
  static const String _keyPassword = 'savedPassword';
  static const String _keyRememberMe = 'rememberMe';
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  User? get currentUser => _currentUser;
  String? get token => _apiService.token;

  AuthProvider() {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    if (_isLoggedIn) {
      final userId = prefs.getString(_keyUserId);
      if (userId != null) {
        try {
          await _loadUserData(userId);
        } catch (e) {
          _isLoggedIn = false;
          await prefs.setBool(_keyIsLoggedIn, false);
        }
      }
    }
    notifyListeners();
  }

  Future<Map<String, String?>> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(_keyEmail),
      'password': prefs.getString(_keyPassword),
      'rememberMe': prefs.getBool(_keyRememberMe)?.toString(),
    };
  }

  Future<void> saveCredentials(
    String email,
    String password,
    bool rememberMe,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString(_keyEmail, email);
      await prefs.setString(_keyPassword, password);
    } else {
      await prefs.remove(_keyEmail);
      await prefs.remove(_keyPassword);
    }
    await prefs.setBool(_keyRememberMe, rememberMe);
  }

  Future<void> clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPassword);
    await prefs.remove(_keyRememberMe);
  }

  Future<void> _loadUserData(String userId) async {
    try {
      final userData = await _apiService.getUserProfile();
      _currentUser = User.fromJson(userData);
    } catch (e) {
      throw Exception('Error al cargar datos del usuario: $e');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Primero hacer login y obtener el token
      final loginData = await _apiService.login(email, password);
      debugPrint('Token recibido en login');

      // Una vez que tenemos el token, obtener el perfil completo
      final profileData = await _apiService.getUserProfile();
      debugPrint('Datos del perfil recibidos: $profileData');

      // Crear el usuario con los datos del perfil
      _currentUser = User.fromJson({
        ...profileData,
        'token': loginData['token'],
        'forcePasswordReset': loginData['forcePasswordReset'] ?? false,
      });

      _isLoggedIn = true;

      // Guardar estado en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyUserId, _currentUser!.id);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _isLoggedIn = false;
      _currentUser = null;
      debugPrint('Error en login de AuthProvider: $e');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_keyRememberMe) ?? false;

    if (!rememberMe) {
      await clearSavedCredentials();
    }

    _isLoggedIn = false;
    _currentUser = null;
    await prefs.setBool(_keyIsLoggedIn, false);
    await prefs.remove(_keyUserId);
    notifyListeners();
  }

  Future<void> loadUserData() async {
    final userData = await _apiService.getUserProfile();
    _currentUser = User.fromJson(userData);
    notifyListeners();
  }

  Future<void> updateUserData(Map<String, dynamic> userData) async {
    debugPrint('Datos recibidos en updateUserData: $userData');
    _currentUser = User.fromJson(userData);
    debugPrint('Usuario actualizado: ${_currentUser?.toJson()}');
    notifyListeners();
  }
}
