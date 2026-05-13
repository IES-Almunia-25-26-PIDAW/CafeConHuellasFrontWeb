/// Represents a pet available for adoption.
///
/// This model contains all pet-related information,
/// including physical characteristics, adoption details,
/// and image resources.
class Pet {

  /// Unique identifier of the pet.
  final int id;

  /// Pet's name.
  final String name;

  /// Detailed description of the pet.
  final String description;

  /// Breed of the pet.
  final String breed;

  /// Pet category or species.
  ///
  /// Example values:
  /// - Dog
  /// - Cat
  /// - Rabbit
  final String category;

  /// Age of the pet in years.
  final int age;

  /// Weight of the pet in kilograms.
  final double weight;

  /// Indicates whether the pet has been neutered.
  final bool neutered;

  /// Indicates whether the pet is classified as
  /// a potentially dangerous breed (PPP).
  final bool isPpp;

  /// Main image URL of the pet.
  final String imageUrl;

  /// Additional image URLs associated with the pet.
  final List<String> imageUrls;

  /// Indicates whether the pet requires urgent adoption.
  final bool urgentAdoption;

  /// Current adoption status of the pet.
  ///
  /// Example values:
  /// - available
  /// - pending
  /// - adopted
  final String adoptionStatus;

  /// Creates a new [Pet] instance.
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

  /// Creates a [Pet] instance from JSON data.
  ///
  /// Includes fallback handling and type conversion
  /// for API compatibility.
  factory Pet.fromJson(Map<String, dynamic> json) {
    final String cat =
        (json['category'] ?? json['species'] ?? 'Dog').toString();

    final String mainImage =
        (json['imageUrl'] ?? json['image_url'] ?? '').toString();

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
      imageUrls: _parseImageUrls(
        json['imageUrls'] ?? json['image_urls'],
        mainImage,
      ),
      urgentAdoption: _parseBool(
        json['urgentAdoption'] ??
        json['isUrgentAdoption'] ??
        false,
      ),
      adoptionStatus:
          (json['adoptionStatus'] ??
          json['adoption_status'] ??
          'available').toString(),
    );
  }

  /// Converts this object into JSON format.
  ///
  /// Used for API requests and local persistence.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'category': category,
      'breed': breed,
      'age': age,
      'weight': weight,
      'neutered': neutered,
      'isPpp': isPpp,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
      'description': description,
      'urgentAdoption': urgentAdoption,
      'adoptionStatus': adoptionStatus,
    };

    if (id != 0) {
      map['id'] = id;
    }

    return map;
  }

  /// Creates a copy of this object with updated values.
  ///
  /// Only the provided parameters are replaced.
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

  /// Safely converts dynamic values into boolean values.
  ///
  /// Supports:
  /// - bool
  /// - numeric values
  /// - string representations
  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    if (value is String) {
      final String normalized = value.toLowerCase().trim();

      return normalized == 'true' ||
          normalized == '1' ||
          normalized == 'yes';
    }

    return false;
  }

  /// Parses image URL lists safely.
  ///
  /// Returns the fallback image if no valid list exists.
  static List<String> _parseImageUrls(
    dynamic value,
    String fallbackImage,
  ) {
    if (value is List) {
      return value
          .map((e) => e.toString())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    if (fallbackImage.isNotEmpty) {
      return <String>[fallbackImage];
    }

    return const <String>[];
  }
}