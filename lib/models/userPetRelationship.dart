import 'package:cafeconhuellas_front/models/user.dart';

class Userpetrelationship {
  int id;
  int userId;
  int petId;
  String relationshipType; // "APADRINAMIENTO", "PASEO", "VOLUNTARIADO","CASA DE ACOGIDA"
  DateTime startDate;
  DateTime? endDate;
  bool active;

  Userpetrelationship({
    required this.id,
    required this.userId,
    required this.petId,
    required this.relationshipType,
    required this.startDate,
    this.endDate,
    required this.active,
  });

  factory Userpetrelationship.fromJson(Map<String, dynamic> json) {
    return Userpetrelationship(
      id: json['id'] as int,
      userId: json['userId'] as int,
      petId: json['petId'] as int,
      relationshipType: json['relationshipType'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      active: json['active'] as bool,
    );
  }
  Map<String, dynamic> toJson() {
  final map = <String, dynamic>{
    'userId': userId,
    'petId': petId,
    'relationshipType': relationshipType,
    'startDate': startDate.toIso8601String().split('T')[0],
    'endDate': endDate?.toIso8601String().split('T')[0],
    'active': active,
  };
  if (id != 0) map['id'] = id;
  return map;
}


}