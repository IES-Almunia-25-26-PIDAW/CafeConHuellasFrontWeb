enum Species { perro, gato }

class Pet {
  final int id;
  final String name;
  final Species species;
  final bool adopted;
  final String description;
  final String breed;
  final String category;
  final int age;
  final double weight;
  final bool neutered;
  final bool isPpp;
  final String imageUrl;
  final List<String> imageUrls;
  final bool emergency;

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.adopted,
    required this.imageUrl,
    required this.description,
    this.category = '',
    this.weight = 0.0,
    this.neutered = false,
    this.isPpp = false,
    List<String>? imageUrls,
    required this.emergency,
  }) : imageUrls = imageUrls ?? const [];

  factory Pet.fromJson(Map<String, dynamic> json) {
    final String normalizedSpecies = (json['species'] ?? json['category'] ?? '').toString();
    final String mainImage = (json['imageUrl'] ?? json['image_url'] ?? '').toString();

    return Pet(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? '').toString(),
      species: _speciesFromString(normalizedSpecies),
      breed: (json['breed'] ?? '').toString(),
      age: (json['age'] as num?)?.toInt() ?? 0,
      adopted: _parseBool(json['adopted'] ?? json['isAdopted'] ?? false),
      imageUrl: mainImage,
      description: (json['description'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      neutered: _parseBool(json['neutered'] ?? false),
      isPpp: _parseBool(json['isPpp'] ?? json['is_ppp'] ?? false),
      imageUrls: _parseImageUrls(json['imageUrls'] ?? json['image_urls'], mainImage),
      emergency: _parseBool(json['emergency'] ?? json['isEmergency'] ?? false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'species': _speciesToString(species),
      'breed': breed,
      'category': category,
      'age': age,
      'weight': weight,
      'adopted': adopted,
      'neutered': neutered,
      'isPpp': isPpp,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
      'description': description,
      'emergency': emergency,
    };
  }

  Pet copyWith({
    int? id,
    String? name,
    Species? species,
    String? breed,
    int? age,
    bool? adopted,
    String? imageUrl,
    String? description,
    String? category,
    double? weight,
    bool? neutered,
    bool? isPpp,
    List<String>? imageUrls,
    bool? emergency,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      adopted: adopted ?? this.adopted,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      category: category ?? this.category,
      weight: weight ?? this.weight,
      neutered: neutered ?? this.neutered,
      isPpp: isPpp ?? this.isPpp,
      imageUrls: imageUrls ?? this.imageUrls,
      emergency: emergency ?? this.emergency,
    );
  }

  static Species _speciesFromString(String species) {
    switch (species.toLowerCase().trim()) {
      case 'perro':
      case 'dog':
        return Species.perro;
      case 'gato':
      case 'cat':
        return Species.gato;
      default:
        return Species.perro;
    }
  }

  static String _speciesToString(Species species) {
    switch (species) {
      case Species.perro:
        return 'Perro';
      case Species.gato:
        return 'Gato';
    }
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final String normalized = value.toLowerCase().trim();
      return normalized == 'true' || normalized == '1' || normalized == 'yes';
    }
    return false;
  }

  static List<String> _parseImageUrls(dynamic value, String fallbackImage) {
    if (value is List) {
      return value.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
    }
    if (fallbackImage.isNotEmpty) {
      return <String>[fallbackImage];
    }
    return const <String>[];
  }
}