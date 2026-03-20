import 'package:cafeconhuellas_front/models/pet.dart';

class PetsState {
  final List<Pet> pets;
  final String selectedSpecies;
  final bool isEmergencyActive;
  final bool isLoading;
  final String? errorMessage;


  PetsState({
    required this.pets,
    required this.selectedSpecies,
    required this.isEmergencyActive,
    this.isLoading = false,
    this.errorMessage,
  });


  PetsState copyWith({
    List<Pet>? pets,
    String? selectedSpecies,
    bool? isEmergencyActive,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return PetsState(
      pets: pets ?? this.pets,
      selectedSpecies: selectedSpecies ?? this.selectedSpecies,
      isEmergencyActive: isEmergencyActive ?? this.isEmergencyActive,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
