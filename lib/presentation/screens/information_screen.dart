import 'package:cafeconhuellas_front/presentation/widgets/mapWidget.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:cafeconhuellas_front/theme/AppColors.dart';
import 'package:flutter/material.dart';

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
                child: const Text ("Hola! Nosotras somos patitas unidas, una protectora que nace del del amor profundo por los animales"
                      "y de la unión de tres amigas con el mismo sueño: darles una segunda oportunidad.",
                style: TextStyle(
                        fontFamily: "MilkyVintage",
                        fontSize: 23,
                        color: AppColors.brown,
                        fontWeight: FontWeight.w500,),
                        textAlign: TextAlign.center,)                
              ),
              Row (mainAxisSize: MainAxisSize.min,
                    children: [
                      _smallImage("assets/images/information_section/somos.jpg", 200),
                      const SizedBox(width: 15),
                      Padding(
                        padding: const EdgeInsets.only(top: 120),
                        child: _smallImage("assets/images/information_section/somos2.jpg", 140),
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
              image: "assets/images/information_section/proposito.jpg",
              text:
                  "Nuestra misión es clara: salvar, proteger y encontrar un hogar lleno de amor para todos los animales que lo necesiten"
                  "En Patitas Unidas luchamos por un mundo donde ningún animal tenga que vivir en el abandono.",
              reverse: false,
            ),
            const SizedBox(height: 60),
            //UBICACIÓN
              _sectionTitle("Aquí estamos:"),
             const MapWidget(),
             const SizedBox(height: 60),
             //HISTORIA
              _sectionTitle("Historia"),
              _infoSection(
              image: "assets/images/information_section/historia.jpg",
              text:
                  "Patitas unidas nace en 2023, cuando tres chicas tras finalizar sus estudios dedicieron plasmar la energía y amor por los animales"
                  "Durante ese momento de cambio en nuestras vidas, fuimos más conscientes que nunca de la realidad que viven muchos de los animales sin hogar"
                  "Así lo que comenzó como una idea se convirtío en un proyecto, trabajando ahora día a día para rescatar cuidary acompañar a cada animal que llega a nosotras"
                  ,
              reverse: false,
              imageTopPadding: 40,
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
    double imageTopPadding = 0,
  }) {
    final content = [
      _largeImage(image, topPadding: imageTopPadding),
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

  Widget _largeImage(String path, {double topPadding = 0}) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          path,
          width: 380,
          height: 260,
          fit: BoxFit.cover,
        ),
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
          fontFamily: "MilkyVintage",
          fontSize: 23,
          color: AppColors.brown,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
