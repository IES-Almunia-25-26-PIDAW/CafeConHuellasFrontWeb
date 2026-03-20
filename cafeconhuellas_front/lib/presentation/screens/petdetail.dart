
import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';

class PetDetailScreen extends StatelessWidget{
  final int petId;
  final List<Pet> petsList;


  const PetDetailScreen({super.key, required this.petId, required this.petsList});


  @override
  Widget build (BuildContext context) {
    /*
    FutureBuilder<List<Pet>>(
      future: ApiConector().getPets(),
      builder: (context, snapshot) {
        ...
      },
    );
    */
    final Pet? pet = petsList.firstWhereOrNull((p) => p.id == petId);

    if (pet == null) {
      return Scaffold(
        body: const Center(child: Text("Mascota no encontrada")),
      );
    }

    final Widget petImage = Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: pet.imageUrl.startsWith('http')
            ? Image.network(
                pet.imageUrl,
                height: 280,
                width: 280,
                fit: BoxFit.cover,
              )
            : Image.asset(
                pet.imageUrl,
                height: 280,
                width: 280,
                fit: BoxFit.cover,
              ),
      ),
    );

    final Widget petInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pet.name,
          style: const TextStyle(
            fontSize: 40,
            fontFamily: "WinkyMilky",
          ),
        ),
        const SizedBox(height: 20),
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
              Text("Raza: ${pet.breed}"),
              Text("Edad: ${pet.age} años"),
              Text("Ubicación: ${pet.location}"),
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppHeader(userImageUrl: "assets/user.png"),
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
                                  "Sobre ${pet.name}",
                                  style: const TextStyle(
                                    fontSize: 35,
                                    fontFamily: "MilkyVintage",
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  pet.description,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
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
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}
