import 'package:cafeconhuellas_front/models/adoptionForm.dart';
import 'package:cafeconhuellas_front/models/event.dart';
import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/models/userPetRelationship.dart';

/// Represents the complete pets-related state
/// of the application.
///
/// This state stores:
/// - Pets list.
/// - Events list.
/// - User-pet relationships.
/// - Adoption requests.
/// - Active filters.
/// - Loading state.
/// - Error messages.
///
/// The state is managed by the PetsBloc.
class PetsState {
  /// List of pets currently visible in the UI.
  final List<Pet> pets;
  /// List of events loaded from the backend.
  final List<Event> events;
  /// Currently selected species/category filter.
  final String selectedSpecies;
  /// Indicates whether emergency adoption filtering
  /// is enabled.
  final bool isEmergencyActive;
  /// List of user-pet relationships.
  final List<Userpetrelationship> relations;
  /// List of adoption requests.
  final List<AdoptionRequest> adoptionRequests;
  /// Indicates whether a pets-related operation
  /// is currently in progress.
  final bool isLoading;
  /// Stores pets-related error messages.
  ///
  /// Null if no error exists.
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

  /// Creates a copy of the current state
  /// replacing only the provided values.
  ///
  /// Used to preserve immutability while updating state.
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
      selectedSpecies:
          selectedSpecies ?? this.selectedSpecies,
      isEmergencyActive:
          isEmergencyActive ?? this.isEmergencyActive,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearErrorMessage
              ? null
              : (errorMessage ?? this.errorMessage),
      events: events ?? this.events,
      relations: relations ?? this.relations,
      adoptionRequests:
          adoptionRequests ?? this.adoptionRequests,
    );
  }
}