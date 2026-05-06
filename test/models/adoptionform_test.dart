import 'package:cafeconhuellas_front/models/adoptionForm.dart';
import 'package:flutter_test/flutter_test.dart';
// Cambia la ruta según tu proyecto


void main() {
  group('Adoptionform Tests', () {
    final adoptionForm = Adoptionform(
      address: 'Calle Falsa 123',
      city: 'Madrid',
      housingType: 'Apartamento',
      hasGarden: 'false',
      hasOtherPets: 'true',
      hasChildren: 'false',
      hoursAlonePerDay: 4,
      experienceWithPets: 'Sí',
      reasonForAdoption: 'Quiero adoptar una mascota',
      agreesToFollowUp: 'true',
      additionalInfo: 'Sin información adicional',
    );

    test('toJson devuelve un mapa válido', () {
      final json = adoptionForm.toJson();

      expect(json['address'], 'Calle Falsa 123');
      expect(json['city'], 'Madrid');
      expect(json['housingType'], 'Apartamento');
      expect(json['hasGarden'], 'false');
      expect(json['hasOtherPets'], 'true');
      expect(json['hasChildren'], 'false');
      expect(json['hoursAlonePerDay'], 4);
      expect(json['experienceWithPets'], 'Sí');
      expect(json['reasonForAdoption'], 'Quiero adoptar una mascota');
      expect(json['agreesToFollowUp'], 'true');
      expect(json['additionalInfo'], 'Sin información adicional');
    });

    test('fromJson crea correctamente un objeto Adoptionform', () {
      final json = adoptionForm.toJson();

      final result = Adoptionform.fromJson(json);

      expect(result.address, adoptionForm.address);
      expect(result.city, adoptionForm.city);
      expect(result.housingType, adoptionForm.housingType);
      expect(result.hasGarden, adoptionForm.hasGarden);
      expect(result.hasOtherPets, adoptionForm.hasOtherPets);
      expect(result.hasChildren, adoptionForm.hasChildren);
      expect(result.hoursAlonePerDay, adoptionForm.hoursAlonePerDay);
      expect(result.experienceWithPets, adoptionForm.experienceWithPets);
      expect(result.reasonForAdoption, adoptionForm.reasonForAdoption);
      expect(result.agreesToFollowUp, adoptionForm.agreesToFollowUp);
      expect(result.additionalInfo, adoptionForm.additionalInfo);
    });
  });
}