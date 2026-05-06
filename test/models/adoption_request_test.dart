import 'package:cafeconhuellas_front/models/adoptionForm.dart';
import 'package:flutter_test/flutter_test.dart';
// Cambia la ruta según tu proyecto


void main() {
  group('AdoptionRequest Tests', () {
    final submittedDate = DateTime.parse('2024-05-01T12:00:00');

    final adoptionRequest = AdoptionRequest(
      id: 1,
      formTokenId: 10,
      userName: 'Juan Pérez',
      userEmail: 'juan@example.com',
      petName: 'Firulais',
      address: 'Calle Luna 45',
      city: 'Sevilla',
      housingType: 'Casa',
      hasGarden: true,
      hasOtherPets: false,
      hasChildren: true,
      hoursAlonePerDay: 5,
      experienceWithPets: true,
      reasonForAdoption: 'Amor por los animales',
      agreesToFollowUp: true,
      additionalInfo: 'Tengo experiencia previa',
      relationshipId: 2,
      status: 'PENDIENTE',
      submittedAt: submittedDate,
    );

    test('toJson devuelve un mapa válido', () {
      final json = adoptionRequest.toJson();

      expect(json['id'], 1);
      expect(json['formTokenId'], 10);
      expect(json['userName'], 'Juan Pérez');
      expect(json['userEmail'], 'juan@example.com');
      expect(json['petName'], 'Firulais');
      expect(json['address'], 'Calle Luna 45');
      expect(json['city'], 'Sevilla');
      expect(json['housingType'], 'Casa');
      expect(json['hasGarden'], true);
      expect(json['hasOtherPets'], false);
      expect(json['hasChildren'], true);
      expect(json['hoursAlonePerDay'], 5);
      expect(json['experienceWithPets'], true);
      expect(json['reasonForAdoption'], 'Amor por los animales');
      expect(json['agreesToFollowUp'], true);
      expect(json['additionalInfo'], 'Tengo experiencia previa');
      expect(json['relationshipId'], 2);
      expect(json['status'], 'PENDIENTE');
      expect(
        json['submittedAt'],
        submittedDate.toIso8601String(),
      );
    });

    test('fromJson crea correctamente un objeto AdoptionRequest', () {
      final json = adoptionRequest.toJson();

      final result = AdoptionRequest.fromJson(json);

      expect(result.id, adoptionRequest.id);
      expect(result.formTokenId, adoptionRequest.formTokenId);
      expect(result.userName, adoptionRequest.userName);
      expect(result.userEmail, adoptionRequest.userEmail);
      expect(result.petName, adoptionRequest.petName);
      expect(result.address, adoptionRequest.address);
      expect(result.city, adoptionRequest.city);
      expect(result.housingType, adoptionRequest.housingType);
      expect(result.hasGarden, adoptionRequest.hasGarden);
      expect(result.hasOtherPets, adoptionRequest.hasOtherPets);
      expect(result.hasChildren, adoptionRequest.hasChildren);
      expect(result.hoursAlonePerDay, adoptionRequest.hoursAlonePerDay);
      expect(
        result.experienceWithPets,
        adoptionRequest.experienceWithPets,
      );
      expect(
        result.reasonForAdoption,
        adoptionRequest.reasonForAdoption,
      );
      expect(
        result.agreesToFollowUp,
        adoptionRequest.agreesToFollowUp,
      );
      expect(result.additionalInfo, adoptionRequest.additionalInfo);
      expect(result.relationshipId, adoptionRequest.relationshipId);
      expect(result.status, adoptionRequest.status);
      expect(result.submittedAt, adoptionRequest.submittedAt);
    });

    test('fromJson usa valores por defecto cuando faltan campos', () {
      final json = <String, dynamic>{};

      final result = AdoptionRequest.fromJson(json);

      expect(result.id, 0);
      expect(result.formTokenId, 0);
      expect(result.userName, '');
      expect(result.userEmail, '');
      expect(result.petName, '');
      expect(result.address, '');
      expect(result.city, '');
      expect(result.housingType, '');
      expect(result.hasGarden, false);
      expect(result.hasOtherPets, false);
      expect(result.hasChildren, false);
      expect(result.hoursAlonePerDay, 0);
      expect(result.experienceWithPets, false);
      expect(result.reasonForAdoption, '');
      expect(result.agreesToFollowUp, false);
      expect(result.additionalInfo, '');
      expect(result.relationshipId, 0);
      expect(result.status, 'PENDIENTE');
    });

    test('fromJson convierte strings booleanos correctamente', () {
      final json = {
        'id': 1,
        'formTokenId': 1,
        'userName': 'Test',
        'userEmail': 'test@test.com',
        'petName': 'Rocky',
        'address': 'Dirección',
        'city': 'Ciudad',
        'housingType': 'Casa',
        'hasGarden': 'true',
        'hasOtherPets': 'false',
        'hasChildren': 'true',
        'hoursAlonePerDay': 2,
        'experienceWithPets': 'true',
        'reasonForAdoption': 'Porque sí',
        'agreesToFollowUp': 'true',
        'additionalInfo': '',
        'relationshipId': 1,
        'status': 'APROBADO',
        'submittedAt': '2024-05-01T12:00:00',
      };

      final result = AdoptionRequest.fromJson(json);

      expect(result.hasGarden, true);
      expect(result.hasOtherPets, false);
      expect(result.hasChildren, true);
      expect(result.experienceWithPets, true);
      expect(result.agreesToFollowUp, true);
    });
  });
}