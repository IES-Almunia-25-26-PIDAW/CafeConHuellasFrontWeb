import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PanelScreen extends StatelessWidget {
  const PanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final bool isAdmin = authState.user?.role.toUpperCase() == 'ADMIN';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppHeader(),
            Image.asset('assets/images/banners/banner-inicio.png',
                width: double.infinity, height: 250, fit: BoxFit.cover),
            const SizedBox(height: 40),
            Text(
              isAdmin ? 'Panel de Administración' : 'Mis cosas',
              style: const TextStyle(
                fontSize: 36,
                fontFamily: 'MilkyVintage',
                color: Color(0xFF7B3FE4),
              ),
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: [
                _panelCard(
                  context,
                  icon: Icons.volunteer_activism,
                  title: isAdmin ? 'Gestionar Donaciones' : 'Mis Donaciones',
                  subtitle: isAdmin
                      ? 'Ver todas las donaciones recibidas'
                      : 'Ver mis donaciones',
                  onTap: () => context.go('/panel/donations'),
                ),
                _panelCard(
                  context,
                  icon: Icons.pets,
                  title: isAdmin ? 'Gestionar Peticiones' : 'Mis Peticiones',
                  subtitle: isAdmin
                      ? 'Gestionar solicitudes de adopción'
                      : 'Ver mis solicitudes de adopción',
                  onTap: () {}, 
                ),
              ],
            ),
            const SizedBox(height: 60),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _panelCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
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
            BoxShadow(color: Colors.purple.withOpacity(0.08),
                blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: const Color(0xFF7B3FE4),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 16),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'MilkyVintage')),
            const SizedBox(height: 8),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}