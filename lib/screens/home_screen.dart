import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          themeProvider.getText('welcome'),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/holidayinnexpressbanner-sinfondo.png',
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Check-in/out cards
            _buildInfoCard(
              context,
              title: themeProvider.getText('last_entry'),
              time: "09:00",
              date: "2024-03-20",
              imageUrl:
                  "https://t4.ftcdn.net/jpg/12/51/06/01/240_F_1251060186_3C9Pn66krfVNaxpcH1KkSmIo3SvSavWi.jpg",
            ),
            const SizedBox(height: 10),
            _buildInfoCard(
              context,
              title: themeProvider.getText('last_exit'),
              time: "18:00",
              date: "2024-03-20",
              imageUrl:
                  "https://t4.ftcdn.net/jpg/10/75/67/77/240_F_1075677703_FpDiLRjkEkoJZ8txclUHb2zU2U7kc9KK.jpg",
            ),
            const SizedBox(height: 20),

            // Announcements section
            Text(
              themeProvider.getText('announcements'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300, // Altura fija para el scroll de anuncios
              child: ListView(
                children: [
                  _buildAnnouncementCard(
                    context,
                    title: "Nueva política para el desayuno",
                    description:
                        "A partir del lunes, tenemos una nueva política sobre el desayuno. Detalles en el correo.",
                    date: "2024-03-20",
                    time: "09:00",
                  ),
                  const SizedBox(height: 10),
                  _buildAnnouncementCard(
                    context,
                    title: "Trabajo desde casa el viernes",
                    description:
                        "Debido a la construcción que se está haciendo en el hotel, no se podrá trabajar presencialmente.",
                    date: "2024-03-19",
                    time: "15:30",
                  ),
                  const SizedBox(height: 10),
                  _buildAnnouncementCard(
                    context,
                    title: "Mantenimiento programado",
                    description:
                        "El sistema estará en mantenimiento este domingo de 2 AM a 4 AM.",
                    date: "2024-03-18",
                    time: "11:00",
                  ),
                  const SizedBox(height: 10),
                  _buildAnnouncementCard(
                    context,
                    title: "Nuevos protocolos de seguridad",
                    description:
                        "Se han actualizado los protocolos de seguridad. Por favor revisa tu correo para más detalles.",
                    date: "2024-03-17",
                    time: "16:45",
                  ),
                  const SizedBox(height: 10),
                  _buildAnnouncementCard(
                    context,
                    title: "Actualización de uniformes",
                    description:
                        "La próxima semana se entregarán los nuevos uniformes. Pasa por RH para recoger el tuyo.",
                    date: "2024-03-16",
                    time: "10:15",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String time,
    required String date,
    required String imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(borderRadius),
        color: Theme.of(context).cardColor,
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
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  ),
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
                Text(
                  title,
                  style: titleStyle.copyWith(
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "$date - $time",
                  style: subtitleStyle.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard(
    BuildContext context, {
    required String title,
    required String description,
    required String date,
    required String time,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(borderRadius),
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: titleStyle.copyWith(
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: subtitleStyle.copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "$date - $time",
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
