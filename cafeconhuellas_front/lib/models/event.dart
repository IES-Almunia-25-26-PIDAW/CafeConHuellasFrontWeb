class Event {
  final int id;
  final String name;
  final String imageUrl;
  final String description;
  final DateTime date;

  Event({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.date,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  Event copyWith({
    int? id,
    String? name,
    String? imageUrl,
    String? description,
    DateTime? date,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }
}