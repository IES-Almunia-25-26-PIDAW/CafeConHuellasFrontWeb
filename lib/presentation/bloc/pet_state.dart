import 'package:cafeconhuellas_front/models/adoptionForm.dart';
import 'package:cafeconhuellas_front/models/event.dart';
import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/models/userPetRelationship.dart';

class PetsState {
  final List<Pet> pets;
  final List <Event> events;
  final String selectedSpecies;
  final bool isEmergencyActive;
  final List<Userpetrelationship> relations; // <--- Añadir esto
  final List<AdoptionRequest> adoptionRequests; // <--- Añadir esto
  final bool isLoading;
  final String? errorMessage;


  PetsState({
    required this.pets,
    required this.events,
    required this.selectedSpecies,
    required this.isEmergencyActive,
    this.isLoading = false,
    this.errorMessage, 
    required this.relations, 
    required this.adoptionRequests,
  });


  PetsState copyWith({
    List<Pet>? pets,
    String? selectedSpecies,
    bool? isEmergencyActive,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    List<Event>? events,
    List<Userpetrelationship>? relations,
    List<AdoptionRequest>? adoptionRequests,
  }) {
    return PetsState(
      pets: pets ?? this.pets,
      selectedSpecies: selectedSpecies ?? this.selectedSpecies,
      isEmergencyActive: isEmergencyActive ?? this.isEmergencyActive,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      events: events ?? this.events, 
      relations: relations ?? this.relations,
      adoptionRequests: adoptionRequests ?? this.adoptionRequests,
    );
  }
}
