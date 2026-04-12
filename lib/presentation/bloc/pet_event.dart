abstract class PetsEvent {}
class LoadPets extends PetsEvent {}
class LoadEvents extends PetsEvent {}
class FilterSpecies extends PetsEvent {
  final String species;

  FilterSpecies(this.species);
}
class ToggleEmergency extends PetsEvent {}
