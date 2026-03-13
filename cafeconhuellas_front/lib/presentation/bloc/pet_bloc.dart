import 'package:bloc/bloc.dart';
import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_event.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_state.dart';
import 'package:cafeconhuellas_front/utils/globals.dart';

class PetsBloc extends Bloc<PetsEvent, PetsState>{
  final List<Pet> _allPets = List.from(Globals.pets);
  PetsBloc() : super(PetsState(pets: List.from(Globals.pets), selectedSpecies: '', isEmergencyActive: false)) {
    on<LoadPets>(_onLoadPets);
    on<FilterSpecies>(_onFilterSpecies);
    on<ToggleEmergency>(_onToggleEmergency);
  }


  void _onLoadPets(LoadPets event, Emitter<PetsState> emit) {
    emit(_applyFilters(state.copyWith(pets: _allPets)));
  }
  void _onFilterSpecies(FilterSpecies event, Emitter<PetsState> emit) {
    final newState = state.copyWith(selectedSpecies: event.species);
    emit(_applyFilters(newState));
  }


  void _onToggleEmergency(ToggleEmergency event, Emitter<PetsState> emit) {
    final newState =
          state.copyWith(isEmergencyActive: !state.isEmergencyActive);
      emit(_applyFilters(newState));
  }
 
PetsState _applyFilters(PetsState state) {
    final filtered = _allPets.where((pet) {
      final matchesSpecies =
          state.selectedSpecies.isEmpty ||
          (state.selectedSpecies == 'Perro' && pet.species == Species.perro) ||
          (state.selectedSpecies == 'Gato' && pet.species == Species.gato);


      final matchesEmergency =
          !state.isEmergencyActive || pet.emergency;


      return matchesSpecies && matchesEmergency;
    }).toList();


    return state.copyWith(pets: filtered);
  }
  }
