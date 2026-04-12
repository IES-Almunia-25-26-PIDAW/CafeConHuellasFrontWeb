import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:cafeconhuellas_front/theme/AppColors.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column (
          children: [
            AppHeader(userImageUrl: "assets/user.png"),
            //banner
            Image.asset("assets/images/banners/banner-inicio.png", width: double.infinity, height: 400, fit:BoxFit.cover),
            const SizedBox(height: 60),
            //TITULO
            _title("¿Cómo puedes ayudar?"),
            //INTRO
            Padding(padding: const EdgeInsets.symmetric(horizontal: 60.0),
                    child:Wrap(
                      spacing: 40,
                      runSpacing: 40,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                         /// CARD TEXTO
                        _card(
                            child: const Text(
                            "Hay muchas formas de colaborar con nuestra protectora, "
                           "cada pequeña acción ayuda a cambiar la vida de nuestros animales.",
                            textAlign: TextAlign.center,
                            ),
                          ),
                        //CARD LINKS
                        _card(
                          child: Column(
                          children: [
                          _link(context, "Voluntariado"),
                          _link(context, "Casa de acogida"),
                          _link(context, "Paseos"),
                          _link(context, "Apadrinamiento"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 80),
                        //VOLUNTARIADO
                        _helpSection(
                          context,
                          title: "Voluntariado",
                          image: "assets/images/help_section/volunteering.jpg",
                          text: "Colabora con nosotros ayudando en el cuidado diario.",
                          button: "Quiero ser voluntario",
                          reverse: false,
                        ),
                        //CASA DE ACOGIDA
                        _helpSection(
                          context,
                          title: "Casa de acogida",
                          image: "assets/images/help_section/petfoster.jpg",
                          text: "Ofrece tu hogar temporalmente a un animal.",
                          button: "Ofrecer acogida",
                          reverse: true,
                        ),  
                        //PASEOS
                        _helpSection(
                          context,
                          title: "Paseos",
                          image: "assets/images/help_section/walks.jpg",
                          text: "Ayuda a nuestros perros saliendo a pasear.",
                          button: "Apuntarme a paseos",
                          reverse: false,
                        ),
                        //APADRINAMIENTO
                        _helpSection(
                          context,
                          title: "Apadrinamiento",
                          image: "assets/images/help_section/sponsorship.jpg",
                          text: "Contribuye económicamente al cuidado de un animal.",
                          button: "Apadrinar",
                          reverse: true,
                        ),
                        const SizedBox(height: 100),
                        
                        ]
                      )
                    ),
                    AppFooter()
                  ],
                )
      ),
    );
  }
}
  /// TITULO
  Widget _title(String text) {
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

  /// CARD
  Widget _card({required Widget child}) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cream),
        color: Colors.white,
      ),
      child: child,
    );
  }

  /// LINK CARD
  Widget _link(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextButton(
        onPressed: () {},
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 28,
            fontFamily: "MilkyVintage",
            color: AppColors.green,
          ),
        ),
      ),
    );
  }

  /// SECCIÓN DE AYUDA
  Widget _helpSection(
    BuildContext context, {
    required String title,
    required String image,
    required String text,
    required String button,
    required bool reverse,
  }) {
    final content = [
      /// IMAGEN
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          image,
          width: 380,
          height: 260,
          fit: BoxFit.cover,
        ),
      ),

      /// CARD INFO
      Container(
        width: 450,
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
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.brown,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/formulario");
              },
              child: Text(button),
            ),
          ],
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 60),
      child: Column(
        children: [
          _title(title),
          Wrap(
            spacing: 60,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: reverse ? content.reversed.toList() : content,
          ),
        ],
      ),
    );
  }
