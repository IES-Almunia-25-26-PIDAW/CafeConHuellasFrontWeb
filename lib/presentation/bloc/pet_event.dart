import 'package:cafeconhuellas_front/models/adoptionForm.dart';
import 'package:cafeconhuellas_front/models/event.dart';
import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/models/userPetRelationship.dart';

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

//AÑÑADIR UNA RELACIÓN 
class AddPetUserRelation extends PetsEvent {
 final Userpetrelationship relation;
  AddPetUserRelation(this.relation);
}

//CARGAR RELACIONES
class LoadPetUserRelations extends PetsEvent {
}
//AÑADIR UNA ADOPCIÓN
class SubmitAdoptionRequest extends PetsEvent {
  final Map<String, dynamic> request;
  final String token;
  SubmitAdoptionRequest(this.request, this.token);  
  }

//CARGAR UNA ADOPCION
class LoadAdoptionRequests extends PetsEvent {}
//cargar mis adopciones
class LoadMyAdoptionRequests extends PetsEvent {
  LoadMyAdoptionRequests();
}
//cargar mis relaciones
class LoadMyPetUserRelations extends PetsEvent {
  final int userId;
  LoadMyPetUserRelations(this.userId);
}