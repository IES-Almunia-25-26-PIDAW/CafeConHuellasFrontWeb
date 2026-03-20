
import 'package:cafeconhuellas_front/presentation/widgets/actionitem.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:cafeconhuellas_front/presentation/widgets/eventcard.dart';
import 'package:cafeconhuellas_front/presentation/widgets/petcard.dart';
import 'package:cafeconhuellas_front/theme/AppColors.dart';
import 'package:cafeconhuellas_front/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
          AppHeader(userImageUrl: "assets/user.png"),
          //banner
          Image.asset("assets/images/banners/banner-inicio.png", width: double.infinity, height: 400, fit:BoxFit.cover),
          //Quienes somos
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
            child: Text(
              "¡Bienvenid@ a 'Nombre de protectora'! Somos una protectora dedicada al rescate, cuidado y adopción responsable de animales que necesitan una segunda oportunidad.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontFamily: "MilkyVintage",
                color: AppColors.brown,
              ),
            ),
          ),
          //que hacemos
          _sectionTitle("Qué hacemos"),
           Wrap(
            spacing: 60,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: const [
              ActionItem("assets/icons/rescate.png",
                  "Rescatamos animales en situación de abandono."),
                ActionItem("assets/icons/cuidados.png",
                  "Les damos cuidados veterinarios y alimentación."),
                ActionItem("assets/icons/adopcion.png",
                  "Buscamos familias responsables para adopción."),
                ActionItem("assets/icons/educacion.png",
                  "Concienciamos sobre el respeto animal."),
            ],
          ),
          const SizedBox(height: 60),
          //Mascotas
            _sectionTitle("Nuestras mascotas"),
          /*
          FutureBuilder<List<Pet>>(
            future: ApiConector().getPets(),
            builder: (context, snapshot) {
              ...
            },
          ),
          */
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: Globals.pets
                .take(4)
                .map((pet) => PetCard(pet))
                .toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.go("/pets");
            },
            child: const Text("Ver más"),
          ),
          const SizedBox(height: 60),
          //Eventos
          _sectionTitle("Eventos"),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: const [
              EventCard(
                "assets/images/events/event1.jpg",
                "Feria de adopción",
                "Ven a conocer a nuestros animales este sábado.",
              ),
              EventCard(
                "assets/images/events/event2.jpg",
                "Charla educativa",
                "Aprende sobre tenencia responsable.",
              ),
              EventCard(
                "assets/images/events/event3.jpg",
                "Jornada solidaria",
                "Recaudación de fondos para el refugio.",
              ),
            ],
          ),

          const SizedBox(height: 60),
          //videojuego
           _sectionTitle("¡Prueba nuestro videojuego!"),

          ElevatedButton(
            onPressed: () {
              context.go("/videojuego");
            },
            child: const Text("Jugar ahora →"),
          ),
          const SizedBox(height: 80),
          //footer
          AppFooter()

          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Text (
        text,
        style: const TextStyle(
          fontSize: 38,
          fontFamily: "WinkyMilky",
          color: AppColors.darkViolet
        )
      )
    );
  }
}
