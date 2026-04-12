import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:cafeconhuellas_front/theme/AppColors.dart';
import 'package:flutter/material.dart';


class DonationsScreen extends StatelessWidget {
  const DonationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppHeader(userImageUrl: "assets/user.png"),
            //banner
            Image.asset("assets/images/banners/banner-inicio.png", width: double.infinity, height: 400, fit:BoxFit.cover),
            const SizedBox(height: 40),

            /// TITULO
            const Text(
              "¿Quieres ayudarnos económicamente?",
              style: TextStyle(
                fontSize: 38,
                fontFamily: "WinkyMilky",
                color: AppColors.darkViolet,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 50),

            /// CONTENEDOR COLUMNAS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Wrap(
                spacing: 60,
                runSpacing: 40,
                alignment: WrapAlignment.center,
                children: [

                  /// SOCIO
                  _donationColumn(
                    context,
                    title: "¡Hazte socio!",
                    text:
                        "Hazte socio de nuestra protectora y ayúdanos con una "
                        "aportación mensual. Gracias a nuestros socios podemos "
                        "cubrir gastos veterinarios y alimentación.",
                    buttonText: "Hacerme socio",
                    route: "/formulario-socio",
                  ),

                  /// DONACION
                  _donationColumn(
                    context,
                    title: "¡Haznos una donación!",
                    text:
                        "También puedes ayudarnos mediante una donación puntual. "
                        "Cada aportación nos ayuda a seguir rescatando y cuidando animales.",
                    buttonText: "Donar",
                    route: "/donar",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
            AppFooter()
          ],
        ),
      ),
    );
  }

  /// COLUMNA DE DONACIÓN
  Widget _donationColumn(
    BuildContext context, {
    required String title,
    required String text,
    required String buttonText,
    required String route,
  }) {
    return SizedBox(
      width: 400,
      child: Column(
        children: [

          /// TITULO
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontFamily: "MilkyVintage",
              color: AppColors.charcoal,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          /// CARD
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.cream),
              color: Colors.white,
            ),
            child: Column(
              children: [

                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: "MilkyVintage",
                    color: AppColors.brown,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                /// BOTON
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 10,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, route);
                  },
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}