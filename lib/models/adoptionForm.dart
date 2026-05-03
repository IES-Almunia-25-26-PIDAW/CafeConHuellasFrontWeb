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
    status: (json['status'] ?? 'PENDIENTE').toString(),
    submittedAt: json['submittedAt'] != null 
        ? DateTime.parse(json['submittedAt'].toString()) 
        : DateTime.now(),
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