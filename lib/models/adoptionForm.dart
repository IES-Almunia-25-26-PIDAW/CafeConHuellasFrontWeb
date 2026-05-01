class Adoptionform {
  String address;
  String city;
  String housingType;
  String hasGarden;
  String hasOtherPets;
  String hasChildren;
  int hoursAlonePerDay;
  String experienceWithPets;
  String reasonForAdoption;
  String agreesToFollowUp;
  String additionalInfo;

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
class AdoptionRequest {
  final int id;
  final int formTokenId;
  final String userName;
  final String userEmail;
  final String petName;
  final String address;
  final String city;
  final String housingType;
  final bool hasGarden;
  final bool hasOtherPets;
  final bool hasChildren;
  final int hoursAlonePerDay;
  final bool experienceWithPets;
  final String reasonForAdoption;
  final bool agreesToFollowUp;
  final String additionalInfo;
  final int relationshipId;
  final String status;
  final DateTime submittedAt;

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

  // Para convertir de JSON (Map) a Objeto Dart
  factory AdoptionRequest.fromJson(Map<String, dynamic> json) {
    return AdoptionRequest(
      id: json['id'],
      formTokenId: json['formTokenId'],
      userName: json['userName'] ?? '',
      userEmail: json['userEmail'] ?? '',
      petName: json['petName'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      housingType: json['housingType'] ?? '',
      hasGarden: json['hasGarden'] ?? false,
      hasOtherPets: json['hasOtherPets'] ?? false,
      hasChildren: json['hasChildren'] ?? false,
      hoursAlonePerDay: json['hoursAlonePerDay'] ?? 0,
      experienceWithPets: json['experienceWithPets'] ?? false,
      reasonForAdoption: json['reasonForAdoption'] ?? '',
      agreesToFollowUp: json['agreesToFollowUp'] ?? false,
      additionalInfo: json['additionalInfo'] ?? '',
      relationshipId: json['relationshipId'],
      status: json['status'] ?? 'PENDIENTE',
      submittedAt: DateTime.parse(json['submittedAt']),
    );
  }

  // Para convertir de Objeto Dart a JSON (para enviar a la API)
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