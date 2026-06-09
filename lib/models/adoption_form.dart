/// Represents an adoption form submitted by a user.
///
/// This model contains all the information required
/// to evaluate a pet adoption request before it is sent
/// to the backend API.
class Adoptionform {

  /// User's home address.
  String address;

  /// City where the user lives.
  String city;

  /// Type of housing (e.g. apartment, house).
  String housingType;

  /// Indicates whether the home has a garden.
  String hasGarden;

  /// Indicates whether the user already owns other pets.
  String hasOtherPets;

  /// Indicates whether there are children in the household.
  String hasChildren;

  /// Number of hours the pet would stay alone per day.
  int hoursAlonePerDay;

  /// User's previous experience with pets.
  String experienceWithPets;

  /// Main reason why the user wants to adopt a pet.
  String reasonForAdoption;

  /// Indicates whether the user agrees to follow-up checks.
  String agreesToFollowUp;

  /// Additional information provided by the user.
  String additionalInfo;

  /// Creates a new [Adoptionform] instance.
  Adoptionform({
    required this.address,
    required this.city,
    required this.housingType,
    required this.hasGarden,
    required this.hasOtherPets,
    required this.hasChildren,
    required this.hoursAlonePerDay,
    required this.experienceWithPets,
    required this.reasonForAdoption,
    required this.agreesToFollowUp,
    required this.additionalInfo,
  });

  /// Converts this object into a JSON map.
  ///
  /// Used when sending adoption form data to the API.
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'housingType': housingType,
      'hasGarden': hasGarden,
      'hasOtherPets': hasOtherPets,
      'hasChildren': hasChildren,
      'hoursAlonePerDay': hoursAlonePerDay,
      'experienceWithPets': experienceWithPets,
      'reasonForAdoption': reasonForAdoption,
      'agreesToFollowUp': agreesToFollowUp,
      'additionalInfo': additionalInfo,
    };
  }

  /// Creates an [Adoptionform] instance from JSON data.
  ///
  /// Typically used when parsing API responses.
  factory Adoptionform.fromJson(Map<String, dynamic> json) {
    return Adoptionform(
      address: json['address'] as String,
      city: json['city'] as String,
      housingType: json['housingType'] as String,
      hasGarden: json['hasGarden'] as String,
      hasOtherPets: json['hasOtherPets'] as String,
      hasChildren: json['hasChildren'] as String,
      hoursAlonePerDay: json['hoursAlonePerDay'] as int,
      experienceWithPets: json['experienceWithPets'] as String,
      reasonForAdoption: json['reasonForAdoption'] as String,
      agreesToFollowUp: json['agreesToFollowUp'] as String,
      additionalInfo: json['additionalInfo'] as String,
    );
  }
}
/// Represents a complete adoption request.
///
/// This model contains user information, pet details,
/// adoption form answers, request status,
/// and submission metadata returned by the backend.
class AdoptionRequest {

  /// Unique identifier of the adoption request.
  final int id;

  /// Token identifier associated with the adoption form.
  final int formTokenId;

  /// Full name of the applicant.
  final String userName;

  /// Applicant's email address.
  final String userEmail;

  /// Name of the pet being adopted.
  final String petName;

  /// Applicant's address.
  final String address;

  /// Applicant's city.
  final String city;

  /// Type of housing where the applicant lives.
  final String housingType;

  /// Indicates whether the home has a garden.
  final bool hasGarden;

  /// Indicates whether the applicant owns other pets.
  final bool hasOtherPets;

  /// Indicates whether there are children in the household.
  final bool hasChildren;

  /// Number of hours the pet would stay alone daily.
  final int hoursAlonePerDay;

  /// Indicates whether the applicant has previous pet experience.
  final bool experienceWithPets;

  /// Reason provided for adopting the pet.
  final String reasonForAdoption;

  /// Indicates whether the applicant agrees to follow-up checks.
  final bool agreesToFollowUp;

  /// Additional comments or information.
  final String additionalInfo;

  /// Relationship identifier associated with the request.
  final int relationshipId;

  /// Current request status.
  ///
  /// Example values:
  /// - PENDING
  /// - APPROVED
  /// - REJECTED
  final String status;

  /// Date and time when the request was submitted.
  final DateTime submittedAt;

  /// Creates a new [AdoptionRequest] instance.
  AdoptionRequest({
    required this.id,
    required this.formTokenId,
    required this.userName,
    required this.userEmail,
    required this.petName,
    required this.address,
    required this.city,
    required this.housingType,
    required this.hasGarden,
    required this.hasOtherPets,
    required this.hasChildren,
    required this.hoursAlonePerDay,
    required this.experienceWithPets,
    required this.reasonForAdoption,
    required this.agreesToFollowUp,
    required this.additionalInfo,
    required this.relationshipId,
    required this.status,
    required this.submittedAt,
  });

  /// Creates an [AdoptionRequest] object from JSON data.
  ///
  /// Includes null safety handling and type conversion
  /// for API responses.
  factory AdoptionRequest.fromJson(Map<String, dynamic> json) {
    return AdoptionRequest(
      id: (json['id'] as num?)?.toInt() ?? 0,
      formTokenId: (json['formTokenId'] as num?)?.toInt() ?? 0,
      userName: (json['userName'] ?? '').toString(),
      userEmail: (json['userEmail'] ?? '').toString(),
      petName: (json['petName'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      housingType: (json['housingType'] ?? '').toString(),
      hasGarden: json['hasGarden'] == true || json['hasGarden'] == 'true',
      hasOtherPets: json['hasOtherPets'] == true || json['hasOtherPets'] == 'true',
      hasChildren: json['hasChildren'] == true || json['hasChildren'] == 'true',
      hoursAlonePerDay: (json['hoursAlonePerDay'] as num?)?.toInt() ?? 0,
      experienceWithPets: json['experienceWithPets'] == true || json['experienceWithPets'] == 'true',
      reasonForAdoption: (json['reasonForAdoption'] ?? '').toString(),
      agreesToFollowUp: json['agreesToFollowUp'] == true || json['agreesToFollowUp'] == 'true',
      additionalInfo: (json['additionalInfo'] ?? '').toString(),
      relationshipId: (json['relationshipId'] as num?)?.toInt() ?? 0,
      status: (json['status'] ?? 'PENDING').toString(),
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'].toString())
          : DateTime.now(),
    );
  }

  /// Converts this object into JSON format.
  ///
  /// Used for API requests and local persistence.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'formTokenId': formTokenId,
      'userName': userName,
      'userEmail': userEmail,
      'petName': petName,
      'address': address,
      'city': city,
      'housingType': housingType,
      'hasGarden': hasGarden,
      'hasOtherPets': hasOtherPets,
      'hasChildren': hasChildren,
      'hoursAlonePerDay': hoursAlonePerDay,
      'experienceWithPets': experienceWithPets,
      'reasonForAdoption': reasonForAdoption,
      'agreesToFollowUp': agreesToFollowUp,
      'additionalInfo': additionalInfo,
      'relationshipId': relationshipId,
      'status': status,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }
}