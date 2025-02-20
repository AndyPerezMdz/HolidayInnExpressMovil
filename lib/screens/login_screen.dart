import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B2B39), Color(0xFF0E1A26)], // Fondo degradado
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/logo.png',
                  height: 100,
                ),
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
                  hintText: "Nombre de usuario",
                  icon: Icons.person,
                  isPassword: false,
                ),
                const SizedBox(height: 15),

                // Campo contraseña
                _buildTextField(
                  hintText: "Contraseña",
                  icon: Icons.lock,
                  isPassword: true,
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
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home'); // Navega a Home
                    },
                    child: const Text(
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
                    // Acción para recuperar contraseña
                  },
                  child: const Text(
                    "Olvidé la contraseña",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget para construir los campos de texto con tamaño ajustado
  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    required bool isPassword,
  }) {
    return SizedBox(
      height: 40, // Ajusta la altura del input
      child: TextField(
        obscureText: isPassword,
        style: const TextStyle(fontSize: 18, color: Colors.black), // Tamaño del texto
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withValues(), // ✅ Corrección en fillColor
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 16, color: Color.fromARGB(179, 31, 31, 31)), // Tamaño del placeholder
          prefixIcon: Icon(icon, size: 24, color: const Color.fromARGB(129, 0, 0, 0)), // Tamaño del icono
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20), // Bordes redondeados
            borderSide: BorderSide.none, // Sin borde
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Ajuste interno
        ),
      ),
    );
  }
}
