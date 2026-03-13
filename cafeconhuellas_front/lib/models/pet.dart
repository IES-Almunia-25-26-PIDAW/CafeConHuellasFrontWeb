enum Species { perro, gato }

enum Size { pequeno, mediano, grande }

class Pet {
  final int id;
  final String name;
  final Species species;
  final String breed;
  final int age;
  final Size size;
  final String location;
  final bool adopted;
  final String imageUrl;
  final String description;
  final bool emergency;

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.size,
    required this.location,
    required this.adopted,
    required this.imageUrl,
    required this.description,
    required this.emergency,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      species: _speciesFromString(json['species']),
      breed: json['breed'],
      age: json['age'],
      size: _sizeFromString(json['size']),
      location: json['location'],
      adopted: json['adopted'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      emergency: json['emergency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'species': _speciesToString(species),
      'breed': breed,
      'age': age,
      'size': _sizeToString(size),
      'location': location,
      'adopted': adopted,
      'imageUrl': imageUrl,
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
    Size? size,
    String? location,
    bool? adopted,
    String? imageUrl,
    String? description,
    bool? emergency,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      size: size ?? this.size,
      location: location ?? this.location,
      adopted: adopted ?? this.adopted,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      emergency: emergency ?? this.emergency,
    );
  }

  static Species _speciesFromString(String species) {
    switch (species) {
      case 'Perro':
        return Species.perro;
      case 'Gato':
        return Species.gato;
      default:
        throw Exception('Unknown species: $species');
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

  static Size _sizeFromString(String size) {
    switch (size) {
      case 'Pequeno':
        return Size.pequeno;
      case 'Mediano':
        return Size.mediano;
      case 'Grande':
        return Size.grande;
      default:
        throw Exception('Unknown size: $size');
    }
  }

  static String _sizeToString(Size size) {
    switch (size) {
      case Size.pequeno:
        return 'Pequeno';
      case Size.mediano:
        return 'Mediano';
      case Size.grande:
        return 'Grande';
    }
  }
}