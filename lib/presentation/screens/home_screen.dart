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

/// Main landing screen of the application.
///
/// This screen contains:
/// - Organization welcome message.
/// - "What we do" action items section.
/// - Featured pets section.
/// - Upcoming events section.
/// - Link to the mini game.
///
/// It also includes the application's shared
/// header and footer components.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// Builds the home screen UI.
  ///
  /// Layout structure:
  /// - Application header.
  /// - Banner image.
  /// - Welcome text.
  /// - Action items section.
  /// - Featured pets loaded from [PetsBloc].
  /// - Events loaded from [PetsBloc].
  /// - Mini game button.
  /// - Application footer.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Shared application header.
            AppHeader(userImageUrl: "assets/user.png"),
            /// Main banner image.
            Image.asset(
              "assets/images/banners/banner-inicio.png",
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
            ),
            /// Organization welcome message.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
              child: Text(
                "¡Bienvenid@ a 'Patitas Unidas'! Somos una protectora dedicada al rescate, cuidado y adopción responsable de animales que necesitan una segunda oportunidad.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "MilkyVintage",
                  color: AppColors.brown,
                ),
              ),
            ),
            /// "What we do" section.
            _sectionTitle("Qué hacemos"),
            Wrap(
              spacing: 60,
              runSpacing: 40,
              alignment: WrapAlignment.center,
              children: const [
                ActionItem("assets/icons/rescate.png", "Rescatamos animales en situación de abandono."),
                ActionItem("assets/icons/cuidados.png", "Les damos cuidados veterinarios y alimentación."),
                ActionItem("assets/icons/adopcion.png", "Buscamos familias responsables para adopción."),
                ActionItem("assets/icons/educacion.png", "Concienciamos sobre el respeto animal."),
              ],
            ),
            const SizedBox(height: 60),
            /// Featured pets section loaded from [PetsBloc].
            _sectionTitle("Nuestras mascotas"),
            BlocBuilder<PetsBloc, PetsState>(
              builder: (context, state) {
                /// Loading state.
                if (state.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: CircularProgressIndicator(),
                  );
                }
                /// Error state.
                if (state.errorMessage != null) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      state.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                final pets = state.pets.take(4).toList();
                /// Empty state.
                if (pets.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text("No hay mascotas disponibles en este momento."),
                  );
                }
                /// Pet cards list.
                return Wrap(
                  spacing: 30,
                  runSpacing: 30,
                  alignment: WrapAlignment.center,
                  children: pets.map((pet) => PetCard(pet, fixedWidth: 220)).toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            /// Button linking to the full pets screen.
            ElevatedButton(
              onPressed: () => context.go("/pets"),
              child: const Text("Ver más"),
            ),
            const SizedBox(height: 60),
            /// Events section loaded from [PetsBloc].
            _sectionTitle("Eventos"),
            BlocBuilder<PetsBloc, PetsState>(
              builder: (context, state) {
                /// Loading state.
                if (state.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: CircularProgressIndicator(),
                  );
                }
                /// Error state.
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
                /// Empty state.
                if (events.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text("No hay eventos disponibles en este momento."),
                  );
                }
                /// Event cards list.
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
            /// Mini game section.
            _sectionTitle("¡Prueba nuestro videojuego!"),
            ElevatedButton(
              onPressed: () => context.go("/videojuego"),
              child: const Text("Jugar ahora →"),
            ),
            const SizedBox(height: 80),
            /// Shared application footer.
            AppFooter(),
          ],
        ),
      ),
    );
  }

  /// Creates a styled section title used throughout the screen.
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