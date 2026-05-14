import 'package:bloc/bloc.dart';
import 'package:cafeconhuellas_front/models/adoptionForm.dart';
import 'package:cafeconhuellas_front/models/event.dart';
import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/models/userPetRelationship.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_event.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_state.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';

/// Bloc responsible for handling all pet-related logic
/// within the application.
///
/// This bloc manages:
/// - Loading pets and events from the backend.
/// - Filtering pets by species and emergency status.
/// - Adding, updating, and deleting pets (admin only).
/// - Adding, updating, and deleting events (admin only).
/// - Managing user-pet relationships (e.g., favorites, adoptions).
/// - Submitting and loading adoption requests.
/// 
/// Pets are separated into their own bloc to keep the
/// application architecture cleaner and more modular, since
/// pets are a core feature of the app.
class PetsBloc extends Bloc<PetsEvent, PetsState> {
  /// Internal lists to store the complete set of pets, events, and user-pet relationships.
  /// These lists are used to apply filters without needing to refetch data from the backend.
  final List<Userpetrelationship> _userPetRelations = <Userpetrelationship>[];
  final List<Pet> _allPets = <Pet>[];
  final List<Event> _allEvents = <Event>[];
  ///API connector used to perform HTTP requests to the backend.
  final ApiConector api;

  /// Bloc constructor.
  ///
  /// Initializes the default state and registers the events
  /// that this bloc will handle.
  PetsBloc({required this.api})
    : super(
        PetsState(
          pets: const <Pet>[],
          selectedSpecies: '',
          isEmergencyActive: false,
          isLoading: false,
          events: const <Event>[], 
          relations: const <Userpetrelationship>[], 
          adoptionRequests: const <AdoptionRequest>[],
        ),
      ) {
    /// Event responsible for loading pets from the backend API.
    on<LoadPets>(_onLoadPets);
    /// Event responsible for loading events from the backend API.
    on<LoadEvents>(_onLoadEvents);
    /// Event responsible for filtering pets by species.
    on<FilterSpecies>(_onFilterSpecies);
    /// Event responsible for adding a new pet to the backend API (admin only).
    on<AddPet>(_onAddPet);
    /// Event responsible for updating an existing pet in the backend API (admin only).
    on<UpdatePet>(_onUpdatePet);
    /// Event responsible for deleting a pet from the backend API (admin only).
    on<DeletePet>(_onDeletePet);
    ///Event responsible for filtering pets by emergency status.
    on<ToggleEmergency>(_onToggleEmergency);
    ///Event responsible for adding a new event to the backend API (admin only).
    on<AddEvent>(_onAddEvent);
    ///Event responsible for updating an existing event in the backend API (admin only).
    on<UpdateEvent>(_onUpdateEvent);
    ///Event responsible for deleting an event from the backend API (admin only).
    on<DeleteEvent>(_onDeleteEvent);
    ///Event responsible for adding a new user-pet relationship to the backend API.
    on<AddPetUserRelation>(_onAddPetUserRelation);
    ///Event responsible for loading user-pet relationships from the backend API.
    on<LoadPetUserRelations>(_onLoadPetUserRelations);
    ///Event responsible for submitting an adoption request to the backend API.
    on<SubmitAdoptionRequest>(_onSubmitAdoptionRequest);
    ///Event responsible for loading all adoption requests from the backend API.
    on<LoadAdoptionRequests>(_onLoadAdoptionRequests);
    ///Event responsible for loading the authenticated user's adoption requests from the backend API.
    on<LoadMyAdoptionRequests>(_onLoadMyAdoptionRequests);
    ///Event responsible for loading the authenticated user's pet relationships from the backend API.
    on<LoadMyPetUserRelations>(_onLoadMyPetUserRelations);
    ///Event responsible for adding a new user-pet relationship for the authenticated user to the backend API.
    on<AddMyPetUserRelation>(_onAddMyPetUserRelation);
  
  }
  ///Handle for loading the authenticated user's pet relationships from the backend API.
  Future<void> _onLoadMyPetUserRelations(LoadMyPetUserRelations event, Emitter<PetsState> emit) async {
    emit(state.copyWith(isLoading: true));
  try {
    final relations = await api.getMyRelationships(event.userId); // Debes tener este endpoint en tu API
    emit(state.copyWith(relations: relations, isLoading: false));
  } catch (e) {
    emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
  }

  }
  //Handle for loading the authenticated user's adoption requests from the backend API.
  Future<void> _onLoadMyAdoptionRequests(LoadMyAdoptionRequests event, Emitter<PetsState> emit) async {
    emit(state.copyWith(isLoading: true));
  try {
    final myRequests = await api.getMeAdoptionRequest(); // Endpoint /me
    emit(state.copyWith(adoptionRequests: myRequests, isLoading: false));
  } catch (e) {
    emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
  }
  }
  /// Handles loading all adoption requests from the backend API.
  ///
  /// This method:
  /// 1. Activates the loading state.
  /// 2. Requests all adoption forms from the backend.
  /// 3. Updates the bloc state with the retrieved requests.
  ///
  /// If an error occurs:
  /// - The loading state is disabled.
  /// - The error message is stored in the state
  Future<void> _onLoadAdoptionRequests(LoadAdoptionRequests event, Emitter<PetsState> emit) async {
  emit(state.copyWith(isLoading: true));
  try {
    ///Retrieves all adoption requests from the backend API.
    final requests = await api.getAdoptionRequest(); 
    ///Updates the state with retrieved requests
    emit(state.copyWith(adoptionRequests: requests, isLoading: false));
  } catch (e) {
    ///Updates the state with the corresponding error message.
    emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
  }
}
/// Handles submitting a new adoption request to the backend API.
///
/// This method:
/// 1. Activates the loading state.
/// 2. Sends the adoption form to the backend.
/// 3. Disables the loading state once completed.
///
/// If an error occurs:
/// - The loading state is disabled.
/// - The error message is stored in the state.
Future<void> _onSubmitAdoptionRequest(SubmitAdoptionRequest event, Emitter<PetsState> emit) async {
  emit(state.copyWith(isLoading: true));
  try {
    /// Send the adoption form using the authenticated token.
    await api.submitAdoptionForm(event.request, event.token);
    ///disables loading state after successfull submission
    emit(state.copyWith(isLoading: false));
  } catch (e) {
    ///Update the state with the corresponding error message if submission fails.
    emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
  }
}
  /// Handles loading all user-pet relationships from the backend API.
  ///
  /// This method:
  /// 1. Activates the loading state.
  /// 2. Retrieves all relationships from the backend.
  /// 3. Stores them locally.
  /// 4. Updates the bloc state.
  ///
  /// If an error occurs:
  /// - Cached relationships are cleared.
  /// - The error message is stored in the state.
  Future<void> _onLoadPetUserRelations(LoadPetUserRelations event, Emitter<PetsState> emit) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));

    try {
      ///Retrieves all user-pet relationships from the backend API.
      final List<Userpetrelationship> relations = await api.getUserPetRelationShip();
      ///Updates local cache
      _userPetRelations
        ..clear()
        ..addAll(relations);
      ///Updates state with retrieved relationships
      emit(state.copyWith(relations: relations, isLoading: false, clearErrorMessage: true));
    } catch (_) {
      ///Clears local cache if an error occurs
      _userPetRelations.clear();
      emit(
        state.copyWith(
          events: const <Event>[],
          isLoading: false,
          errorMessage: 'No se pudieron cargar los eventos desde la API.',
        ),
      );
    }
  }

  /// Handles adding a new user-pet relationship.
  ///
  /// This method:
  /// 1. Activates the loading state.
  /// 2. Sends the relationship to the backend API.
  /// 3. Disables loading state after completion.
  ///
  /// If an error occurs:
  /// - The error message is stored in the state.
  Future<void> _onAddPetUserRelation(AddPetUserRelation event, Emitter<PetsState> emit) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    try {
      /// Sends the relationship to the backend API.
      await api.addUserPetRelationship(event.relation);
      emit(state.copyWith(isLoading: false, clearErrorMessage: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
   }
    /// Handles adding a new relationship for the authenticated user.
    ///
    /// This method:
    /// 1. Activates the loading state.
    /// 2. Sends the relationship to the backend API.
    /// 3. Disables loading state after completion.
    ///
    /// If an error occurs:
    /// - The error message is stored in the state.
    Future<void> _onAddMyPetUserRelation(AddMyPetUserRelation event, Emitter<PetsState> emit) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    try {
       /// Sends the authenticated user's relationship to the backend.
      await api.postMyRelationships(event.relation);
      emit(state.copyWith(isLoading: false, clearErrorMessage: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
   }

  /// Handles adding a new pet to the backend API.
  ///
  /// Admin only.
  ///
  /// This method:
  /// 1. Activates the loading state.
  /// 2. Sends the new pet to the backend.
  /// 3. Reloads the pets list.
  /// 4. Applies active filters.
  ///
  /// If an error occurs:
  /// - The error message is stored in the state.
  Future<void> _onAddPet(AddPet event, Emitter<PetsState> emit) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    try {
       /// Sends the new pet to the backend.
      await api.addPet(event.pet);
      /// Reloads pets from the API to retrieve updated data.
      final List<Pet> pets = await api.getPets();
      /// Updates local cache with the new list of pets.
      _allPets
        ..clear()
        ..addAll(pets);
      ///Applies active filters and updates state
      emit(_applyFilters(state.copyWith(isLoading: false, clearErrorMessage: true)));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

   /// Handles loading all adoption requests from the backend API.
  ///
  /// This method:
  /// 1. Activates the loading state.
  /// 2. Requests all events from the backend.
  /// 3. Updates the bloc state with the retrieved events.
  ///
  /// If an error occurs:
  /// - The loading state is disabled.
  /// - The error message is stored in the state
  Future <void> _onLoadEvents(LoadEvents event, Emitter<PetsState> emit) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));

    try {
      final List<Event> events = await api.getEvents();
      _allEvents
        ..clear()
        ..addAll(events);
      emit(state.copyWith(events: events, isLoading: false, clearErrorMessage: true));
    } catch (_) {
      _allEvents.clear();
      emit(
        state.copyWith(
          events: const <Event>[],
          isLoading: false,
          errorMessage: 'No se pudieron cargar los eventos desde la API.',
        ),
      );
    }
  }
   /// Handles loading all pets from the backend API.
   ///  
   /// This method:
   /// 1. Activates the loading state.
   /// 2. Requests all pets from the backend.
   /// 3. Updates the bloc state with the retrieved pets.
   ///
   /// If an error occurs:
   /// - The loading state is disabled.
   /// - The error message is stored in the state
   /// - Cached pets are cleared to avoid displaying stale data.
  Future<void> _onLoadPets(LoadPets event, Emitter<PetsState> emit) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));

    try {
      final List<Pet> pets = await api.getPets();
      _allPets
        ..clear()
        ..addAll(pets);
      emit(
        _applyFilters(
          state.copyWith(isLoading: false, clearErrorMessage: true),
        ),
      );
    } catch (_) {
      _allPets.clear();
      emit(
        state.copyWith(
          pets: const <Pet>[],
          isLoading: false,
          errorMessage: 'No se pudieron cargar las mascotas desde la API.',
        ),
      );
    }
  }
  /// Handles adding a new pet to the backend API.
  ///
  /// Admin only.
  ///
  /// This method:
  /// 1. Activates the loading state.
  /// 2. Sends the updated pet to the backend.
  /// 3. Reloads the pets list.
  /// 4. Applies active filters.
  ///
  /// If an error occurs:
  /// - The error message is stored in the state.
  Future<void> _onUpdatePet(UpdatePet event, Emitter<PetsState> emit) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    try {
      await api.updatePet(event.pet);
      // sustituimos la mascota editada en la lista local sin hacer un GET extra
      final int idx = _allPets.indexWhere((p) => p.id == event.pet.id);
      if (idx != -1) _allPets[idx] = event.pet;
      emit(_applyFilters(state.copyWith(isLoading: false, clearErrorMessage: true)));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
 
   /// Handles adding a new pet to the backend API.
  ///
  /// Admin only.
  ///
  /// This method:
  /// 1. Activates the loading state.
  /// 2. Deletes the pet from the backend.
  /// 3. Reloads the pets list.
  /// 4. Applies active filters.
  ///
  /// If an error occurs:
  /// - The error message is stored in the state.
  Future<void> _onDeletePet(DeletePet event, Emitter<PetsState> emit) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    try {
      await api.deletePet(event.petId);
      _allPets.removeWhere((p) => p.id == event.petId);
      emit(_applyFilters(state.copyWith(isLoading: false, clearErrorMessage: true)));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
  /// Handles adding a new event to the backend API.
  ///
  /// Admin only.
  ///
  /// This method:
  /// 1. Activates the loading state.
  /// 2. Sends the new event to the backend.
  /// 3. Reloads the events list.
  /// 4. Applies active filters.
  ///
  /// If an error occurs:
  /// - The error message is stored in the state.
  Future<void> _onAddEvent(AddEvent event, Emitter<PetsState> emit) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    try {
      await api.addEvent(event.event);
      final List<Event> events = await api.getEvents();
      _allEvents..clear()..addAll(events);
      emit(state.copyWith(events: events, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  /// Handles updating an existing event in the backend API.
  ///
  /// Admin only.
  ///
  /// This method:
  /// 1. Activates the loading state.
  /// 2. Sends the updated event to the backend.
  /// 3. Reloads the events list.
  /// 4. Applies active filters.
  ///
  /// If an error occurs:
  /// - The error message is stored in the state.
  Future<void> _onUpdateEvent(UpdateEvent event, Emitter<PetsState> emit) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    try {
      await api.updateEvent(event.event);
      final int idx = _allEvents.indexWhere((e) => e.id == event.event.id);
      if (idx != -1) _allEvents[idx] = event.event;
      emit(state.copyWith(events: List<Event>.from(_allEvents), isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  /// Handles deleting an existing event from the backend API.
  ///
  /// Admin only.
  ///
  /// This method:
  /// 1. Activates the loading state.
  /// 2. Deletes the event from the backend.
  /// 3. Reloads the events list.
  /// 4. Applies active filters.
  ///
  /// If an error occurs:
  /// - The error message is stored in the state.
  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<PetsState> emit) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    try {
      await api.deleteEvent(event.eventId);
      _allEvents.removeWhere((e) => e.id == event.eventId);
      emit(state.copyWith(events: List<Event>.from(_allEvents), isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
  /// Handles filtering pets by species.
  /// This method:
  /// 1. Updates the selected species in the state.
  /// 2. Applies the filters to the complete pets list.
  /// If an error occurs:
  /// - The error message is stored in the state.
 
  void _onFilterSpecies(FilterSpecies event, Emitter<PetsState> emit) {
    final newState = state.copyWith(selectedSpecies: event.species);
    emit(_applyFilters(newState));
  }

  ///Handles filtering pets by emergency status.
  ///This method:
  ///1. Toggles the emergency filter in the state.
  ///2. Applies the filters to the complete pets list.
  ///If an error occurs:
  ///- The error message is stored in the state.
  void _onToggleEmergency(ToggleEmergency event, Emitter<PetsState> emit) {
    final newState = state.copyWith(
      isEmergencyActive: !state.isEmergencyActive,
    );
    emit(_applyFilters(newState));
  }

/// Handle for applying active filters to the complete pets list.
/// This method:
/// 1. Iterates through the complete list of pets.
/// 2. Checks if each pet matches the selected species filter (if any).
/// 3. Checks if each pet matches the emergency filter (if active).
/// 4. Returns a new state with the filtered list of pets.
/// If an error occurs:
/// - The error message is stored in the state.
  PetsState _applyFilters(PetsState state) {
    final filtered = _allPets.where((pet) {
      final matchesSpecies =
          state.selectedSpecies.isEmpty ||
          pet.category.toLowerCase() == state.selectedSpecies.toLowerCase();

      final matchesEmergency = !state.isEmergencyActive || pet.urgentAdoption;

      return matchesSpecies && matchesEmergency;
    }).toList();

    return state.copyWith(pets: filtered);
  }
}
