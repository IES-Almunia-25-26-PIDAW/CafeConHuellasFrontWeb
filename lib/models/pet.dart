class Pet {
  final int id;
  final String name;
  final String description;
  final String breed;
  final String category;
  final int age;
  final double weight;
  final bool neutered;
  final bool isPpp;
  final String imageUrl;
  final List<String> imageUrls;
  final bool urgentAdoption;
  final String adoptionStatus;


  Pet({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.imageUrl,
    required this.description,
    required this.category,
    this.weight = 0.0,
    this.neutered = false,
    this.isPpp = false,
    List<String>? imageUrls,
    required this.urgentAdoption,
    required this.adoptionStatus,
  }) : imageUrls = imageUrls ?? const [];

  factory Pet.fromJson(Map<String, dynamic> json) {
    final String cat = (json['category'] ?? json['species'] ?? 'Perro').toString();
    final String mainImage = (json['imageUrl'] ?? json['image_url'] ?? '').toString();

    return Pet(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? '').toString(),
      breed: (json['breed'] ?? '').toString(),
      age: (json['age'] as num?)?.toInt() ?? 0,
      imageUrl: mainImage,
      description: (json['description'] ?? '').toString(),
      category: cat,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      neutered: _parseBool(json['neutered'] ?? false),
      isPpp: _parseBool(json['isPpp'] ?? json['is_ppp'] ?? false),
      imageUrls: _parseImageUrls(json['imageUrls'] ?? json['image_urls'], mainImage),
      urgentAdoption: _parseBool(json['urgentAdoption'] ?? json['isUrgentAdoption'] ?? false),
      adoptionStatus: (json['adoptionStatus'] ?? json['adoption_status'] ?? 'available').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
    'name':           name,
    'category':       category,
    'breed':          breed,
    'age':            age,
    'weight':         weight,
    'neutered':       neutered,
    'isPpp':          isPpp,
    'imageUrl':       imageUrl,
    'imageUrls':      imageUrls,
    'description':    description,
    'urgentAdoption': urgentAdoption,
    'adoptionStatus': adoptionStatus,
  };

  if (id != 0) map['id'] = id;

  return map;
  }

  Pet copyWith({
    int? id,
    String? name,
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
    bool? urgentAdoption,
    String? adoptionStatus,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      category: category ?? this.category,
      weight: weight ?? this.weight,
      neutered: neutered ?? this.neutered,
      isPpp: isPpp ?? this.isPpp,
      imageUrls: imageUrls ?? this.imageUrls,
      urgentAdoption: urgentAdoption ?? this.urgentAdoption,
      adoptionStatus: adoptionStatus ?? this.adoptionStatus,  
    );
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