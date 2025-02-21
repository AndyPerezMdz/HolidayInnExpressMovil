import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const Color primaryColor = Color.fromRGBO(35, 53, 103, 1);
  static const double borderRadius = 16.0;
  static const TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Bienvenido',
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
              borderRadius: BorderRadius.circular(
                10,
              ), // Opcional: bordes redondeados
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
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String time,
    required String imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: titleStyle),
                const SizedBox(height: 5),
                Text(time, style: subtitleStyle),
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contenido principal (título y descripción)
            Expanded(
              flex: 7, // Ocupa 70% del espacio
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: titleStyle),
                  const SizedBox(height: 5),
                  Text(description, style: subtitleStyle),
                ],
              ),
            ),
            // Espacio para fecha y hora (30% del ancho)
            const Expanded(
              flex: 3, // Ocupa 30% del espacio
              child: SizedBox(), // Por ahora está vacío
            ),
          ],
        ),
      ),
    );
  }
}
