/// Represents an event organized by the application.
///
/// Events may include adoption campaigns,
/// fundraising activities, educational events,
/// or community gatherings.
class Event {

  /// Unique identifier of the event.
  final int id;

  /// Event title or name.
  final String name;

  /// Detailed description of the event.
  final String description;

  /// Date and time when the event takes place.
  final DateTime eventdate;

  /// Event location.
  final String location;

  /// Main image URL associated with the event.
  final String imageUrl;

  /// Category or type of event.
  ///
  /// Example values:
  /// - Adoption Fair
  /// - Charity Event
  /// - Volunteer Activity
  final String eventType;

  /// Current event status.
  ///
  /// Example values:
  /// - active
  /// - cancelled
  /// - completed
  final String status;

  /// Maximum number of attendees allowed.
  final int maxCapacity;

  /// Date and time when the event was created.
  final DateTime createdAt;

  /// Creates a new [Event] instance.
  Event({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    DateTime? date,
    DateTime? eventdate,
    this.location = '',
    this.eventType = '',
    this.status = '',
    this.maxCapacity = 0,
    DateTime? createdAt,
  })  : eventdate = eventdate ?? date ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  /// Creates an [Event] instance from JSON data.
  ///
  /// Includes fallback handling for different
  /// backend field naming conventions.
  factory Event.fromJson(Map<String, dynamic> json) {
    final dynamic rawDate =
        json['eventdate'] ??
        json['eventDate'] ??
        json['date'];

    final dynamic rawCreatedAt =
        json['createdAt'] ??
        json['created_at'];

    return Event(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? '').toString(),
      imageUrl:
          (json['imageUrl'] ?? json['image_url'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      eventdate: _parseDate(rawDate),
      location: (json['location'] ?? '').toString(),
      eventType:
          (json['eventType'] ??
          json['event_type'] ??
          '').toString(),
      status: (json['status'] ?? '').toString(),
      maxCapacity:
          (json['maxCapacity'] as num?)?.toInt() ?? 0,
      createdAt: _parseDate(rawCreatedAt),
    );
  }

  /// Converts this object into JSON format.
  ///
  /// Used for API requests and data persistence.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'eventDate': eventdate.toIso8601String(),
      'location': location,
      'eventType': eventType,
      'status': status,
      'maxCapacity': maxCapacity,
      'createdAt': createdAt.toIso8601String(),
    };

    if (id != 0) {
      map['id'] = id;
    }

    return map;
  }

  /// Creates a copy of this event with updated values.
  ///
  /// Only the provided parameters are replaced.
  Event copyWith({
    int? id,
    String? name,
    String? imageUrl,
    String? description,
    DateTime? eventdate,
    DateTime? date,
    String? location,
    String? eventType,
    String? status,
    int? maxCapacity,
    DateTime? createdAt,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      eventdate: eventdate ?? date ?? this.eventdate,
      location: location ?? this.location,
      eventType: eventType ?? this.eventType,
      status: status ?? this.status,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Safely parses dynamic date values.
  ///
  /// Returns the current date if parsing fails.
  static DateTime _parseDate(dynamic value) {
    if (value is DateTime) {
      return value;
    }

    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }

    return DateTime.now();
  }
}