import 'package:cafeconhuellas_front/models/event.dart';
import 'package:cafeconhuellas_front/models/pet.dart';

class PetsState {
  final List<Pet> pets;
  final List <Event> events;
  final String selectedSpecies;
  final bool isEmergencyActive;
  final bool isLoading;
  final String? errorMessage;


  PetsState({
    required this.pets,
    required this.events,
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
    List<Event>? events,
  }) {
    return PetsState(
      pets: pets ?? this.pets,
      selectedSpecies: selectedSpecies ?? this.selectedSpecies,
      isEmergencyActive: isEmergencyActive ?? this.isEmergencyActive,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      events: events ?? this.events,
    );
  }
}
