import 'package:cafeconhuellas_front/presentation/bloc/pet_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_state.dart';
import 'package:cafeconhuellas_front/presentation/widgets/actionitem.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:cafeconhuellas_front/presentation/widgets/eventcard.dart';
import 'package:cafeconhuellas_front/presentation/widgets/petcard.dart';
import 'package:cafeconhuellas_front/theme/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            Image.asset(
              "assets/images/banners/banner-inicio.png",
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
            ),
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
                ActionItem(
                  "assets/icons/rescate.png",
                  "Rescatamos animales en situación de abandono.",
                ),
                ActionItem(
                  "assets/icons/cuidados.png",
                  "Les damos cuidados veterinarios y alimentación.",
                ),
                ActionItem(
                  "assets/icons/adopcion.png",
                  "Buscamos familias responsables para adopción.",
                ),
                ActionItem(
                  "assets/icons/educacion.png",
                  "Concienciamos sobre el respeto animal.",
                ),
              ],
            ),
            const SizedBox(height: 60),
            //Mascotas
            _sectionTitle("Nuestras mascotas"),
            BlocBuilder<PetsBloc, PetsState>(
              builder: (context, state) {
                //si estña cargando mostramos un indicador de carga
                if (state.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: CircularProgressIndicator(),
                  );
                }
                //si hay un error lo mostramos
                if (state.errorMessage != null) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      state.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                //si todo va bien guardo los pets en una variable y los muestro
                final pets = state.pets.take(4).toList();
                //si no he podido coger mascotas retorno un aviso
                if (pets.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text("No hay mascotas disponibles en este momento."),
                  );
                }
                //si he podido cargar mascotas muestro pet cards
                return Wrap(
                  spacing: 30,
                  runSpacing: 30,
                  alignment: WrapAlignment.center,
                  children: pets.map((pet) => PetCard(pet)).toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            //añado un botón que me lleva hasta la página de mascotas
            ElevatedButton(
              onPressed: () {
                context.go("/pets");
              },
              child: const Text("Ver más"),
            ),
            const SizedBox(height: 60),
            //Sección de eventos
            _sectionTitle("Eventos"),
            //funciona exactamente igual que la sección de mascotas, pero con eventos en vez de mascotas
            BlocBuilder<PetsBloc, PetsState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: CircularProgressIndicator(),
                  );
                }
                if (state.errorMessage != null) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      state.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                final events = state.events.take(3).toList();

                if (events.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text("No hay eventos disponibles en este momento."),
                  );
                }
                //si he podido cargar eventos muestro event cards, gracias al método map
                return Wrap(
                  spacing: 30,
                  runSpacing: 30,
                  alignment: WrapAlignment.center,
                  children: events.map((event) => EventCard(
                    event.imageUrl,
                    event.name,
                    event.description,
                  )).toList(),
                );
              },
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
            AppFooter(),
          ],
        ),
      ),
    );
  }

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
}
