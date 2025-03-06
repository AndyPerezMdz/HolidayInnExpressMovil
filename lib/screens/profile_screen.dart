import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import '../widgets/illuminated_icon.dart';

class ProfileAvatarAnimation extends StatefulWidget {
  final String name;
  final double radius;

  const ProfileAvatarAnimation({
    super.key,
    required this.name,
    required this.radius,
  });

  @override
  State<ProfileAvatarAnimation> createState() => _ProfileAvatarAnimationState();
}

class _ProfileAvatarAnimationState extends State<ProfileAvatarAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isRotating = false;

  static const textStyle = TextStyle(fontSize: 30, color: Colors.white);

  static const backgroundColor = Color.fromRGBO(35, 53, 103, 1);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _isRotating = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startRotation() {
    if (!_isRotating) {
      setState(() {
        _isRotating = true;
      });
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startRotation,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform:
                Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_animation.value * 6.28319),
            child: CircleAvatar(
              radius: widget.radius,
              backgroundColor: backgroundColor,
              child: Text(_getInitials(widget.name), style: textStyle),
            ),
          );
        },
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '??';
    if (name.length == 1) return name.toUpperCase();
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const double borderRadius = 8.0;
  bool _isLoading = false;

  Future<void> _refreshUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('Iniciando refresh de datos de usuario...');
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final apiService = ApiService();

      // Obtener el perfil actualizado
      final userData = await apiService.getUserProfile();
      debugPrint('Datos recibidos del API: $userData');

      // Actualizar el usuario en el provider
      await authProvider.updateUserData(userData);
      debugPrint(
        'Usuario actualizado en provider: ${authProvider.currentUser?.toJson()}',
      );

      // Verificar si los datos están presentes
      final updatedUser = authProvider.currentUser;
      if (updatedUser != null) {
        debugPrint('ID: ${updatedUser.id}');
        debugPrint('Email: ${updatedUser.email}');
        debugPrint('Department: ${updatedUser.department}');
        debugPrint('Status: ${updatedUser.status}');
        debugPrint('Address: ${updatedUser.address}');
      } else {
        debugPrint('¡ERROR: Usuario es null después de la actualización!');
      }
    } catch (e) {
      debugPrint('Error en _refreshUserData: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar datos: $e'),
            backgroundColor: Colors.red,
          ),
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null || _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: IlluminatedIcon(
            icon: Icons.arrow_back,
            size: 24,
            lightModeColor: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          themeProvider.getText('profile_info'),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _refreshUserData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(user),
              const SizedBox(height: 20),
              _buildSectionTitle('Información Personal'),
              _buildInfoCard(
                context,
                icon: Icons.person,
                label: themeProvider.getText('Nombre'),
                value: user.employeeName,
              ),
              _buildInfoCard(
                context,
                icon: Icons.email,
                label: themeProvider.getText('Email'),
                value: user.email,
              ),
              _buildInfoCard(
                context,
                icon: Icons.location_on,
                label: themeProvider.getText('Dirección'),
                value: user.address,
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Información Laboral'),
              _buildInfoCard(
                context,
                icon: Icons.business,
                label: themeProvider.getText('Departamento'),
                value: user.departmentName,
              ),
              _buildInfoCard(
                context,
                icon: Icons.info,
                label: themeProvider.getText('Estado'),
                value: user.status.toUpperCase(),
              ),
              _buildInfoCard(
                context,
                icon: Icons.admin_panel_settings,
                label: themeProvider.getText('Rol'),
                value: user.role,
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Registro de Asistencia'),
              _buildInfoCard(
                context,
                icon: Icons.login,
                label: themeProvider.getText('Último check in'),
                value: user.lastCheckIn,
              ),
              _buildInfoCard(
                context,
                icon: Icons.logout,
                label: themeProvider.getText('Último check out'),
                value: user.lastCheckOut,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Center(
      child: Column(
        children: [
          ProfileAvatarAnimation(radius: 50, name: user.employeeName),
          const SizedBox(height: 16),
          Text(
            user.employeeName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          Text(
            user.departmentName,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Si es el estado, mostrar un indicador visual
    if (label == themeProvider.getText('Estado')) {
      return Card(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IlluminatedIcon(
                    icon: icon,
                    size: 24,
                    lightModeColor:
                        Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  const SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      value.toLowerCase() == 'activo'
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            value.toLowerCase() == 'activo'
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      value,
                      style: TextStyle(
                        color:
                            value.toLowerCase() == 'activo'
                                ? Colors.green
                                : Colors.red,
                        fontWeight: FontWeight.w500,
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

    // Para el resto de campos, mantener el diseño original
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IlluminatedIcon(
                  icon: icon,
                  size: 24,
                  lightModeColor: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                const SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
