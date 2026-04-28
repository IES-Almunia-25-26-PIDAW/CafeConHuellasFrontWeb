import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Pet', () {

    test('fromJson crea correctamente un Pet', () {
      final json = {
        'id': 1,
        'name': 'Bobby',
        'species': 'dog',
        'breed': 'Labrador',
        'age': 2,
        'adopted': true,
        'imageUrl': 'img.jpg',
        'description': 'Desc',
        'category': 'Perro',
        'weight': 10.5,
        'neutered': true,
        'isPpp': false,
        'imageUrls': ['img1.jpg', 'img2.jpg'],
        'urgentAdoption': true,
      };

      final pet = Pet.fromJson(json);

      expect(pet.id, 1);
      expect(pet.name, 'Bobby');
      expect(pet.breed, 'Labrador');
      expect(pet.age, 2);
      expect(pet.imageUrl, 'img.jpg');
      expect(pet.category, 'Perro');
      expect(pet.urgentAdoption, true);
    });

    test('fromJson parsea species correctamente', () {
      final json = {
        'id': 1,
        'name': 'Michi',
        'category': 'Gato',
        'breed': 'Siames',
        'age': 3,
        'adopted': false,
        'imageUrl': 'img.jpg',
        'description': 'Desc',
        'urgentAdoption': false,
      };

      final pet = Pet.fromJson(json);

      expect(pet.category, 'Gato');
    });

    test('toJson devuelve un mapa válido', () {
      final pet = Pet(
        id: 1,
        name: 'Bobby',
        category: 'Perro',
        breed: 'Labrador',
        age: 2,
        imageUrl: 'img.jpg',
        description: 'Desc',
        urgentAdoption: false, adoptionStatus: '',
      );

      final json = pet.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'Bobby');
      expect(json['category'], 'Perro');
    });

    test('copyWith modifica solo lo necesario', () {
      final pet = Pet(
        id: 1,
        name: 'Bobby',
        category: 'Perro',
        breed: 'Labrador',
        age: 2,

        imageUrl: 'img.jpg',
        description: 'Desc',
        urgentAdoption: false, adoptionStatus: '',
      );

      final updated = pet.copyWith(name: 'Max');

      expect(updated.name, 'Max');
      expect(updated.id, 1);
    });

  });
}