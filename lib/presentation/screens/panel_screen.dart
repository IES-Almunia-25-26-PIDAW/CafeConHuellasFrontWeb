import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Screen that serves as a navigation hub for the user or admin panel.
///
/// - Admin users see the administration panel with options to
///   manage donations and adoption requests.
/// - Regular users see their personal panel with options to
///   view their own donations and requests.
///
/// It also includes the application's shared
/// header and footer components.
class PanelScreen extends StatelessWidget {
  /// Creates the panel screen widget.
  const PanelScreen({super.key});

  /// Builds the panel screen UI.
  ///
  /// Layout structure:
  /// - Application header.
  /// - Banner image.
  /// - Screen title (dynamic based on user role).
  /// - Navigation cards grid.
  /// - Application footer.
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final bool isAdmin = authState.user?.role.toUpperCase() == 'ADMIN';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Shared application header.
            AppHeader(),
            /// Main banner image.
            Image.asset('assets/images/banners/banner-inicio.png',width: double.infinity, height: 250, fit: BoxFit.cover),
            const SizedBox(height: 40),
            /// Screen title, dynamic based on user role.
            Text(isAdmin ? 'Panel de Administración' : 'Mis cosas',style: const TextStyle(fontSize: 36,fontFamily: 'MilkyVintage',color: Color(0xFF7B3FE4),),
            ),
            const SizedBox(height: 40),
            /// Navigation cards grid.
            Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: [
                /// Donations navigation card.
                _panelCard(
                  context,
                  icon: Icons.volunteer_activism,
                  title: isAdmin ? 'Gestionar Donaciones' : 'Mis Donaciones',
                  subtitle: isAdmin
                      ? 'Ver todas las donaciones recibidas'
                      : 'Ver mis donaciones',
                  onTap: () => context.go('/panel/donations'),
                ),
                /// Adoption requests navigation card.
                _panelCard(
                  context,
                  icon: Icons.pets,
                  title: isAdmin ? 'Gestionar Peticiones' : 'Mis Peticiones',
                  subtitle: isAdmin
                      ? 'Gestionar solicitudes de adopción'
                      : 'Ver mis solicitudes de adopción',
                  onTap: () => context.go('/panel/relationships'),
                ),
              ],
            ),
            const SizedBox(height: 60),
            /// Shared application footer.
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  /// Creates a styled navigation card with an icon, title, subtitle,
  /// and tap callback.
  ///
  /// Parameters:
  /// - [icon]: Icon displayed inside the card avatar.
  /// - [title]: Main card title.
  /// - [subtitle]: Descriptive subtitle text.
  /// - [onTap]: Callback triggered when the card is tapped.
  Widget _panelCard(BuildContext context, {required IconData icon,required String title,required String subtitle,required VoidCallback onTap,}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.purple.shade100, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            /// Card icon avatar.
            CircleAvatar(
              radius: 32,
              backgroundColor: const Color(0xFF7B3FE4),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 16),
            /// Card title.
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'MilkyVintage',
              ),
            ),
            const SizedBox(height: 8),
            /// Card subtitle.
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}