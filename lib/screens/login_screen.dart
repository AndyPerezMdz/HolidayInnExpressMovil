import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:logger/logger.dart';
import '../widgets/illuminated_icon.dart';
import '../utils/page_transition.dart';
import '../screens/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;
  final _logger = Logger();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final credentials = await authProvider.getSavedCredentials();

    if (credentials['email'] != null && credentials['password'] != null) {
      setState(() {
        _userController.text = credentials['email']!;
        _passwordController.text = credentials['password']!;
        _rememberMe = credentials['rememberMe'] == 'true';
      });
    }
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Validación de campos vacíos
    if (_userController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, complete todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Guardar credenciales si está activada la opción
      await authProvider.saveCredentials(
        _userController.text.trim(),
        _passwordController.text,
        _rememberMe,
      );

      // Hacer login
      await authProvider.login(
        _userController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    } catch (e) {
      if (mounted) {
        String errorMessage;
        String errorStr = e.toString();

        // Manejamos los códigos de error específicos de la API
        if (errorStr.contains('Credenciales inválidas')) {
          errorMessage =
              'Credenciales inválidas. Verifica tu correo y contraseña.';
        } else if (errorStr.contains('404')) {
          errorMessage = 'Usuario no encontrado';
        } else if (errorStr.contains('500')) {
          errorMessage =
              'Error interno del servidor. Por favor, intente más tarde.';
        } else if (errorStr.contains('tiempo de espera') ||
            errorStr.contains('timeout')) {
          errorMessage =
              'El servidor está tardando en responder. Por favor, intente más tarde.';
        } else {
          _logger.e('Error no manejado', error: e);
          errorMessage = 'Error de conexión. Por favor, intente más tarde.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B2B39), Color(0xFF0E1A26)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset('assets/logo.png', height: 100),
                  const SizedBox(height: 20),

                  // Título
                  const Text(
                    "Inicio de sesión",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Campo usuario
                  _buildTextField(
                    controller: _userController,
                    hintText: "Nombre de usuario",
                    icon: Icons.person,
                    isPassword: false,
                  ),
                  const SizedBox(height: 15),

                  // Campo contraseña
                  _buildTextField(
                    controller: _passwordController,
                    hintText: "Contraseña",
                    icon: Icons.lock,
                    isPassword: true,
                  ),
                  const SizedBox(height: 10),

                  // Checkbox Recordar credenciales
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                        fillColor: WidgetStateProperty.resolveWith<Color>((
                          Set<WidgetState> states,
                        ) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.green;
                          }
                          return Colors.white;
                        }),
                      ),
                      const Text(
                        "Recordar credenciales",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Botón Iniciar sesión
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: _isLoading ? null : _handleLogin,
                      child:
                          _isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                "Iniciar sesión",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Olvidé la contraseña
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        SlideLeftTransition(page: const ForgotPasswordScreen()),
                      );
                    },
                    child: const Text(
                      "Olvidé la contraseña",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool isPassword,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && _obscurePassword,
      style: const TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 16,
          color: Color.fromARGB(179, 31, 31, 31),
        ),
        prefixIcon: IlluminatedIcon(
          icon: icon,
          size: 24,
          lightModeColor: const Color.fromARGB(129, 0, 0, 0),
          darkModeColor: const Color.fromARGB(129, 255, 255, 255),
        ),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: IlluminatedIcon(
                    icon:
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                    size: 24,
                    lightModeColor: const Color.fromARGB(129, 0, 0, 0),
                    darkModeColor: const Color.fromARGB(129, 255, 255, 255),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                )
                : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 20,
        ),
      ),
    );
  }
}
