import 'package:cafeconhuellas_front/theme/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final sectionSpacing = screenWidth > 1200 ? 70.0 : screenWidth > 900 ? 48.0 : 34.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
      decoration: const BoxDecoration(
        color: AppColors.purple,
        border: Border(
          top: BorderSide(
            color: AppColors.darkPurple,
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
            //logo
            Column(
              mainAxisSize:MainAxisSize.min,
              children: [
                Image.asset('assets/logo.png',width: 100,)
              ],
            ),
            //Contacto
            _footerColumn(
                title: "Contacto",
                children: const [
                  Text("+34 600 123 456", style: TextStyle(fontFamily: 'WinkyMilky', fontSize: 18, color: AppColors.darkViolet)),
                  Text("contacto@miapp.com", style: TextStyle(fontFamily: 'WinkyMilky', fontSize: 18, color: AppColors.darkViolet)),
                  Text("Lun - Vie: 9:00 - 18:00", style: TextStyle(fontFamily: 'WinkyMilky', fontSize: 18, color: AppColors.darkViolet)),
                ],
              ),
              //dirección
              _footerColumn(
                title: "Dirección",
                children: const [
                  Text("Calle Principal 123", style: TextStyle(fontFamily: 'WinkyMilky', fontSize: 18, color: AppColors.darkViolet)),
                  Text("Madrid, España", style: TextStyle(fontFamily: 'WinkyMilky', fontSize: 18, color: AppColors.darkViolet)),
                  Text("CP 28001", style: TextStyle(fontFamily: 'WinkyMilky', fontSize: 18, color: AppColors.darkViolet)),
                ],
              ),
               _footerColumn(
                title: "Navegación",
                children: [
                  _footerLink(context, "Inicio", "/"),
                  _footerLink(context, "Mascotas", "/pets"),])

          ],)
        ),
      ),
    );
  }

Widget _footerColumn ({
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

Widget _footerLink(BuildContext context,String text, String route) {
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