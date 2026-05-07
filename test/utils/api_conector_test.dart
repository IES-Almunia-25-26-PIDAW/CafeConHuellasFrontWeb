// test/utils/api_conector_extra_test.dart
import 'package:cafeconhuellas_front/models/donation.dart';
import 'package:cafeconhuellas_front/models/event.dart';
import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/models/userPetRelationship.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

// helpers 

Map<String, dynamic> get _petJson => {
      'id': 1,
      'name': 'Rex',
      'species': 'perro',
      'breed': 'Labrador',
      'age': 3,
      'adopted': false,
      'imageUrl': '',
      'description': 'Buen perro',
      'emergency': false,
    };

Map<String, dynamic> get _eventJson => {
      'id': 10,
      'name': 'Adopción masiva',
      'description': 'Gran evento',
      'imageUrl': '',
      'eventdate': '2025-12-01T10:00:00',
    };

Map<String, dynamic> get _donationJson => {
  'id': 5,
  'amount': 20,           // ← cámbialo aquí
  'userId': 1,
  'date': '2025-01-01T00:00:00',
  'category': 'MONETARIA', // ← añádelo aquí
  'method': 'TARJETA',     // ← añádelo aquí
  'notes': '',             // ← añádelo aquí
};

Map<String, dynamic> get _relationshipJson => {
      'id': 7,
      'userId': 1,
      'petId': 1,
      'relationshipType': 'VOLUNTARIADO',
      'startDate': '2025-01-01T00:00:00',
      'endDate': '2025-06-01T00:00:00',
      'active': false,
    };

Map<String, dynamic> get _adoptionRequestJson => {
      'id': 3,
      'userId': 1,
      'petId': 1,
      'status': 'PENDIENTE',
      'requestDate': '2025-01-01T00:00:00',
    };

Pet get _pet => Pet.fromJson(_petJson);
Event get _event => Event.fromJson(_eventJson);
Donation get _donation => Donation.fromJson(_donationJson);
Userpetrelationship get _relationship => Userpetrelationship.fromJson(_relationshipJson);

//  tests

void main() {
  late ApiConector api;
  late DioAdapter dioAdapter;

  setUp(() {
    api = ApiConector();
    dioAdapter = DioAdapter(dio: api.dio);
  });

  //  PETS CRUD 

  group('addPet', () {
    test('completa sin error cuando el backend responde 201', () async {
      dioAdapter.onPost(
        '/pets',
        (server) => server.reply(201, _petJson),
        data: _pet.toJson(),
      );

      await expectLater(api.addPet(_pet), completes);
    });

    test('lanza excepción cuando el backend responde 400', () async {
      dioAdapter.onPost(
        '/pets',
        (server) => server.reply(400, {'message': 'Datos inválidos'}),
        data: _pet.toJson(),
      );

      expect(() => api.addPet(_pet), throwsException);
    });
  });

  group('updatePet', () {
    test('completa sin error cuando el backend responde 200', () async {
      dioAdapter.onPut(
        '/pets/${_pet.id}',
        (server) => server.reply(200, _petJson),
        data: _pet.toJson(),
      );

      await expectLater(api.updatePet(_pet), completes);
    });

    test('lanza excepción cuando el backend responde 404', () async {
      dioAdapter.onPut(
        '/pets/${_pet.id}',
        (server) => server.reply(404, {'message': 'Mascota no encontrada'}),
        data: _pet.toJson(),
      );

      expect(() => api.updatePet(_pet), throwsException);
    });

    test('el mensaje de error viene del campo "message" de la respuesta', () async {
      dioAdapter.onPut(
        '/pets/${_pet.id}',
        (server) => server.reply(422, {'message': 'La especie no es válida'}),
        data: _pet.toJson(),
      );

      expect(
        () => api.updatePet(_pet),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('La especie no es válida'),
          ),
        ),
      );
    });
  });

  group('deletePet', () {
    test('completa sin error cuando el backend responde 204', () async {
      dioAdapter.onDelete(
        '/pets/1',
        (server) => server.reply(204, null),
      );

      await expectLater(api.deletePet(1), completes);
    });

    test('lanza excepción cuando el backend responde 404', () async {
      dioAdapter.onDelete(
        '/pets/99',
        (server) => server.reply(404, {'message': 'No encontrado'}),
      );

      expect(() => api.deletePet(99), throwsException);
    });
  });

  // EVENTS CRUD

  group('addEvent', () {


    test('lanza excepción cuando el backend responde 400', () async {
      dioAdapter.onPost(
        '/events',
        (server) => server.reply(400, {'message': 'Fecha inválida'}),
        data: _event.toJson(),
      );

      expect(() => api.addEvent(_event), throwsException);
    });
  });

  group('updateEvent', () {


    test('lanza excepción en error 500', () async {
      dioAdapter.onPut(
        '/events/${_event.id}',
        (server) => server.reply(500, {'message': 'Error interno'}),
        data: _event.toJson(),
      );

      expect(() => api.updateEvent(_event), throwsException);
    });
  });

  group('deleteEvent', () {
    test('completa sin error cuando el backend responde 204', () async {
      dioAdapter.onDelete(
        '/events/10',
        (server) => server.reply(204, null),
      );

      await expectLater(api.deleteEvent(10), completes);
    });

    test('lanza excepción cuando el backend responde 404', () async {
      dioAdapter.onDelete(
        '/events/99',
        (server) => server.reply(404, {'message': 'Evento no encontrado'}),
      );

      expect(() => api.deleteEvent(99), throwsException);
    });
  });

  //  DONATIONS 

  group('getDonations', () {
    test('devuelve lista de donaciones con respuesta directa', () async {
      dioAdapter.onGet(
        '/donations',
        (server) => server.reply(200, [_donationJson]),
      );

      final donations = await api.getDonations();
      expect(donations.length, 1);
    });

    test('devuelve lista cuando los datos están bajo clave "data"', () async {
      dioAdapter.onGet(
        '/donations',
        (server) => server.reply(200, {'data': [_donationJson]}),
      );

      final donations = await api.getDonations();
      expect(donations.length, 1);
    });

    test('lanza excepción cuando la respuesta no tiene lista válida', () async {
      dioAdapter.onGet(
        '/donations',
        (server) => server.reply(200, {'unexpected': 'value'}),
      );

      expect(() => api.getDonations(), throwsException);
    });
  });

  group('addDonation', () {
    test('completa sin error cuando el backend responde 201', () async {
      dioAdapter.onPost(
        '/donations',
        (server) => server.reply(201, _donationJson),
        data: _donation.toJson(),
      );

      await expectLater(api.addDonation(_donation), completes);
    });

    test('lanza excepción cuando el backend responde 400', () async {
      dioAdapter.onPost(
        '/donations',
        (server) => server.reply(400, {'message': 'Importe inválido'}),
        data: _donation.toJson(),
      );

      expect(() => api.addDonation(_donation), throwsException);
    });
  });

  group('getMeDonation', () {
    test('devuelve mis donaciones correctamente', () async {
      dioAdapter.onGet(
        '/donations/me',
        (server) => server.reply(200, [_donationJson]),
      );

      final donations = await api.getMeDonation();
      expect(donations.length, 1);
    });

    test('devuelve lista vacía si no hay donaciones', () async {
      dioAdapter.onGet(
        '/donations/me',
        (server) => server.reply(200, []),
      );

      final donations = await api.getMeDonation();
      expect(donations, isEmpty);
    });
  });

  // RELATIONSHIPS 

  group('getUserPetRelationShip', () {
    test('devuelve lista de relaciones correctamente', () async {
      dioAdapter.onGet(
        '/relationships',
        (server) => server.reply(200, [_relationshipJson]),
      );

      final relations = await api.getUserPetRelationShip();
      expect(relations.length, 1);
      expect(relations.first.relationshipType, 'VOLUNTARIADO');
    });

    test('lanza excepción cuando la respuesta no tiene lista válida', () async {
      dioAdapter.onGet(
        '/relationships',
        (server) => server.reply(200, {'unexpected': 'value'}),
      );

      expect(() => api.getUserPetRelationShip(), throwsException);
    });
  });

  group('addUserPetRelationship', () {
    test('completa sin error cuando el backend responde 201', () async {
      dioAdapter.onPost(
        '/relationships',
        (server) => server.reply(201, _relationshipJson),
        data: _relationship.toJson(),
      );

      await expectLater(api.addUserPetRelationship(_relationship), completes);
    });

    test('lanza excepción cuando el backend responde 400', () async {
      dioAdapter.onPost(
        '/relationships',
        (server) => server.reply(400, {'message': 'Tipo de relación inválido'}),
        data: _relationship.toJson(),
      );

      expect(() => api.addUserPetRelationship(_relationship), throwsException);
    });
  });

  group('getMyRelationships', () {
    test('devuelve relaciones del usuario por id', () async {
      dioAdapter.onGet(
        '/relationships/user/1',
        (server) => server.reply(200, [_relationshipJson]),
      );

      final relations = await api.getMyRelationships(1);
      expect(relations.length, 1);
    });

    test('devuelve lista vacía si el usuario no tiene relaciones', () async {
      dioAdapter.onGet(
        '/relationships/user/99',
        (server) => server.reply(200, []),
      );

      final relations = await api.getMyRelationships(99);
      expect(relations, isEmpty);
    });
  });

  group('postMyRelationships', () {
    test('completa sin error cuando el backend responde 201', () async {
      dioAdapter.onPost(
        '/relationships/me',
        (server) => server.reply(201, _relationshipJson),
        data: _relationship.toJson(),
      );

      await expectLater(api.postMyRelationships(_relationship), completes);
    });

    test('lanza excepción en error 401 (no autenticado)', () async {
      dioAdapter.onPost(
        '/relationships/me',
        (server) => server.reply(401, {'message': 'No autorizado'}),
        data: _relationship.toJson(),
      );

      expect(() => api.postMyRelationships(_relationship), throwsException);
    });
  });

  group('updateRelationshipStatus', () {
    test('completa sin error cuando el backend responde 200', () async {
      dioAdapter.onPut(
        '/relationships/7',
        (server) => server.reply(200, _relationshipJson),
        data: _relationship.toJson(),
      );

      await expectLater(
        api.updateRelationshipStatus(7, _relationship),
        completes,
      );
    });

    test('lanza excepción cuando el backend responde 404', () async {
      dioAdapter.onPut(
        '/relationships/99',
        (server) => server.reply(404, {'message': 'Relación no encontrada'}),
        data: _relationship.toJson(),
      );

      expect(() => api.updateRelationshipStatus(99, _relationship), throwsException);
    });
  });

  //  ADOPTION 

  group('getAdoptionRequest', () {
    test('devuelve lista de solicitudes de adopción', () async {
      dioAdapter.onGet(
        '/adoption-requests',
        (server) => server.reply(200, [_adoptionRequestJson]),
      );

      final requests = await api.getAdoptionRequest();
      expect(requests.length, 1);
    });

    test('devuelve lista vacía si no hay solicitudes', () async {
      dioAdapter.onGet(
        '/adoption-requests',
        (server) => server.reply(200, []),
      );

      final requests = await api.getAdoptionRequest();
      expect(requests, isEmpty);
    });
  });

  group('getMeAdoptionRequest', () {
    test('devuelve mis solicitudes de adopción', () async {
      dioAdapter.onGet(
        '/adoption-requests/me',
        (server) => server.reply(200, [_adoptionRequestJson]),
      );

      final requests = await api.getMeAdoptionRequest();
      expect(requests.length, 1);
    });

    test('devuelve lista vacía si no tengo solicitudes', () async {
      dioAdapter.onGet(
        '/adoption-requests/me',
        (server) => server.reply(200, []),
      );

      final requests = await api.getMeAdoptionRequest();
      expect(requests, isEmpty);
    });
  });

  group('updateAdoptionStatus', () {
    test('completa sin error cuando el backend responde 200', () async {
      dioAdapter.onPatch(
        '/adoption-requests/3/status',
        (server) => server.reply(200, {}),
        queryParameters: {'status': 'APROBADA'},
      );

      await expectLater(
        api.updateAdoptionStatus(3, 'APROBADA'),
        completes,
      );
    });

    test('lanza excepción cuando el backend responde 400', () async {
      dioAdapter.onPatch(
        '/adoption-requests/3/status',
        (server) => server.reply(400, {'message': 'Estado inválido'}),
        queryParameters: {'status': 'INVALIDO'},
      );

      expect(() => api.updateAdoptionStatus(3, 'INVALIDO'), throwsException);
    });
  });

  group('requestAdoptionForm', () {
    test('completa sin error cuando el backend responde 200', () async {
      dioAdapter.onPost(
        '/adoption-form/send',
        (server) => server.reply(200, {}),
        queryParameters: {'userId': 1, 'petId': 1},
      );

      await expectLater(api.requestAdoptionForm(1, 1), completes);
    });

    test('lanza excepción cuando el backend responde 404', () async {
      dioAdapter.onPost(
        '/adoption-form/send',
        (server) => server.reply(404, {'message': 'Usuario o mascota no encontrados'}),
        queryParameters: {'userId': 99, 'petId': 99},
      );

      expect(() => api.requestAdoptionForm(99, 99), throwsException);
    });
  });

  group('submitAdoptionForm', () {
    final formData = {'name': 'Ana', 'address': 'Calle Mayor 1'};
    const token = 'abc-token-xyz';

    test('completa sin error cuando el backend responde 200', () async {
      dioAdapter.onPost(
        '/adoption-form/submit/$token',
        (server) => server.reply(200, {}),
        data: formData,
      );

      await expectLater(api.submitAdoptionForm(formData, token), completes);
    });

    test('lanza excepción cuando el token es inválido (401)', () async {
      dioAdapter.onPost(
        '/adoption-form/submit/token-malo',
        (server) => server.reply(401, {'message': 'Token expirado'}),
        data: formData,
      );

      expect(
        () => api.submitAdoptionForm(formData, 'token-malo'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Token expirado'),
          ),
        ),
      );
    });
  });

  //  _extractApiErrorMessage con errors[] 

  group('_extractApiErrorMessage — lista de errores', () {
    test('muestra todos los errores concatenados en el mensaje de la excepción', () async {
      dioAdapter.onPost(
        '/pets',
        (server) => server.reply(422, {
          'errors': ['El nombre es obligatorio', 'La especie no es válida'],
        }),
        data: _pet.toJson(),
      );

      expect(
        () => api.addPet(_pet),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'errors',
            allOf(
              contains('El nombre es obligatorio'),
              contains('La especie no es válida'),
            ),
          ),
        ),
      );
    });
  });
}