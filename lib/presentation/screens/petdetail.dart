import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Screen that displays the full detail of a single pet.
///
/// This screen contains:
/// - Pet image.
/// - Basic information (breed, age, weight, PPP status, neutered).
/// - Full description.
/// - Contact button.
///
/// The pet can be provided directly or loaded from the API
/// using [petId].
///
/// It also includes the application's shared
/// header and footer components.
class PetDetailScreen extends StatelessWidget {

  /// Unique identifier of the pet to display.
  final int petId;

  /// Optional pet object provided directly.
  ///
  /// If provided, the API call is skipped.
  final Pet? pet;

  /// Creates the pet detail screen widget.
  const PetDetailScreen({super.key, required this.petId, this.pet});

  /// Loads the pet data.
  ///
  /// Returns [pet] directly if already provided.
  /// Fetches from the API using [petId] otherwise.
  /// Returns null if [petId] is negative.
  Future<Pet?> _loadPet() async {
    if (pet != null) {
      return pet;
    }
    if (petId < 0) {
      return null;
    }
    return ApiConector().getPetById(petId);
  }

  /// Builds the pet detail screen UI.
  ///
  /// Uses [FutureBuilder] to load the pet asynchronously.
  ///
  /// Layout structure:
  /// - Application header.
  /// - Banner image.
  /// - Pet image and basic info (responsive: stacked on narrow screens, side by side on wide screens).
  /// - Full description card.
  /// - Contact button.
  /// - Application footer.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Pet?>(
      future: _loadPet(),
      builder: (context, snapshot) {
        /// Loading state.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final Pet? resolvedPet = snapshot.data;

        /// Pet not found state.
        if (resolvedPet == null) {
          return const Scaffold(
            body: Center(child: Text("Mascota no encontrada")),
          );
        }

        /// Pet image widget.
        ///
        /// Renders a network image if the URL starts with 'http',
        /// otherwise loads from local assets.
        final Widget petImage = Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: resolvedPet.imageUrl.startsWith('http')
                ? Image.network(
                    resolvedPet.imageUrl,
                    height: 280,
                    width: 280,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    resolvedPet.imageUrl,
                    height: 280,
                    width: 280,
                    fit: BoxFit.cover,
                  ),
          ),
        );

        /// Pet basic information widget.
        final Widget petInfo = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Pet name.
            Text(
              resolvedPet.name,
              style: const TextStyle(
                fontSize: 40,
                fontFamily: "WinkyMilky",
              ),
            ),
            const SizedBox(height: 20),
            /// Basic info card.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Raza: ${resolvedPet.breed}"),
                  Text("Edad: ${resolvedPet.age} años"),
                  Text("Peso: ${resolvedPet.weight} kg"),
                  Text("Ppp ${resolvedPet.isPpp ? 'Sí' : 'No'}"),
                  Text("Castrado: ${resolvedPet.neutered ? 'Sí' : 'No'}"),
                ],
              ),
            ),
          ],
        );

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                /// Shared application header.
                AppHeader(userImageUrl: "assets/user.png"),
                /// Main banner image.
                Image.asset(
                  'assets/images/banners/banner-inicio.png',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isNarrow = constraints.maxWidth < 860;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Responsive layout:
                              /// stacked on narrow screens, side by side on wide screens.
                              if (isNarrow)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(child: petImage),
                                    const SizedBox(height: 20),
                                    petInfo,
                                  ],
                                )
                              else
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    petImage,
                                    const SizedBox(width: 40),
                                    Expanded(child: petInfo),
                                  ],
                                ),
                              const SizedBox(height: 30),
                              /// Full description card.
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "Sobre ${resolvedPet.name}",
                                      style: const TextStyle(
                                        fontSize: 35,
                                        fontFamily: "MilkyVintage",
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      resolvedPet.description,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              /// Contact section with button linking to the contact screen.
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "¿Quieres ayudarle?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 35,
                                        fontFamily: "WinkyMilky",
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 28,
                                          vertical: 14,
                                        ),
                                      ),
                                      onPressed: () {
                                        context.go("/contactus");
                                      },
                                      child: const Text("Contacta con nosotros"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                /// Shared application footer.
                const AppFooter(),
              ],
            ),
          ),
        );
      },
    );
  }
}