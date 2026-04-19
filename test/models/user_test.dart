import 'package:cafeconhuellas_front/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User', () {

    test('fromJson crea correctamente un User', () {
      final json = {
        'id': 1,
        'firstName': 'Juan',
        'lastName1': 'Perez',
        'lastName2': 'Lopez',
        'password': '1234',
        'email': 'test@test.com',
        'phone': '123456',
        'role': 'user',
        'imageUrl': 'img.jpg',
      };

      final user = User.fromJson(json);

      expect(user.id, 1);
      expect(user.firstName, 'Juan');
      expect(user.email, 'test@test.com');
    });

    test('fromJson funciona con snake_case', () {
      final json = {
        'id': 1,
        'first_name': 'Ana',
        'last_name1': 'Garcia',
        'last_name2': 'Lopez',
        'email': 'ana@test.com',
        'phone': '123',
        'role': 'admin',
        'image_url': 'img.jpg',
      };

      final user = User.fromJson(json);

      expect(user.firstName, 'Ana');
      expect(user.imageUrl, 'img.jpg');
    });

    test('toJson devuelve un mapa válido', () {
      final user = User(
        id: 1,
        firstName: 'Juan',
        lastName1: 'Perez',
        lastName2: 'Lopez',
        password: '1234',
        email: 'test@test.com',
        phone: '123',
        role: 'user',
        imageUrl: 'img.jpg',
      );

      final json = user.toJson();

      expect(json['id'], 1);
      expect(json['firstName'], 'Juan');
    });

    test('copyWith modifica solo lo necesario', () {
      final user = User(
        id: 1,
        firstName: 'Juan',
        lastName1: 'Perez',
        lastName2: 'Lopez',
        password: '1234',
        email: 'test@test.com',
        phone: '123',
        role: 'user',
        imageUrl: 'img.jpg',
      );

      final updated = user.copyWith(firstName: 'Pedro');

      expect(updated.firstName, 'Pedro');
      expect(updated.id, 1);
    });

  });
}