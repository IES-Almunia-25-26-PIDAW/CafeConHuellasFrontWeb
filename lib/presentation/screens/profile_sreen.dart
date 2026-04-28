import 'dart:typed_data';

import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../bloc/auth_event.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _uploadingAvatar = false;

  //tenemos que mostrar el díalogo de confirmación si el usuario le hace tap a su foto de perfil para poder cambiar dicha foto de perfil:
  //el método para realizar eso es el siguiente:
  Future<void> _onAvatarTap(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Cambiar foto de perfil"),
        content: const Text("¿Quieres seleccionar una nueva foto de perfil?"),
        actions: [
          //botón para cancelar
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancelar"),
          ),
          //botón para seleccionar la foto
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Seleccionar"),
          ),
        ],
      ),
    );

    //si la confirmación no ha sido verdadera no hacemos nada, si ha sido verdadera abrimos el selector de imagen
    if (confirmed != true) return;

    final plugin = ImagePickerPlugin();
    final XFile? picked = await plugin.getImageFromSource(
      source: ImageSource.gallery,
      options: const ImagePickerOptions(maxWidth: 800, imageQuality: 85),
    );
    if (picked == null) return;

    final Uint8List bytes = await picked.readAsBytes();
    final String fileName = picked.name;

    setState(() => _uploadingAvatar = true);
    try {
      final String newImageUrl = await ApiConector().uploadAvatar(bytes, fileName);

      // el Bloc se encarga del PUT al backend y de actualizar el estado
      if (!context.mounted) return;
      context.read<AuthBloc>().add(UpdateAvatarRequested(newImageUrl));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Foto de perfil actualizada correctamente ✓"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al actualizar la foto: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _uploadingAvatar = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {

          // Si hay token, estamos autenticados, aunque falten datos del usuario
          if (!state.isAuthenticated) {
            return const Center(child: Text("No has iniciado sesión"));
          }
          // cogemos el usuario del estado del bloc
          final user = state.user;
          final bool isAdmin = user?.role.toUpperCase() == "ADMIN";
          return SingleChildScrollView(
            child: Column(
              children: [
                AppHeader(),
                // HEADER BONITO CON EL AVATAR FLOTANTE
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Banner
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/banners/banner-inicio.png",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                   // Avatar flotante para que se vea bonito, con GestureDetector para poder cambiar la foto
                    Positioned(
                      bottom: -50,
                      child: GestureDetector(
                        onTap: _uploadingAvatar
                            ? null
                            : () => _onAvatarTap(context),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 62,
                              backgroundColor: Colors.white,
                              // si está subiendo mostramos el loading, si no la foto
                              child: _uploadingAvatar
                                  ? const CircularProgressIndicator(
                                      color: Colors.purple)
                                  : CircleAvatar(
                                      radius: 56,
                                      backgroundImage: user != null &&
                                              user.imageUrl.isNotEmpty
                                          ? NetworkImage(user.imageUrl)
                                          : const AssetImage("assets/user.png")
                                              as ImageProvider,
                                    ),
                            ),
                            // icono de cámara para indicarle al usuario que puede pulsar para cambiar la foto
                            if (!_uploadingAvatar)
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.purple,
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // CONTENIDO
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            children: [
                              //si hemos podido obtener los datos del usuario, los mostramos en modo de tarjetita abajo para que se vea mas bonito
                              if (user != null) ...[
                                Text(
                                  "${user.firstName} ${user.lastName1}",
                                  style: const TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "MilkyVintage"
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.grey[600],
                                    fontFamily: "MilkyVintage"
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Divider(),
                                const SizedBox(height: 10),
                                // TARJETITAS BONITAS
                                _infoCard(Icons.phone, "Teléfono", user.phone),
                                _infoCard(Icons.badge, "Rol", user.role),
                              ]

                              // si no hemos podido obtener los datos del usuario mostramos loading
                              else ...[
                                const Text(
                                  "Sesión Activa",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                const Text(
                                  "Cargando datos del usuario...",
                                  style: TextStyle(color: Colors.grey),
                                ),

                                const SizedBox(height: 20),

                                const CircularProgressIndicator(
                                  color: Colors.purple,
                                ),
                              ],

                              const SizedBox(height: 30),

                              // botón de configuración web, solo visible si el usuario es ADMIN
                              //nos lleva a la página del admin
                              if (isAdmin) ...[
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => context.go('/panel'),
                                  icon: const Icon(Icons.settings),
                                  label: const Text("Configuración Web"),
                                ),
                                const SizedBox(height: 12),
                              ],
                              if (!isAdmin) ...[
                                 ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  onPressed: () => context.go('/panel'),
                                  icon: const Icon(Icons.person),
                                  label: const Text("Mis cosas"),
                                ),
                                const SizedBox(height: 12),
                              ],

                              // botón logout
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  context
                                      .read<AuthBloc>()
                                      .add(LogoutRequested());
                                  context.go('/');
                                },
                                icon: const Icon(Icons.logout),
                                label: const Text("Cerrar Sesión"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const AppFooter(),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget más bonito tipo card para mostrar la información del usuario, con un icono a la izquierda, el label y el valor, todo dentro de una caja con fondo gris claro y bordes redondeados.
  Widget _infoCard(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}