import 'package:cafeconhuellas_front/models/donation.dart' show Donation;
import 'package:flutter_test/flutter_test.dart';
// Cambia la ruta según tu proyecto


void main() {
  group('Donation Tests', () {
    final donation = Donation(
      id: 1,
      userId: 100,
      date: DateTime.parse('2024-05-01T15:30:00'),
      category: 'Dinero',
      method: 'Tarjeta',
      amount: 50,
      notes: 'Donación mensual',
    );

    test('toJson devuelve un mapa válido', () {
      final json = donation.toJson();

      expect(json['id'], 1);
      expect(json['userId'], 100);
      expect(
        json['date'],
        donation.date.toIso8601String(),
      );
      expect(json['category'], 'Dinero');
      expect(json['method'], 'Tarjeta');
      expect(json['amount'], 50);
      expect(json['notes'], 'Donación mensual');
    });

    test('toJson no incluye id cuando es 0', () {
      final donationWithoutId = Donation(
        id: 0,
        userId: 100,
        date: DateTime.parse('2024-05-01T15:30:00'),
        category: 'Comida',
        method: 'Efectivo',
        amount: 20,
        notes: 'Ayuda',
      );

      final json = donationWithoutId.toJson();

      expect(json.containsKey('id'), false);
    });

    test('fromJson crea correctamente un objeto Donation', () {
      final json = donation.toJson();

      final result = Donation.fromJson(json);

      expect(result.id, donation.id);
      expect(result.userId, donation.userId);
      expect(result.date, donation.date);
      expect(result.category, donation.category);
      expect(result.method, donation.method);
      expect(result.amount, donation.amount);
      expect(result.notes, donation.notes);
    });

    test('fromJson lanza excepción con datos inválidos', () {
      final json = {
        'id': 'error',
      };

      expect(
        () => Donation.fromJson(json),
        throwsA(isA<TypeError>()),
      );
    });
  });
}