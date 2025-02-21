import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Bienvenido.',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(35, 53, 103, 1),
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false, // Oculta el botón de retroceso
      ),

      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ Banner de la empresa (de extremo a extremo)
            ClipRRect(
              borderRadius: BorderRadius.circular(10), // Opcional: bordes redondeados
              child: Image.asset(
                'assets/holidayinnexpressbanner.png',
                width: double.infinity, // Ocupar todo el ancho
                height: 150, // Altura ajustada para visibilidad
                fit: BoxFit.cover, // Asegura que la imagen cubra toda el área
              ),
            ),
            const SizedBox(height: 10),

            // Tarjetas de Check-in y Check-out
            _buildInfoCard(
              title: "Última entrada",
              time: "09:00",
              imageUrl:
                  "https://t4.ftcdn.net/jpg/12/51/06/01/240_F_1251060186_3C9Pn66krfVNaxpcH1KkSmIo3SvSavWi.jpg",
            ),
            const SizedBox(height: 10),
            _buildInfoCard(
              title: "Última salida",
              time: "18:00",
              imageUrl:
                  "https://t4.ftcdn.net/jpg/10/75/67/77/240_F_1075677703_FpDiLRjkEkoJZ8txclUHb2zU2U7kc9KK.jpg",
            ),
            const SizedBox(height: 20),

            // Sección de anuncios
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Anuncios',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildAnnouncementCard(
              title: "Nueva política para el desayuno",
              description:
                  "A partir del lunes, tenemos una nueva política sobre el desayuno. Detalles en el correo.",
            ),
            const SizedBox(height: 10),
            _buildAnnouncementCard(
              title: "Trabajo desde casa el viernes",
              description:
                  "Debido a la construcción que se está haciendo en el hotel, no se podrá trabajar presencialmente.",
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color.fromRGBO(35, 53, 103, 1),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true, // ✅ Muestra los nombres de los ítems seleccionados
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/qr');
          }
          if (index == 2) {
            Navigator.pushNamed(context, '/reports');
          }
          if (index == 3) {
            Navigator.pushNamed(context, '/settings');
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

  Widget _buildInfoCard({
    required String title,
    required String time,
    required String imageUrl,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  time,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard({
    required String title,
    required String description,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
