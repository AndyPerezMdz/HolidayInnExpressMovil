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
            color: Colors.black,
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
            // Imagen de perfil y detalles del usuario
            Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://cdn.usegalileo.ai/sdxl10/139696f9-3302-4639-bcc5-b88e81a03388.png',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Jenny Clarke, Customer Service',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'Joined in 2019',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tarjetas de Check-in y Check-out
            _buildInfoCard(
              title: "Last check-in",
              time: "09:00",
              imageUrl:
                  "https://t4.ftcdn.net/jpg/12/51/06/01/240_F_1251060186_3C9Pn66krfVNaxpcH1KkSmIo3SvSavWi.jpg",
            ),
            const SizedBox(height: 10),
            _buildInfoCard(
              title: "Last check-out",
              time: "18:00",
              imageUrl:
                  "https://t4.ftcdn.net/jpg/10/75/67/77/240_F_1075677703_FpDiLRjkEkoJZ8txclUHb2zU2U7kc9KK.jpg",
            ),
            const SizedBox(height: 20),

            // Sección de anuncios
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Announcements',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildAnnouncementCard(
              title: "New policy for lunch break",
              description:
                  "Starting from next Monday, we have a new policy for lunch break. Check the details in your email.",
            ),
            const SizedBox(height: 10),
            _buildAnnouncementCard(
              title: "Work from home on Friday",
              description:
                  "Due to the construction work in the building, we can work from home on Friday.",
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,  // ✅ Muestra los nombres de los ítems seleccionados
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'QR Code'),
          BottomNavigationBarItem(icon: Icon(Icons.picture_as_pdf), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
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
