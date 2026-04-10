import 'package:bloc/bloc.dart';
import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_event.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_state.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';

class PetsBloc extends Bloc<PetsEvent, PetsState> {
  final List<Pet> _allPets = <Pet>[];

  PetsBloc()
    : super(
        PetsState(
          pets: const <Pet>[],
          selectedSpecies: '',
          isEmergencyActive: false,
          isLoading: false,
        ),
      ) {
    on<LoadPets>(_onLoadPets);
    on<FilterSpecies>(_onFilterSpecies);
    on<ToggleEmergency>(_onToggleEmergency);
  }

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
