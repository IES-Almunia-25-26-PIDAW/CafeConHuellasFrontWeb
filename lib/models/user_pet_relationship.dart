/// Represents the relationship between a user and a pet.
///
/// This model is used to manage different types
/// of interactions or commitments between users
/// and pets within the system.
///
/// Example relationship types:
/// - Sponsorship
/// - Walking
/// - Volunteering
/// - Foster Home
class Userpetrelationship {

  /// Unique identifier of the relationship.
  int id;

  /// Identifier of the associated user.
  int userId;

  /// Identifier of the associated pet.
  int petId;

  /// Type of relationship between the user and the pet.
  ///
  /// Example values:
  /// - APADRINAMIENTO
  /// - PASEO
  /// - VOLUNTARIADO
  /// - CASA DE ACOGIDA
  final String relationshipType;

  /// Date when the relationship started.
  DateTime startDate;

  /// Date when the relationship ended.
  ///
  /// This value may be `null` if the relationship
  /// is still active.
  DateTime? endDate;

  /// Indicates whether the relationship is currently active.
  bool active;

  /// Creates a new [Userpetrelationship] instance.
  Userpetrelationship({
    required this.id,
    required this.userId,
    required this.petId,
    required this.relationshipType,
    required this.startDate,
    this.endDate,
    required this.active,
  });

  /// Creates a [Userpetrelationship] instance from JSON data.
  ///
  /// Used when parsing backend API responses.
  factory Userpetrelationship.fromJson(
    Map<String, dynamic> json,
  ) {
    return Userpetrelationship(
      id: json['id'] as int,
      userId: json['userId'] as int,
      petId: json['petId'] as int,
      relationshipType:
          json['relationshipType'] as String,
      startDate:
          DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      active: json['active'] as bool,
    );
  }

  /// Converts this object into JSON format.
  ///
  /// Dates are serialized using `yyyy-MM-dd` format
  /// before being sent to the backend API.
  ///
  /// The [id] field is only included if its value
  /// is different from `0`.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'userId': userId,
      'petId': petId,
      'relationshipType': relationshipType,
      'startDate':
          startDate.toIso8601String().split('T')[0],
      'endDate':
          endDate?.toIso8601String().split('T')[0],
      'active': active,
    };

    if (id != 0) {
      map['id'] = id;
    }

    return map;
  }
}