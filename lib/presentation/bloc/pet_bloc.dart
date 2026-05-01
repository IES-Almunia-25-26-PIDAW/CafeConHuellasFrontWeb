import 'package:bloc/bloc.dart';
import 'package:cafeconhuellas_front/models/adoptionForm.dart';
import 'package:cafeconhuellas_front/models/event.dart';
import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/models/userPetRelationship.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_event.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_state.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';

class PetsBloc extends Bloc<PetsEvent, PetsState> {
  final List<Userpetrelationship> _userPetRelations = <Userpetrelationship>[];
  final List<Pet> _allPets = <Pet>[];
  final List<Event> _allEvents = <Event>[];
  final ApiConector api;

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
    on<LoadPets>(_onLoadPets);
    on<LoadEvents>(_onLoadEvents);
    on<FilterSpecies>(_onFilterSpecies);
    on<AddPet>(_onAddPet);
    on<UpdatePet>(_onUpdatePet);
    on<DeletePet>(_onDeletePet);
    on<ToggleEmergency>(_onToggleEmergency);
    on<AddEvent>(_onAddEvent);
    on<UpdateEvent>(_onUpdateEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<AddPetUserRelation>(_onAddPetUserRelation);
    on<LoadPetUserRelations>(_onLoadPetUserRelations);
    on<SubmitAdoptionRequest>(_onSubmitAdoptionRequest);
    on<LoadAdoptionRequests>(_onLoadAdoptionRequests);
    on<LoadMyAdoptionRequests>(_onLoadMyAdoptionRequests);
    on<LoadMyPetUserRelations>(_onLoadMyPetUserRelations);
  }
  //cargar mis relaciones
  Future<void> _onLoadMyPetUserRelations(LoadMyPetUserRelations event, Emitter<PetsState> emit) async {
    emit(state.copyWith(isLoading: true));
  try {
    final relations = await api.getMyRelationships(event.userId); // Debes tener este endpoint en tu API
    emit(state.copyWith(relations: relations, isLoading: false));
  } catch (e) {
    emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
  }

  }
  //cargar mis adopciones
  Future<void> _onLoadMyAdoptionRequests(LoadMyAdoptionRequests event, Emitter<PetsState> emit) async {
    emit(state.copyWith(isLoading: true));
  try {
    final myRequests = await api.getMeAdoptionRequest(); // Endpoint /me
    emit(state.copyWith(adoptionRequests: myRequests, isLoading: false));
  } catch (e) {
    emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
  }
  }
  //cargar adopciones
  Future<void> _onLoadAdoptionRequests(LoadAdoptionRequests event, Emitter<PetsState> emit) async {
  emit(state.copyWith(isLoading: true));
  try {
    // Necesitas crear este método en tu ApiConector (visto en mensajes anteriores)
    final requests = await api.getAdoptionRequest(); 
    emit(state.copyWith(adoptionRequests: requests, isLoading: false));
  } catch (e) {
    emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
  }
}
//añadir adopciones
Future<void> _onSubmitAdoptionRequest(SubmitAdoptionRequest event, Emitter<PetsState> emit) async {
  emit(state.copyWith(isLoading: true));
  try {
    // Llamada al endpoint de submit con el token
    await api.submitAdoptionForm(event.request, event.token);
    emit(state.copyWith(isLoading: false));
    // Aquí podrías lanzar un mensaje de éxito
  } catch (e) {
    emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
  }
}
  //Cargar relaciones
  Future<void> _onLoadPetUserRelations(LoadPetUserRelations event, Emitter<PetsState> emit) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));

    try {
      final List<Userpetrelationship> relations = await api.getUserPetRelationShip();
      _userPetRelations
        ..clear()
        ..addAll(relations);
      emit(state.copyWith(relations: relations, isLoading: false, clearErrorMessage: true));
    } catch (_) {
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

  //añadir relaciones 
  Future<void> _onAddPetUserRelation(AddPetUserRelation event, Emitter<PetsState> emit) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    try {
      await api.addUserPetRelationship(event.relation);
      emit(state.copyWith(isLoading: false, clearErrorMessage: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
   }

  //AÑADIR MASCOTA SOLO ADMIN
   Future<void> _onAddPet(AddPet event, Emitter<PetsState> emit) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    try {
      await api.addPet(event.pet);
      // recargamos la lista completa para reflejar el nuevo id que asigna el backend
      final List<Pet> pets = await api.getPets();
      _allPets
        ..clear()
        ..addAll(pets);
      emit(_applyFilters(state.copyWith(isLoading: false, clearErrorMessage: true)));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  //cargamos los eventos para mostrarlos en la pantalla de eventos, aunque no se usen en la pantalla de mascotas
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
  //cargamos las mascotas para mostrarlas en la pantalla de mascotas, aunque no se usen en la pantalla de eventos
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
  // SOLO ADMIN: editar una mascota existente y actualizar la lista local
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
 
  // SOLO ADMIN: borrar una mascota y quitarla de la lista local
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

  // SOLO ADMIN: añadir evento
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

  // SOLO ADMIN: editar evento
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

  // SOLO ADMIN: borrar evento
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

  void _onFilterSpecies(FilterSpecies event, Emitter<PetsState> emit) {
    final newState = state.copyWith(selectedSpecies: event.species);
    emit(_applyFilters(newState));
  }

  void _onToggleEmergency(ToggleEmergency event, Emitter<PetsState> emit) {
    final newState = state.copyWith(
      isEmergencyActive: !state.isEmergencyActive,
    );
    emit(_applyFilters(newState));
  }


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
