import 'package:cafeconhuellas_front/models/userPetRelationship.dart';
import 'package:flutter_test/flutter_test.dart';
// Cambia la ruta según tu proyecto

void main() {
  group('Userpetrelationship Tests', () {
    final relationship = Userpetrelationship(
      id: 1,
      userId: 10,
      petId: 20,
      relationshipType: 'APADRINAMIENTO',
      startDate: DateTime.parse('2024-05-01'),
      endDate: DateTime.parse('2024-06-01'),
      active: true,
    );

    test('toJson devuelve un mapa válido', () {
      final json = relationship.toJson();

      expect(json['id'], 1);
      expect(json['userId'], 10);
      expect(json['petId'], 20);
      expect(json['relationshipType'], 'APADRINAMIENTO');
      expect(json['startDate'], '2024-05-01');
      expect(json['endDate'], '2024-06-01');
      expect(json['active'], true);
    });

    test('toJson no incluye id cuando es 0', () {
      final relationshipWithoutId = Userpetrelationship(
        id: 0,
        userId: 5,
        petId: 8,
        relationshipType: 'VOLUNTARIADO',
        startDate: DateTime.parse('2024-01-10'),
        endDate: null,
        active: false,
      );

      final json = relationshipWithoutId.toJson();

      expect(json.containsKey('id'), false);
    });

    test('toJson maneja endDate null correctamente', () {
      final relationshipWithoutEndDate = Userpetrelationship(
        id: 2,
        userId: 11,
        petId: 22,
        relationshipType: 'PASEO',
        startDate: DateTime.parse('2024-03-15'),
        endDate: null,
        active: true,
      );

      final json = relationshipWithoutEndDate.toJson();

      expect(json['endDate'], null);
    });

    test('fromJson crea correctamente un objeto Userpetrelationship', () {
      final json = {
        'id': 1,
        'userId': 10,
        'petId': 20,
        'relationshipType': 'APADRINAMIENTO',
        'startDate': '2024-05-01',
        'endDate': '2024-06-01',
        'active': true,
      };

      final result = Userpetrelationship.fromJson(json);

      expect(result.id, relationship.id);
      expect(result.userId, relationship.userId);
      expect(result.petId, relationship.petId);
      expect(result.relationshipType, relationship.relationshipType);
      expect(result.startDate, relationship.startDate);
      expect(result.endDate, relationship.endDate);
      expect(result.active, relationship.active);
    });

    test('fromJson maneja endDate null correctamente', () {
      final json = {
        'id': 2,
        'userId': 15,
        'petId': 30,
        'relationshipType': 'CASA DE ACOGIDA',
        'startDate': '2024-04-10',
        'endDate': null,
        'active': false,
      };

      final result = Userpetrelationship.fromJson(json);

      expect(result.id, 2);
      expect(result.userId, 15);
      expect(result.petId, 30);
      expect(result.relationshipType, 'CASA DE ACOGIDA');
      expect(result.startDate, DateTime.parse('2024-04-10'));
      expect(result.endDate, null);
      expect(result.active, false);
    });

    test('fromJson lanza excepción con tipos inválidos', () {
      final json = {
        'id': 'error',
        'userId': 'invalid',
      };

      expect(
        () => Userpetrelationship.fromJson(json),
        throwsA(isA<TypeError>()),
      );
    });
  });
}