class Event {
  final int id;
  final String name;
  final String description;
  final DateTime eventdate;
  final String location;
  final String imageUrl;
  final String eventType;
  final String status;
  final int maxCapacity;
  final DateTime createdAt;

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
  }) : eventdate = eventdate ?? date ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now();

  factory Event.fromJson(Map<String, dynamic> json) {
    final dynamic rawDate = json['eventdate'] ?? json['eventDate'] ?? json['date'];
    final dynamic rawCreatedAt = json['createdAt'] ?? json['created_at'];

    return Event(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? '').toString(),
      imageUrl: (json['imageUrl'] ?? json['image_url'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      eventdate: _parseDate(rawDate),
      location: (json['location'] ?? '').toString(),
      eventType: (json['eventType'] ?? json['event_type'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      maxCapacity: (json['maxCapacity'] as num?)?.toInt() ?? 0,
      createdAt: _parseDate(rawCreatedAt),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':          id,
      'name':        name,
      'imageUrl':    imageUrl,
      'description': description,
      'eventDate':   eventdate.toIso8601String(),  
      'location':    location,
      'eventType':   eventType,
      'status':      status,
      'maxCapacity': maxCapacity,
      'createdAt':   createdAt.toIso8601String(),
    };
  }

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