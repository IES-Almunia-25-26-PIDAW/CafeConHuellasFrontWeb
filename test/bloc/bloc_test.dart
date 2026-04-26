
import 'package:cafeconhuellas_front/models/event.dart';
import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/models/user.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_event.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_state.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_event.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_state.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// necesitamos un mock para que intercepte la conexión con la api y haga una api falsa
// donde nosotros decidimos que devuelve
class MockApi extends Mock implements ApiConector {}

void main() {
  group('AuthBloc', () {
    test('emite loading y luego success cuando login va bien', () async {
      // construcción del bloc que vamos a testear
      final mockApi = MockApi();
      
      // hemos decidido que nos devuelva un token
      when(() => mockApi.login(any(), any()))
          .thenAnswer((_) async => {'token': '123'});
      // gracias al token podemos ahora llamar al getme
      // que nos devolverá un usuario llamado juan
      when(() => mockApi.getMe()).thenAnswer(
        (_) async => UserWithoutPassword(
          id: 1,
          firstName: 'Juan',
          lastName1: '',
          lastName2: '',
          email: '',
          phone: '',
          role: '',
          imageUrl: '',
        ),
      );

      final bloc = AuthBloc(mockApi);
      // que hacemos en el test
      bloc.add(LoginSubmitted('a', 'b'));
      // que esperamos en el test, que el token sea 123
      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<AuthState>().having((s) => s.isLoading, 'loading', true),
          isA<AuthState>().having((s) => s.token, 'token', '123'),
        ]),
      );
      await bloc.close();
    });
  });

group('PetsBloc', () {
  test('filtra por especie perro', () async {
    // construcción del bloc q vamos a testear
    final mockApi = MockApi();
    when(() => mockApi.getPets()).thenAnswer(
      (_) async => [
        Pet(
          id: 1,
          name: 'Dog',
          breed: '',
          category: 'Perro',
          age: 1,
          adopted: false,
          imageUrl: '',
          description: '',
          urgentAdoption: true,
        ),
        Pet(
          id: 2,
          name: 'Cat',
          breed: '',
          category: 'Gato',
          age: 1,
          adopted: false,
          imageUrl: '',
          description: '',
          urgentAdoption: false,
        ),
      ],
    );

    final bloc = PetsBloc(api: mockApi);

    // nos suscribimos ANTES de añadir eventos para no perdernos ningún estado
    final future = expectLater(
      bloc.stream,
      emitsInOrder([
        // loading
        isA<PetsState>().having((s) => s.isLoading, 'loading', true),
        // loaded, espera que haya 2 animales
        isA<PetsState>().having((s) => s.pets.length, 'pets', 2),
        // filtrado, espera que cuando filtremos por perro haya 1
        isA<PetsState>()
            .having((s) => s.selectedSpecies, 'species', 'Perro')
            .having((s) => s.pets.length, 'filtered pets', 1),
      ]),
    );

    // que hacemos en el bloc, DESPUÉS de suscribirnos
    bloc.add(LoadPets());
    await bloc.stream.firstWhere(
      (state) => !state.isLoading && state.pets.isNotEmpty,
    );
    bloc.add(FilterSpecies('Perro'));

    // esperamos a que se cumplan todas las expectativas
    await future;
    await bloc.close();
  });
});
// casos adicionales de petsbloc

group('PetsBloc — casos adicionales', () {
  late MockApi mockApi;
  late PetsBloc bloc;

  final perro = Pet(
    id: 1, name: 'Dog', category: 'Perro',
    breed: '', age: 1, adopted: false,
    imageUrl: '', description: '', urgentAdoption: true,
  );
  final gato = Pet(
    id: 2, name: 'Cat', category: 'Gato',
    breed: '', age: 1, adopted: false,
    imageUrl: '', description: '', urgentAdoption: false,
  );

  setUp(() {
    mockApi = MockApi();
    bloc = PetsBloc(api: mockApi);
  });

  tearDown(() => bloc.close());

  // Error al cargar mascotas 
  test('emite error cuando getPets lanza excepción', () async {
    when(() => mockApi.getPets()).thenThrow(Exception('sin red'));

    final future = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<PetsState>().having((s) => s.isLoading, 'loading', true),
        isA<PetsState>()
            .having((s) => s.isLoading, 'loading', false)
            .having((s) => s.pets, 'pets', isEmpty)
            .having((s) => s.errorMessage, 'error', isNotNull),
      ]),
    );

    bloc.add(LoadPets());
    await future;
  });

  // Filtro por gato 
  test('filtra por especie gato', () async {
    when(() => mockApi.getPets()).thenAnswer((_) async => [perro, gato]);

    bloc.add(LoadPets());
    await bloc.stream.firstWhere((s) => !s.isLoading && s.pets.isNotEmpty);

    final future = expectLater(
      bloc.stream,
      emits(
        isA<PetsState>()
            .having((s) => s.selectedSpecies, 'species', 'Gato')
            .having((s) => s.pets.length, 'length', 1)
            .having((s) => s.pets.first.category, 'category', 'Gato'),
      ),
    );

    bloc.add(FilterSpecies('Gato'));
    await future;
  });

  //  Filtro vacío (sin especie) 
  test('sin filtro de especie muestra todos', () async {
    when(() => mockApi.getPets()).thenAnswer((_) async => [perro, gato]);

    bloc.add(LoadPets());
    await bloc.stream.firstWhere((s) => !s.isLoading && s.pets.isNotEmpty);
    bloc.add(FilterSpecies('Perro'));
    await bloc.stream.firstWhere((s) => s.selectedSpecies == 'Perro');

    final future = expectLater(
      bloc.stream,
      emits(
        isA<PetsState>()
            .having((s) => s.pets.length, 'all pets', 2),
      ),
    );

    bloc.add(FilterSpecies(''));
    await future;
  });

  //  Toggle emergency
  test('toggle emergency filtra solo mascotas urgentes', () async {
    when(() => mockApi.getPets()).thenAnswer((_) async => [perro, gato]);

    bloc.add(LoadPets());
    await bloc.stream.firstWhere((s) => !s.isLoading && s.pets.isNotEmpty);

    final future = expectLater(
      bloc.stream,
      emitsInOrder([
        // ON: solo el perro (emergency: true)
        isA<PetsState>()
            .having((s) => s.isEmergencyActive, 'emergency', true)
            .having((s) => s.pets.length, 'filtered', 1),
        // OFF: vuelven los dos
        isA<PetsState>()
            .having((s) => s.isEmergencyActive, 'emergency', false)
            .having((s) => s.pets.length, 'all', 2),
      ]),
    );

    bloc.add(ToggleEmergency());
    await bloc.stream.firstWhere((s) => s.isEmergencyActive);
    bloc.add(ToggleEmergency());
    await future;
  });

  // LoadEvents éxito 
  test('LoadEvents emite los eventos cargados', () async {
    final evento = Event(id: 1, description: '', date: DateTime.now (), name: '', imageUrl: '',);
    when(() => mockApi.getEvents()).thenAnswer((_) async => [evento]);

    final future = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<PetsState>().having((s) => s.isLoading, 'loading', true),
        isA<PetsState>()
            .having((s) => s.events.length, 'events', 1)
            .having((s) => s.isLoading, 'loading', false),
      ]),
    );

    bloc.add(LoadEvents());
    await future;
  });

  // LoadEvents error 
  test('LoadEvents emite error cuando la API falla', () async {
    when(() => mockApi.getEvents()).thenThrow(Exception('timeout'));

    final future = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<PetsState>().having((s) => s.isLoading, 'loading', true),
        isA<PetsState>()
            .having((s) => s.events, 'events', isEmpty)
            .having((s) => s.errorMessage, 'error', isNotNull),
      ]),
    );

    bloc.add(LoadEvents());
    await future;
  });
});

//AUTH BLOC casos adicionales

group('AuthBloc — casos adicionales', () {
  late MockApi mockApi;
  late AuthBloc bloc;

  setUp(() {
    mockApi = MockApi();
    bloc = AuthBloc(mockApi);
  });

  tearDown(() => bloc.close());

  // Estado inicial 
  test('estado inicial es correcto', () {
    expect(bloc.state.isLoading, false);
    expect(bloc.state.token, isNull);
    expect(bloc.state.errorMessage, isNull);
  });

  //  Login fallido 
  test('emite error cuando el login lanza excepción', () async {
    when(() => mockApi.login(any(), any()))
        .thenThrow(Exception('credenciales incorrectas'));

    final future = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<AuthState>().having((s) => s.isLoading, 'loading', true),
        isA<AuthState>()
            .having((s) => s.isLoading, 'loading', false)
            .having((s) => s.errorMessage, 'error', isNotNull)
            .having((s) => s.token, 'token', isNull),
      ]),
    );

    bloc.add(LoginSubmitted('mal@email.com', 'wrongpass'));
    await future;
  });

  //  Token vacío 
  test('emite error cuando la API devuelve token vacío', () async {
    when(() => mockApi.login(any(), any()))
        .thenAnswer((_) async => {'token': ''});

    final future = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<AuthState>().having((s) => s.isLoading, 'loading', true),
        isA<AuthState>()
            .having((s) => s.isLoading, 'loading', false)
            .having((s) => s.errorMessage, 'error', isNotNull),
      ]),
    );

    bloc.add(LoginSubmitted('andreita@gmail.com', '123'));
    await future;
  });

  // getMe falla tras login OK 
  test('login OK aunque getMe falle — guarda el token igualmente', () async {
    when(() => mockApi.login(any(), any()))
        .thenAnswer((_) async => {'token': 'abc'});
    when(() => mockApi.getMe()).thenThrow(Exception('parse error'));

    final future = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<AuthState>().having((s) => s.isLoading, 'loading', true),
        isA<AuthState>()
            .having((s) => s.token, 'token', 'abc')
            .having((s) => s.user, 'user', isNull),
      ]),
    );

    bloc.add(LoginSubmitted('andreita@gmail.com', '123'));
    await future;
  });

  //  Logout 
  test('LogoutRequested resetea el estado completamente', () async {
    when(() => mockApi.login(any(), any()))
        .thenAnswer((_) async => {'token': 'abc'});
    when(() => mockApi.getMe()).thenAnswer(
      (_) async => UserWithoutPassword(
        id: 1, firstName: 'Andrea', lastName1: '',
        lastName2: '', email: '', phone: '',
        role: '', imageUrl: '',
      ),
    );

    bloc.add(LoginSubmitted('andreita@gmail.com', '123'));
    await bloc.stream.firstWhere((s) => s.token != null);

    final future = expectLater(
      bloc.stream,
      emits(
        isA<AuthState>()
            .having((s) => s.token, 'token', isNull)
            .having((s) => s.user, 'user', isNull),
      ),
    );

    bloc.add(LogoutRequested());
    await future;
  });
});
}
