import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../models/advertisement.dart';
import '../widgets/illuminated_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Advertisement> _announcements = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.currentUser?.id;
      debugPrint('ID del usuario actual: $userId');

      if (userId != null) {
        try {
          // Remove the following block since it's no longer needed
          /*
          final lastCheckInOut = await _apiService.getLastCheckInOut(userId);
          debugPrint('Respuesta completa de último registro: $lastCheckInOut');

          if (mounted) {
            setState(() {
              _lastCheckInOut = {
                'lastCheckIn': lastCheckInOut['lastCheckIn'] ?? 'SIN REGISTRO',
                'lastCheckOut':
                    lastCheckInOut['lastCheckOut'] ?? 'SIN REGISTRO',
              };
            });
          }
          */
        } catch (e) {
          debugPrint('Error al cargar último registro: $e');
        }

        try {
          final userProfile = await _apiService.getUserProfile();
          final department = userProfile['department'];
          final advertisements = await _apiService.getAdvertisements(
            department,
          );
          debugPrint('Anuncios recibidos: $advertisements');
          if (mounted) {
            setState(() {
              _announcements = advertisements;
            });
          }
        } catch (e) {
          debugPrint('Error al cargar anuncios: $e');
        }

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        debugPrint('No hay usuario logueado (userId es null)');
      }
    } catch (e) {
      debugPrint('Error general: $e');
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final lastCheckIn = authProvider.currentUser?.lastCheckIn ?? 'No hay historial';
    final lastCheckOut = authProvider.currentUser?.lastCheckOut ?? 'No hay historial';

    // Suponiendo que lastCheckIn y lastCheckOut son cadenas de texto
    // Si son DateTime, puedes formatearlos aquí
    String checkInTime =
        lastCheckIn; // Aquí puedes formatear la hora si es necesario
    String checkOutTime =
        lastCheckOut; // Aquí puedes formatear la hora si es necesario

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
      body: RefreshIndicator(
        
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  'assets/holidayinnexpressbanner.png', // Reemplaza con la ruta de tu imagen
                  width:
                      MediaQuery.of(context)
                          .size
                          .width, // Ajusta el tamaño para que ocupe todo el ancho
                  height: MediaQuery.of(context).size.height * 0.27,
                  fit:
                      BoxFit
                          .cover, // Asegura que la imagen se ajuste correctamente
                ),
              ),
              const SizedBox(height: 20),
              _buildInfoCard(
                context,
                title: themeProvider.getText('last_entry'),
                time: 'Hora: $checkInTime', // Mostrar la hora del check-in
                date: '', // Puedes formatear la fecha si es necesario
                imageUrl: 'assets/check-in.jpg',
              ),
              const SizedBox(height: 20),
              _buildInfoCard(
                context,
                title: themeProvider.getText('last_exit'),
                time: 'Hora: $checkOutTime', // Mostrar la hora del check-out
                date: '', // Puedes formatear la fecha si es necesario
                imageUrl: 'assets/check-out.jpg',
              ),
              const SizedBox(height: 20),
              Text(
                themeProvider.getText('announcements'),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.50,
                    child:
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _error != null
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Error al cargar datos: $_error',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  ElevatedButton(
                                    onPressed: _refreshData,
                                    child: const Text('Reintentar'),
                                  ),
                                ],
                              ),
                            )
                            : _announcements.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.announcement_outlined,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No hay anuncios disponibles',
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.color,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: _announcements.length,
                              separatorBuilder:
                                  (context, index) =>
                                      const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final announcement = _announcements[index];
                                return _buildAnnouncementCard(
                                  context,
                                  announcement: announcement,
                                );
                              },
                            ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Widget _buildAnnouncementCard(BuildContext context, {required Advertisement announcement}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black.withAlpha(51)  // Changed from withOpacity(0.2)
            : Colors.grey.withAlpha(26),   // Changed from withOpacity(0.1)
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF233567).withAlpha(77)
                            : const Color(0xFF233567).withAlpha(26),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const IlluminatedIcon(
                    icon: Icons.campaign,
                    size: 28,
                    lightModeColor: Color(0xFF233567),
                    darkModeColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        announcement.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : const Color(0xFF233567),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white.withAlpha(26)
                                  : const Color(0xFF233567).withAlpha(26),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Departamento: ${announcement.departments}',
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white.withAlpha(179)
                                    : const Color(0xFF233567).withAlpha(179),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withAlpha(51)
                        : Colors.grey.withAlpha(13),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                announcement.description,
                style: TextStyle(
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withAlpha(230)
                          : Colors.black87,
                  fontSize: 15,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildDateChip(
                  context,
                  icon: Icons.event_available,
                  date: _formatDate(announcement.issueDate),
                  lightColor: Colors.green,
                  darkColor: Colors.green.shade300,
                ),
                const SizedBox(width: 12),
                _buildDateChip(
                  context,
                  icon: Icons.event_busy,
                  date: _formatDate(announcement.expirationDate),
                  lightColor: Colors.red,
                  darkColor: Colors.red.shade300,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateChip(
    BuildContext context, {
    required IconData icon,
    required String date,
    required Color lightColor,
    required Color darkColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withAlpha(26)
                : Colors.grey.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IlluminatedIcon(
            icon: icon,
            size: 16,
            lightModeColor: lightColor,
            darkModeColor: darkColor,
          ),
          const SizedBox(width: 6),
          Text(
            date,
            style: TextStyle(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withAlpha(230)
                      : Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {
    required String title,
    required String time,
    required String date,
    required String imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black.withAlpha(51)  // Changed from withOpacity(0.2)
            : Colors.grey.withAlpha(26),   // Changed from withOpacity(0.1)
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                // Removed only the boxShadow, keeping the container and image
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    time,
                    style: TextStyle(
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white70
                              : Theme.of(context).textTheme.bodyMedium?.color,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white54
                              : Theme.of(context).textTheme.bodyMedium?.color,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}