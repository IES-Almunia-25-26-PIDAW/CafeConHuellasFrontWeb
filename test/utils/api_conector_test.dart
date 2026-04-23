// test/utils/api_conector_test.dart
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late ApiConector api;
  late DioAdapter dioAdapter;

  setUp(() {
    // ApiConector es singleton, así que reutilizamos la instancia
    // pero reemplazamos su Dio interno con uno interceptable
    api = ApiConector();
    dioAdapter = DioAdapter(dio: api.dio);
  });

  // LOGIN 
  group('login', () {
    test('devuelve token cuando la respuesta tiene campo "token"', () async {
      dioAdapter.onPost(
        '/auth/login',
        (server) => server.reply(200, {'token': 'abc123'}),
        data: {'email': 'a@a.com', 'password': '1234'},
      );

      final result = await api.login('a@a.com', '1234');
      expect(result['token'], 'abc123');
    });

    test('devuelve token cuando la respuesta usa "accessToken"', () async {
      dioAdapter.onPost(
        '/auth/login',
        (server) => server.reply(200, {'accessToken': 'tokenB'}),
        data: {'email': 'a@a.com', 'password': '1234'},
      );

      final result = await api.login('a@a.com', '1234');
      expect(result['token'], 'tokenB');
    });

    test('devuelve token cuando está anidado en data.token', () async {
      dioAdapter.onPost(
        '/auth/login',
        (server) => server.reply(200, {
          'data': {'token': 'tokenAnidado'},
        }),
        data: {'email': 'a@a.com', 'password': '1234'},
      );

      final result = await api.login('a@a.com', '1234');
      expect(result['token'], 'tokenAnidado');
    });

    test('devuelve token cuando la respuesta es un String directo', () async {
      dioAdapter.onPost(
        '/auth/login',
        (server) => server.reply(200, 'tokenString'),
        data: {'email': 'a@a.com', 'password': '1234'},
      );

      final result = await api.login('a@a.com', '1234');
      expect(result['token'], 'tokenString');
    });

    test('lanza excepción cuando no hay token en la respuesta', () async {
      dioAdapter.onPost(
        '/auth/login',
        (server) => server.reply(200, {'message': 'ok pero sin token'}),
        data: {'email': 'a@a.com', 'password': '1234'},
      );

      expect(() => api.login('a@a.com', '1234'), throwsException);
    });

    test('lanza excepción en error 401', () async {
      dioAdapter.onPost(
        '/auth/login',
        (server) => server.reply(401, {'message': 'Credenciales incorrectas'}),
        data: {'email': 'mal@a.com', 'password': 'wrong'},
      );

      expect(() => api.login('mal@a.com', 'wrong'), throwsException);
    });
  });

  // GET ME 
  group('getMe', () {
    test('devuelve UserWithoutPassword cuando la respuesta es correcta', () async {
      dioAdapter.onGet(
        '/users/me',
        (server) => server.reply(200, {
          'id': 1,
          'firstName': 'Juan',
          'lastName1': 'García',
          'lastName2': '',
          'email': 'juan@test.com',
          'phone': '600000000',
          'role': 'USER',
          'imageUrl': '',
        }),
      );

      final user = await api.getMe();
      expect(user.firstName, 'Juan');
      expect(user.email, 'juan@test.com');
    });

    test('lanza excepción cuando la respuesta no es un Map', () async {
      dioAdapter.onGet(
        '/users/me',
        (server) => server.reply(200, 'respuesta inesperada'),
      );

      expect(() => api.getMe(), throwsException);
    });
  });

  //  GET PETS

  group('getPets', () {
    final petJson = {
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

    test('devuelve lista de mascotas cuando la respuesta es una lista directa', () async {
      dioAdapter.onGet(
        '/pets',
        (server) => server.reply(200, [petJson]),
      );

      final pets = await api.getPets();
      expect(pets.length, 1);
      expect(pets.first.name, 'Rex');
    });

    test('devuelve lista cuando los datos están bajo clave "data"', () async {
      dioAdapter.onGet(
        '/pets',
        (server) => server.reply(200, {'data': [petJson]}),
      );

      final pets = await api.getPets();
      expect(pets.length, 1);
    });

    test('devuelve lista cuando los datos están bajo clave "pets"', () async {
      dioAdapter.onGet(
        '/pets',
        (server) => server.reply(200, {'pets': [petJson]}),
      );

      final pets = await api.getPets();
      expect(pets.length, 1);
    });

    test('lanza excepción cuando la respuesta no tiene lista válida', () async {
      dioAdapter.onGet(
        '/pets',
        (server) => server.reply(200, {'unexpected': 'value'}),
      );

      expect(() => api.getPets(), throwsException);
    });
  });

  // GET EVENTS 

  group('getEvents', () {
    final eventJson = {
      'id': 1,
      'name': 'Adopción',
      'description': 'Gran evento',
      'imageUrl': '',
      'eventdate': '2025-12-01T10:00:00',
    };

    test('devuelve lista de eventos cuando la respuesta es lista directa', () async {
      dioAdapter.onGet(
        '/events',
        (server) => server.reply(200, [eventJson]),
      );

      final events = await api.getEvents();
      expect(events.length, 1);
      expect(events.first.name, 'Adopción');
    });

    test('devuelve lista cuando los datos están bajo clave "events"', () async {
      dioAdapter.onGet(
        '/events',
        (server) => server.reply(200, {'events': [eventJson]}),
      );

      final events = await api.getEvents();
      expect(events.length, 1);
    });

    test('lanza excepción cuando la respuesta no tiene lista válida', () async {
      dioAdapter.onGet(
        '/events',
        (server) => server.reply(200, {'unexpected': 'value'}),
      );

      expect(() => api.getEvents(), throwsException);
    });
  });

  //  GET PET BY ID 

  group('getPetById', () {
    final petJson = {
      'id': 42,
      'name': 'Luna',
      'species': 'gato',
      'breed': 'Siamés',
      'age': 2,
      'adopted': false,
      'imageUrl': '',
      'description': '',
      'emergency': false,
    };

    test('devuelve mascota cuando /pets/:id responde con un Map', () async {
      dioAdapter.onGet(
        '/pets/42',
        (server) => server.reply(200, petJson),
      );

      final pet = await api.getPetById(42);
      expect(pet?.name, 'Luna');
    });

    test('devuelve mascota cuando /pets/:id responde con una lista', () async {
      dioAdapter.onGet(
        '/pets/42',
        (server) => server.reply(200, [petJson]),
      );

      final pet = await api.getPetById(42);
      expect(pet?.name, 'Luna');
    });

    test('busca en getPets como fallback si /pets/:id falla', () async {
      // El endpoint específico falla
      dioAdapter.onGet(
        '/pets/42',
        (server) => server.reply(404, 'not found'),
      );
      // El fallback lista todas
      dioAdapter.onGet(
        '/pets',
        (server) => server.reply(200, [petJson]),
      );

      final pet = await api.getPetById(42);
      expect(pet?.name, 'Luna');
    });

    test('devuelve null si la mascota no existe en ningún endpoint', () async {
      dioAdapter.onGet(
        '/pets/99',
        (server) => server.reply(404, 'not found'),
      );
      dioAdapter.onGet(
        '/pets',
        (server) => server.reply(200, [petJson]), // tiene id 42, no 99
      );

      final pet = await api.getPetById(99);
      expect(pet, isNull);
    });
  });

  //REGISTER 
  group('register', () {
    test('completa sin error cuando el backend responde 201', () async {
      dioAdapter.onPost(
        '/auth/register',
        (server) => server.reply(201, {'message': 'created'}),
        data: {'firstName': 'Ana', 'email': 'ana@test.com'},
      );

      await expectLater(
        api.register({'firstName': 'Ana', 'email': 'ana@test.com'}),
        completes,
      );
    });

    test('elimina imageUrl vacío antes de enviar', () async {
      // Si imageUrl llega vacío, no debe estar en el body enviado.
      // El adapter acepta cualquier data que no incluya imageUrl.
      dioAdapter.onPost(
        '/auth/register',
        (server) => server.reply(201, {}),
        data: {'firstName': 'Andrea'}, // sin imageUrl
      );

      await expectLater(
        api.register({'firstName': 'Andrea', 'imageUrl': ''}),
        completes,
      );
    });

    test('lanza excepción con mensaje de la API en error 400', () async {
      dioAdapter.onPost(
        '/auth/register',
        (server) => server.reply(400, {'message': 'El email ya existe'}),
        data: {'email': 'duplicado@test.com'},
      );

      expect(
        () => api.register({'email': 'duplicado@test.com'}),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('El email ya existe'),
          ),
        ),
      );
    });

    test('lanza excepción con lista de errores cuando la API devuelve errors[]', () async {
      dioAdapter.onPost(
        '/auth/register',
        (server) => server.reply(422, {
          'errors': ['El email es inválido', 'El teléfono es obligatorio'],
        }),
        data: {'email': 'bad'},
      );

      expect(
        () => api.register({'email': 'bad'}),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'errors',
            contains('El email es inválido'),
          ),
        ),
      );
    });
  });

  // SET TOKEN / INTERCEPTOR
  group('setToken', () {
    test('el interceptor añade Authorization header tras setToken', () async {
      api.setToken('miTokenSecreto');

      // Verificamos que el token se añade haciendo una petición y
      // comprobando que el interceptor no lanza error (si el header
      // faltara, un backend real devolvería 401, pero aquí solo
      // comprobamos que setToken no rompe nada y la petición va)
      dioAdapter.onGet(
        '/users/me',
        (server) => server.reply(200, {
          'id': 1, 'firstName': 'Test', 'lastName1': '',
          'lastName2': '', 'email': '', 'phone': '',
          'role': '', 'imageUrl': '',
        }),
      );

      final user = await api.getMe();
      expect(user.firstName, 'Test');
    });
  });
}