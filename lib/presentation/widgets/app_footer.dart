import 'package:cafeconhuellas_front/theme/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Responsive footer displayed at the bottom of every page.
///
/// Contains the app logo, contact info,
/// address, and navigation links.
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive spacing based on screen width.
    final screenWidth = MediaQuery.sizeOf(context).width;
    final sectionSpacing = screenWidth > 1200 ? 70.0 : screenWidth > 900 ? 48.0 : 34.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
      decoration: const BoxDecoration(
        color: Color(0xFFB39DDB),
        border: Border(
          top: BorderSide(
            color: Color(0xFF7E57C2),
          ),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: sectionSpacing,
            runSpacing: sectionSpacing,
            children: [
              // Logo
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/logo.png', width: 100),
                ],
              ),
              // Contact section
              _footerColumn(
                title: "Contacto",
                children: const [
                  Text("+34 600 123 456", style: TextStyle(fontFamily: 'WinkyMilky', fontSize: 18, color: AppColors.darkViolet)),
                  Text("contacto@miapp.com", style: TextStyle(fontFamily: 'WinkyMilky', fontSize: 18, color: AppColors.darkViolet)),
                  Text("Lun - Vie: 9:00 - 18:00", style: TextStyle(fontFamily: 'WinkyMilky', fontSize: 18, color: AppColors.darkViolet)),
                ],
              ),
              // Address section
              _footerColumn(
                title: "Dirección",
                children: const [
                  Text("Calle Principal 123", style: TextStyle(fontFamily: 'WinkyMilky', fontSize: 18, color: AppColors.darkViolet)),
                  Text("Madrid, España", style: TextStyle(fontFamily: 'WinkyMilky', fontSize: 18, color: AppColors.darkViolet)),
                  Text("CP 28001", style: TextStyle(fontFamily: 'WinkyMilky', fontSize: 18, color: AppColors.darkViolet)),
                ],
              ),
              // Navigation links section
              _footerColumn(
                title: "Navegación",
                children: [
                  _footerLink(context, "Inicio", "/"),
                  _footerLink(context, "Mascotas", "/pets"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper that builds a labeled column of footer items.
  Widget _footerColumn({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 25,
            color: AppColors.darkViolet,
            fontFamily: 'WinkyMilky',
          ),
        ),
        const SizedBox(height: 10),
        ...children,
      ],
    );
  }

  // Helper that builds a tappable navigation link.
  Widget _footerLink(BuildContext context, String text, String route) {
    return GestureDetector(
      onTap: () {
        context.go(route);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: AppColors.darkViolet,
            fontFamily: 'WinkyMilky',
          ),
        ),
      ),
    );
  }
}