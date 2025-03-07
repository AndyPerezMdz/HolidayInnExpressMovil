import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart'; // Asegúrate de importar el AuthProvider
import 'package:http/http.dart' as http;
import 'dart:convert';

class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({super.key});

  Future<void> _requestPasswordReset(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final email =
        authProvider
            .currentUser
            ?.email; // Obtener el correo del usuario logueado

    if (email == null) {
      // Manejar el caso en que no hay usuario logueado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo obtener el correo electrónico.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Pregunta de confirmación
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            'Confirmar',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          content: Text(
            '¿Está seguro de que desea restablecer su contraseña?',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Confirmar',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // Enviar la solicitud al endpoint
      final response = await http.post(
        Uri.parse('https://devmace.onrender.com/auth/request-password-reset'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        // Manejar la respuesta exitosa
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Se ha enviado un enlace de recuperación al correo electrónico.',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(
          context,
          '/',
        ); // Regresar a la pantalla de inicio de sesión
      } else {
        // Manejar el error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${json.decode(response.body)['message']}'),
            backgroundColor: Colors.red,
          ),
        );
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
          child: Stack(
            children: [
              // Botón de regreso
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed:
                      () => Navigator.pop(
                        context,
                      ), // Regresar a la pantalla anterior
                ),
              ),
              // Contenido principal
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/logo.png', height: 100),
                      const SizedBox(height: 20),
                      const Text(
                        "Se enviará un correo con las instrucciones de recuperación de contraseña.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed:
                            () => _requestPasswordReset(
                              context,
                            ), // Llamar a la función de solicitud
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: const Size(200, 50),
                        ),
                        child: const Text(
                          "Enviar correo",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
