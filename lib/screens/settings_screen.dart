import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Configuración",
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold, 
            color: Color.fromRGBO(35, 53, 103, 1)),
        ),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,

      // Cuerpo: Solo un botón de "Cerrar Sesión"
      body: Center(
        child: SizedBox(
          width: 200, // Ajusta el ancho del botón
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(35, 53, 103, 1), // Color rojo para el botón de cerrar sesión
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Bordes redondeados
              ),
            ),
            onPressed: () {
              // Acción de cierre de sesión
              Navigator.pushNamed(context, '/'); // Redirige a la pantalla de login
            },
            child: const Text(
              "Salir",
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),

      // 🔹 Barra de navegación inferior (igual que en las otras pantallas)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3, // ✅ Indica que estamos en Settings
        selectedItemColor: const Color.fromRGBO(35, 53, 103, 1),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,  // ✅ Muestra los nombres de los ítems seleccionados
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          }
          if (index == 1) {
            Navigator.pushNamed(context, '/qr');
          }
          if (index == 2) {
            Navigator.pushNamed(context, '/reports');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Casa'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'Codigo QR'),
          BottomNavigationBarItem(icon: Icon(Icons.picture_as_pdf), label: 'Reportes'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
        ],
      ),
    );
  }
}
