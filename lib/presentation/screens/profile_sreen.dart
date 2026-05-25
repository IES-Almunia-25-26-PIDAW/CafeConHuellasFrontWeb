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

/// Screen that displays the current user's profile information.
///
/// This screen contains:
/// - Profile avatar with change photo option.
/// - User name, email, phone, and role.
/// - Navigation button to the admin panel or user panel.
/// - Logout button.
///
/// It also includes the application's shared
/// header and footer components.
class ProfileScreen extends StatefulWidget {
  /// Creates the profile screen widget.
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

/// State class responsible for managing:
/// - Avatar upload state.
/// - Avatar change dialog.
/// - Widget lifecycle.
class _ProfileScreenState extends State<ProfileScreen> {

  /// Whether an avatar upload is currently in progress.
  bool _uploadingAvatar = false;

  /// Shows a confirmation dialog and handles avatar image selection and upload.
  ///
  /// On confirmation:
  /// - Opens the device image gallery.
  /// - Uploads the selected image to the backend.
  /// - Dispatches [UpdateAvatarRequested] to [AuthBloc] on success.
  ///
  /// Shows a success or error [SnackBar] depending on the result.
  /// Verifies [mounted] before using [BuildContext] after async gaps.
  Future<void> _onAvatarTap(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Cambiar foto de perfil"),
        content: const Text("¿Quieres seleccionar una nueva foto de perfil?"),
        actions: [
          /// Cancel button.
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancelar"),
          ),
          /// Confirm selection button.
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

    /// Exit if the user cancelled.
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

      /// Verify mounted before using context after the async gap.
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

  /// Builds the profile screen UI.
  ///
  /// Layout structure:
  /// - Application header.
  /// - Banner with floating avatar.
  /// - Profile card with user info.
  /// - Admin panel or user panel button (role dependent).
  /// - Logout button.
  /// - Application footer.
  ///
  /// Shows a loading state if user data is not yet available.
  /// Shows a not-authenticated message if the user is not logged in.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {

          /// Not authenticated state.
          if (!state.isAuthenticated) {
            return const Center(child: Text("No has iniciado sesión"));
          }

          final user = state.user;
          final bool isAdmin = user?.role.toUpperCase() == "ADMIN";

          return SingleChildScrollView(
            child: Column(
              children: [
                /// Shared application header.
                AppHeader(),
                /// Banner with floating avatar.
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    /// Background banner image.
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
                    /// Floating avatar with tap-to-change support.
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
                              /// Shows loading indicator while uploading,
                              /// otherwise shows the user's profile image.
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
                            /// Camera icon indicating the avatar is tappable.
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

                /// Profile card with user information and action buttons.
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
                              /// User data loaded state.
                              if (user != null) ...[
                                /// User full name.
                                Text(
                                  "${user.firstName} ${user.lastName1}",
                                  style: const TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "MilkyVintage",
                                  ),
                                ),
                                const SizedBox(height: 6),
                                /// User email.
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.grey[600],
                                    fontFamily: "MilkyVintage",
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Divider(),
                                const SizedBox(height: 10),
                                /// Phone and role info cards.
                                _infoCard(Icons.phone, "Teléfono", user.phone),
                                _infoCard(Icons.badge, "Rol", user.role),
                              ]

                              /// User data loading state.
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

                              /// Admin panel button, visible to admin users only.
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

                              /// User panel button, visible to regular users only.
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

                              /// Logout button.
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
                                  context.read<AuthBloc>().add(LogoutRequested());
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
                /// Shared application footer.
                const AppFooter(),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Creates a styled info card displaying a labeled value with an icon.
  ///
  /// Used for displaying:
  /// - Phone number.
  /// - User role.
  ///
  /// Parameters:
  /// - [icon]: Icon displayed on the left.
  /// - [label]: Small label text shown above the value.
  /// - [value]: Main value text displayed below the label.
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