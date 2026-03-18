class Event {
  final int id;
  final String name;
  final String imageUrl;
  final String description;
  final DateTime date;
  final bool active;

  Event({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.date,
    required this.active,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'date': date.toIso8601String(),
      'active': active,
    };
  }

  Event copyWith({
    int? id,
    String? name,
    String? imageUrl,
    String? description,
    DateTime? date,
    bool? active,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      date: date ?? this.date,
      active: active ?? this.active,
    );
  }
}