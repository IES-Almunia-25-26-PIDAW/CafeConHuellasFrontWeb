


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
    //tienes que poner el header, footer y banner


    return BlocProvider(
      create: (_) => PetsBloc()..add(LoadPets()),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column (children: [
            AppHeader(userImageUrl: "assets/user.png"),
            Image.asset('assets/images/banners/banner-inicio.png',width: double.infinity,height: 250,fit: BoxFit.cover,),
            const SizedBox(height: 20,),
            //controles
             /// CONTROLES
              BlocBuilder<PetsBloc, PetsState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// BOTON EMERGENCIA
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                       
                          backgroundColor: state.isEmergencyActive
                              ? const Color.fromARGB(255, 106, 91, 133)
                              : Colors.purple[200],
                        ),
                        onPressed: () {
                          context.read<PetsBloc>().add(ToggleEmergency());
                        },
                        child: const Text("Emergencia"),
                      ),
                      const SizedBox(width: 20),
                      const Text("Filtrar por especie:"),
                      const SizedBox(width: 10),
                      /// DROPDOWN
                      DropdownButton<String>(
                        value: state.selectedSpecies.isEmpty
                            ? null
                            : state.selectedSpecies,
                        hint: const Text("Todas"),
                        items: const [
                          DropdownMenuItem(
                            value: "Perro",
                            child: Text("Perro"),
                          ),
                          DropdownMenuItem(
                            value: "Gato",
                            child: Text("Gato"),
                          ),
                        ],
                        onChanged: (value) {
                          context
                              .read<PetsBloc>()
                              .add(FilterSpecies(value ?? ""));
                        },
                      ),
                   
                    ],
                  );
                },
              ),


              const SizedBox(height: 30),

              /// GRID DE MASCOTAS
              BlocBuilder<PetsBloc, PetsState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: state.pets
                          .map((pet) => PetCard(pet))
                          .toList(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              AppFooter()
          ],),
           
        )
      ),
    );
  }
}
