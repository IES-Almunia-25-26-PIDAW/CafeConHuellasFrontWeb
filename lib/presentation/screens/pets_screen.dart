


import 'package:cafeconhuellas_front/presentation/bloc/pet_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_event.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_state.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:cafeconhuellas_front/presentation/widgets/petcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PetScreen extends StatelessWidget {
  const PetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PetsBloc()..add(LoadPets()),
      child: Scaffold(
        body: Column(
          children: [
            AppHeader(userImageUrl: "assets/user.png"),
            
            // Usamos un CustomScrollView para que el header y el banner también hagan scroll
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Banner e Imagen
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/banners/banner-inicio.png',
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 20),
                        
                        /// CONTROLES
                        BlocBuilder<PetsBloc, PetsState>(
                          builder: (context, state) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: state.isEmergencyActive
                                        ? const Color.fromARGB(255, 106, 91, 133)
                                        : Colors.purple[200],
                                  ),
                                  onPressed: () => context.read<PetsBloc>().add(ToggleEmergency()),
                                  child: const Text("Emergencia", style: TextStyle(color: Colors.white)),
                                ),
                                const SizedBox(width: 20),
                                const Text("Especie:"),
                                const SizedBox(width: 10),
                                
                                /// DROPDOWN CORREGIDO
                                DropdownButton<String>(
                                  value: state.selectedSpecies.isEmpty ? "" : state.selectedSpecies,
                                  items: const [
                                    DropdownMenuItem(value: "", child: Text("Todas")), // Opción para resetear
                                    DropdownMenuItem(value: "Perro", child: Text("Perro")),
                                    DropdownMenuItem(value: "Gato", child: Text("Gato")),
                                  ],
                                  onChanged: (value) {
                                    context.read<PetsBloc>().add(FilterSpecies(value ?? ""));
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),

                  /// GRID DE MASCOTAS , ponemos silverpadding para q sea simetrico
                  BlocBuilder<PetsBloc, PetsState>(
                    builder: (context, state) {
                      final width = MediaQuery.of(context).size.width;
                      final crossAxisCount = width < 600 ? 2 : width < 1000 ? 3 : 4;
                      final horizontalPadding = width < 700 ? 16.0 : width < 1100 ? 40.0 : 80.0;
                      final childAspectRatio = width < 600 ? 0.66 : width < 1000 ? 0.74 : 0.82;
                      return SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
                        sliver: SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            childAspectRatio: childAspectRatio,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => PetCard(state.pets[index]),
                            childCount: state.pets.length,
                          ),
                        ),
                      );
                    },
                  ),

                  // Footer al final del scroll
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        AppFooter(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
