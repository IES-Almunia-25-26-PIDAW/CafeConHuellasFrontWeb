import 'package:bloc/bloc.dart';
import 'package:cafeconhuellas_front/models/event.dart';
import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_event.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_state.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';

class PetsBloc extends Bloc<PetsEvent, PetsState> {
  final List<Pet> _allPets = <Pet>[];
  final List<Event> _allEvents = <Event>[];

  PetsBloc()
    : super(
        PetsState(
          pets: const <Pet>[],
          selectedSpecies: '',
          isEmergencyActive: false,
          isLoading: false,
          events: const <Event>[],
        ),
      ) {
    on<LoadPets>(_onLoadPets);
    on<LoadEvents>(_onLoadEvents);
    on<FilterSpecies>(_onFilterSpecies);
    on<ToggleEmergency>(_onToggleEmergency);
  }
  //cargamos los eventos para mostrarlos en la pantalla de eventos, aunque no se usen en la pantalla de mascotas
  Future <void> _onLoadEvents(LoadEvents event, Emitter<PetsState> emit) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));

    try {
      final List<Event> events = await ApiConector().getEvents();
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
      final List<Pet> pets = await ApiConector().getPets();
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
          (state.selectedSpecies == 'Perro' && pet.species == Species.perro) ||
          (state.selectedSpecies == 'Gato' && pet.species == Species.gato);

      final matchesEmergency = !state.isEmergencyActive || pet.emergency;

      return matchesSpecies && matchesEmergency;
    }).toList();

    return state.copyWith(pets: filtered);
  }
}
