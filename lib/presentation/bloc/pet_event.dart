import 'package:cafeconhuellas_front/models/event.dart';
import 'package:cafeconhuellas_front/models/pet.dart';

abstract class PetsEvent {}

class LoadPets extends PetsEvent {}

class LoadEvents extends PetsEvent {}

class FilterSpecies extends PetsEvent {
  final String species;
  FilterSpecies(this.species);
}

class ToggleEmergency extends PetsEvent {}

// SOLO ADMIN: añadir mascota
class AddPet extends PetsEvent {
  final Pet pet;
  AddPet(this.pet);
}

//SOLO ADMIN: editar mascota
class UpdatePet extends PetsEvent {
  final Pet pet;
  UpdatePet(this.pet);
}

// SOLO ADMIN: borrar mascota
class DeletePet extends PetsEvent {
  final int petId;
  DeletePet(this.petId);
}

// SOLO ADMIN: añadir evento
class AddEvent extends PetsEvent {
  final Event event;
  AddEvent(this.event);
}

// SOLO ADMIN: editar evento
class UpdateEvent extends PetsEvent {
  final Event event;
  UpdateEvent(this.event);
}

// SOLO ADMIN: borrar evento
class DeleteEvent extends PetsEvent {
  final int eventId;
  DeleteEvent(this.eventId);
}