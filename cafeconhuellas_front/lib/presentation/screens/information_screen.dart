import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:cafeconhuellas_front/theme/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          
          children: [
          AppHeader(userImageUrl: "assets/user.png"),
          //banner
          Image.asset("assets/images/banners/banner-inicio.png", width: double.infinity, height: 400, fit:BoxFit.cover),
          const SizedBox(height: 60),
          //Quienes somos
           _sectionTitle("¿Quiénes somos?"),
           Padding(padding: const EdgeInsets.symmetric(horizontal: 60.0),
           child: Wrap (
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: [
              //card texto
              Container(
                width: 400,
                padding: const EdgeInsets.all(35),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cream),
                  ),
                child: const Text ("Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                      "Curabitur tristique elit elit. Nunc dictum mauris sit amet "
                      "quam vestibulum lobortis.",
                style: TextStyle(
                        fontSize: 18,
                        color: AppColors.brown,
                        fontWeight: FontWeight.w500,),
                        textAlign: TextAlign.center,)                
              ),
              Row (mainAxisSize: MainAxisSize.min,
                    children: [

                      _smallImage("assets/help/protectora1.jpg", 200),

                      const SizedBox(width: 15),

                      Padding(
                        padding: const EdgeInsets.only(top: 120),
                        child: _smallImage("assets/help/protectora2.jpg", 140),
                      ),
                    ],
                  ),
                ]
              ),
            ),
              const SizedBox(height: 60),
              //NUESTRO PROPOSITO
              _sectionTitle("Nuestro propósito:"),
              _infoSection(
              image: "assets/help/voluntariado.jpg",
              text:
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur tristique elit elit.",
              reverse: false,
            ),
            const SizedBox(height: 60),
            //UBICACIÓN
              _sectionTitle("Aquí estamos:"),
             _infoSection(
              image: "assets/help/acogida.jpg",
              text:
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
              reverse: true,
            ),
             const SizedBox(height: 60),
             //HISTORIA
              _sectionTitle("Historia"),
              _infoSection(
              image: "assets/help/paseos.jpg",
              text:
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
              reverse: false,
            ),
             const SizedBox(height: 80),
            //FOOTER
            AppFooter()
          ]
        ),
      ),
    );

  }
}
/// TITULO DE SECCION
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 38,
          fontFamily: "WinkyMilky",
          color: AppColors.darkViolet,
        ),
      ),
    );
  }

  /// SECCION CON IMAGEN + TEXTO
  Widget _infoSection({
    required String image,
    required String text,
    required bool reverse,
  }) {
    final content = [
      _largeImage(image),
      _infoCard(text),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 60,
        runSpacing: 30,
        children: reverse ? content.reversed.toList() : content,
      ),
    );
  }

  Widget _largeImage(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        path,
        width: 380,
        height: 260,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _smallImage(String path, double height) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cream),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          path,
          width: 180,
          height: height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _infoCard(String text) {
    return Container(
      width: 450,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.cream),
        color: Colors.white,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          color: AppColors.brown,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
