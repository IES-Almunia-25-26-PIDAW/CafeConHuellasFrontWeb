import 'package:cafeconhuellas_front/models/pet.dart';

class PetsState {
  final List<Pet> pets;
  final String selectedSpecies;
  final bool isEmergencyActive;


  PetsState({
    required this.pets,
    required this.selectedSpecies,
    required this.isEmergencyActive,
  });


  PetsState copyWith({
    List<Pet>? pets,
    String? selectedSpecies,
    bool? isEmergencyActive,
  }) {
    return PetsState(
      pets: pets ?? this.pets,
      selectedSpecies: selectedSpecies ?? this.selectedSpecies,
      isEmergencyActive: isEmergencyActive ?? this.isEmergencyActive,
    );
  }
}
