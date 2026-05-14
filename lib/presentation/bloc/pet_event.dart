import 'package:cafeconhuellas_front/models/event.dart';
import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/models/userPetRelationship.dart';

/// Base class for all pet-related events.
///
/// These events are consumed by the PetsBloc
/// to trigger state updates related to:
/// - Pets.
/// - Events.
/// - Adoption requests.
/// - User-pet relationships.
abstract class PetsEvent {}

/// Event triggered to load all pets
/// from the backend API.
class LoadPets extends PetsEvent {}

/// Event triggered to load all events
/// from the backend API.
class LoadEvents extends PetsEvent {}

/// Event triggered to filter pets
/// by species/category.
class FilterSpecies extends PetsEvent {

  /// Selected species/category filter.
  final String species;

  FilterSpecies(this.species);
}

/// Event triggered to enable or disable
/// emergency adoption filtering.
class ToggleEmergency extends PetsEvent {}

/// Event triggered to add a new pet.
///
/// Admin only.
class AddPet extends PetsEvent {

  /// Pet to be created.
  final Pet pet;

  AddPet(this.pet);
}

/// Event triggered to update an existing pet.
///
/// Admin only.
class UpdatePet extends PetsEvent {

  /// Updated pet information.
  final Pet pet;

  UpdatePet(this.pet);
}

/// Event triggered to delete a pet.
///
/// Admin only.
class DeletePet extends PetsEvent {

  /// ID of the pet to delete.
  final int petId;

  DeletePet(this.petId);
}

/// Event triggered to add a new event.
///
/// Admin only.
class AddEvent extends PetsEvent {

  /// Event to be created.
  final Event event;
  AddEvent(this.event);
}

/// Event triggered to update an existing event.
///
/// Admin only.
class UpdateEvent extends PetsEvent {

  /// Updated event information.
  final Event event;
  UpdateEvent(this.event);
}

/// Event triggered to delete an event.
///
/// Admin only.
class DeleteEvent extends PetsEvent {

  /// ID of the event to delete.
  final int eventId;
  DeleteEvent(this.eventId);
}

/// Event triggered to create a user-pet relationship.
///
/// Admin only.
class AddPetUserRelation extends PetsEvent {

  /// Relationship to be created.
  final Userpetrelationship relation;
  AddPetUserRelation(this.relation);
}

/// Event triggered to create a relationship
/// for the authenticated user.
class AddMyPetUserRelation extends PetsEvent {

  /// Relationship to be created.
  final Userpetrelationship relation;
  AddMyPetUserRelation(this.relation);
}

/// Event triggered to load all user-pet
/// relationships from the backend API.
class LoadPetUserRelations extends PetsEvent {}

/// Event triggered to submit a new
/// adoption request.
class SubmitAdoptionRequest extends PetsEvent {
  /// Adoption form data.
  final Map<String, dynamic> request;
  /// JWT authentication token.
  final String token;
  SubmitAdoptionRequest(this.request, this.token);
}
/// Event triggered to load all adoption requests.
class LoadAdoptionRequests extends PetsEvent {}
/// Event triggered to load adoption requests
/// belonging to the authenticated user.
class LoadMyAdoptionRequests extends PetsEvent {
  LoadMyAdoptionRequests();
}
/// Event triggered to load user-pet relationships
/// belonging to the authenticated user.
class LoadMyPetUserRelations extends PetsEvent {
  /// Authenticated user ID.
  final int userId;
  LoadMyPetUserRelations(this.userId);
}