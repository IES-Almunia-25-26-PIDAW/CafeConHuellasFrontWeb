import 'package:cafeconhuellas_front/models/adoptionForm.dart';
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

class MockApi extends Mock implements ApiConector {}

void main() {
  setUpAll(() {
    registerFallbackValue(Pet(
      id: 0, name: '', breed: '', category: '', age: 0,
      imageUrl: '', description: '', urgentAdoption: false, adoptionStatus: '',
    ));
    registerFallbackValue(Event(
      id: 0, name: '', description: '', imageUrl: '', date: DateTime(2000),
    ));
    registerFallbackValue(AdoptionRequest(
        id: 1,status: 'PENDIENTE', userName: '', userEmail: '', petName: '', address: '', city: '', housingType: '', hasGarden: false, hasOtherPets: false, hasChildren: false, hoursAlonePerDay: 5, experienceWithPets: true, reasonForAdoption: '', agreesToFollowUp: false, additionalInfo: '', relationshipId: 0, submittedAt: DateTime.now(), formTokenId: 2,
    ));
  });

  // ── AuthBloc básico ──────────────────────────────────────────────
  group('AuthBloc', () {
    test('emite loading y luego success cuando login va bien', () async {
      final mockApi = MockApi();
      when(() => mockApi.login(any(), any()))
          .thenAnswer((_) async => {'token': '123'});
      when(() => mockApi.getMe()).thenAnswer(
        (_) async => UserWithoutPassword(
          id: 1, firstName: 'Juan', lastName1: '', lastName2: '',
          email: '', phone: '', role: '', imageUrl: '',
        ),
      );

      final bloc = AuthBloc(mockApi);
      bloc.add(LoginSubmitted('a', 'b'));
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

  // ── PetsBloc básico ──────────────────────────────────────────────
  group('PetsBloc', () {
    test('filtra por especie perro', () async {
      final mockApi = MockApi();
      when(() => mockApi.getPets()).thenAnswer((_) async => [
        Pet(id: 1, name: 'Dog', breed: '', category: 'Perro', age: 1,
            imageUrl: '', description: '', urgentAdoption: true, adoptionStatus: ''),
        Pet(id: 2, name: 'Cat', breed: '', category: 'Gato', age: 1,
            imageUrl: '', description: '', urgentAdoption: false, adoptionStatus: ''),
      ]);

      final bloc = PetsBloc(api: mockApi);
      final future = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<PetsState>().having((s) => s.isLoading, 'loading', true),
          isA<PetsState>().having((s) => s.pets.length, 'pets', 2),
          isA<PetsState>()
              .having((s) => s.selectedSpecies, 'species', 'Perro')
              .having((s) => s.pets.length, 'filtered pets', 1),
        ]),
      );
      bloc.add(LoadPets());
      await bloc.stream.firstWhere((s) => !s.isLoading && s.pets.isNotEmpty);
      bloc.add(FilterSpecies('Perro'));
      await future;
      await bloc.close();
    });
  });

  //  PetsBloc adicionales 
  group('PetsBloc — casos adicionales', () {
    late MockApi mockApi;
    late PetsBloc bloc;

    final perro = Pet(id: 1, name: 'Dog', category: 'Perro', breed: '',
        age: 1, imageUrl: '', description: '', urgentAdoption: true, adoptionStatus: '');
    final gato = Pet(id: 2, name: 'Cat', category: 'Gato', breed: '',
        age: 1, imageUrl: '', description: '', urgentAdoption: false, adoptionStatus: '');

    setUp(() {
      mockApi = MockApi();
      bloc = PetsBloc(api: mockApi);
    });
    tearDown(() => bloc.close());

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

    test('filtra por especie gato', () async {
      when(() => mockApi.getPets()).thenAnswer((_) async => [perro, gato]);
      bloc.add(LoadPets());
      await bloc.stream.firstWhere((s) => !s.isLoading && s.pets.isNotEmpty);
      final future = expectLater(
        bloc.stream,
        emits(isA<PetsState>()
            .having((s) => s.selectedSpecies, 'species', 'Gato')
            .having((s) => s.pets.length, 'length', 1)
            .having((s) => s.pets.first.category, 'category', 'Gato')),
      );
      bloc.add(FilterSpecies('Gato'));
      await future;
    });

    test('sin filtro de especie muestra todos', () async {
      when(() => mockApi.getPets()).thenAnswer((_) async => [perro, gato]);
      bloc.add(LoadPets());
      await bloc.stream.firstWhere((s) => !s.isLoading && s.pets.isNotEmpty);
      bloc.add(FilterSpecies('Perro'));
      await bloc.stream.firstWhere((s) => s.selectedSpecies == 'Perro');
      final future = expectLater(
        bloc.stream,
        emits(isA<PetsState>().having((s) => s.pets.length, 'all pets', 2)),
      );
      bloc.add(FilterSpecies(''));
      await future;
    });

    test('toggle emergency filtra solo mascotas urgentes', () async {
      when(() => mockApi.getPets()).thenAnswer((_) async => [perro, gato]);
      bloc.add(LoadPets());
      await bloc.stream.firstWhere((s) => !s.isLoading && s.pets.isNotEmpty);
      final future = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<PetsState>()
              .having((s) => s.isEmergencyActive, 'emergency', true)
              .having((s) => s.pets.length, 'filtered', 1),
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

    test('LoadEvents emite los eventos cargados', () async {
      final evento = Event(id: 1, description: '', date: DateTime.now(),
          name: '', imageUrl: '');
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

    test('filtrar por especie inexistente devuelve lista vacía', () async {
      when(() => mockApi.getPets()).thenAnswer((_) async => [perro, gato]);
      bloc.add(LoadPets());
      await bloc.stream.firstWhere((s) => !s.isLoading && s.pets.isNotEmpty);
      final future = expectLater(
        bloc.stream,
        emits(isA<PetsState>().having((s) => s.pets, 'pets', isEmpty)),
      );
      bloc.add(FilterSpecies('Pez'));
      await future;
    });

    test('emergency Y especie activos a la vez filtran correctamente', () async {
      when(() => mockApi.getPets()).thenAnswer((_) async => [perro, gato]);
      bloc.add(LoadPets());
      await bloc.stream.firstWhere((s) => !s.isLoading && s.pets.isNotEmpty);
      bloc.add(FilterSpecies('Perro'));
      await bloc.stream.firstWhere((s) => s.selectedSpecies == 'Perro');
      final future = expectLater(
        bloc.stream,
        emits(isA<PetsState>()
            .having((s) => s.isEmergencyActive, 'emergency', true)
            .having((s) => s.pets.length, 'solo perro urgente', 1)
            .having((s) => s.pets.first.name, 'nombre', 'Dog')),
      );
      bloc.add(ToggleEmergency());
      await future;
    });

    test('AddPet recarga la lista tras añadir', () async {
      final nuevo = Pet(id: 3, name: 'Bunny', category: 'Conejo', breed: '',
          age: 2, imageUrl: '', description: '', urgentAdoption: false, adoptionStatus: '');
      var call = 0;
      when(() => mockApi.getPets()).thenAnswer((_) async {
        call++;
        return call == 1 ? [perro, gato] : [perro, gato, nuevo];
      });
      when(() => mockApi.addPet(any())).thenAnswer((_) async {});

      bloc.add(LoadPets());
      await bloc.stream.firstWhere((s) => !s.isLoading && s.pets.length == 2);
      final future = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<PetsState>().having((s) => s.isLoading, 'loading', true),
          isA<PetsState>().having((s) => s.pets.length, 'tras add', 3),
        ]),
      );
      bloc.add(AddPet(nuevo));
      await future;
    });

    test('DeletePet elimina la mascota correcta', () async {
      when(() => mockApi.getPets()).thenAnswer((_) async => [perro, gato]);
      when(() => mockApi.deletePet(any())).thenAnswer((_) async {});

      bloc.add(LoadPets());
      await bloc.stream.firstWhere((s) => !s.isLoading && s.pets.length == 2);
      final future = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<PetsState>().having((s) => s.isLoading, 'loading', true),
          isA<PetsState>()
              .having((s) => s.pets.length, 'queda uno', 1)
              .having((s) => s.pets.first.id, 'el que queda', 2),
        ]),
      );
      bloc.add(DeletePet(1));
      await future;
    });

    test('UpdatePet actualiza la mascota en la lista local', () async {
      when(() => mockApi.getPets()).thenAnswer((_) async => [perro, gato]);
      when(() => mockApi.updatePet(any())).thenAnswer((_) async {});

      bloc.add(LoadPets());
      await bloc.stream.firstWhere((s) => !s.isLoading && s.pets.isNotEmpty);
      final perroEditado = perro.copyWith(name: 'DogEdited');
      final future = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<PetsState>().having((s) => s.isLoading, 'loading', true),
          isA<PetsState>().having(
            (s) => s.pets.firstWhere((p) => p.id == 1).name,
            'nombre actualizado', 'DogEdited',
          ),
        ]),
      );
      bloc.add(UpdatePet(perroEditado));
      await future;
    });

    test('LoadAdoptionRequests carga solicitudes correctamente', () async {
      final request = AdoptionRequest(
        id: 1,status: 'PENDIENTE', userName: '', userEmail: '', petName: '', address: '', city: '', housingType: '', hasGarden: false, hasOtherPets: false, hasChildren: false, hoursAlonePerDay: 5, experienceWithPets: true, reasonForAdoption: '', agreesToFollowUp: false, additionalInfo: '', relationshipId: 0, submittedAt: DateTime.now(), formTokenId: 2,
      );
      when(() => mockApi.getAdoptionRequest()).thenAnswer((_) async => [request]);
      final future = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<PetsState>().having((s) => s.isLoading, 'loading', true),
          isA<PetsState>()
              .having((s) => s.adoptionRequests.length, 'requests', 1)
              .having((s) => s.isLoading, 'loading', false),
        ]),
      );
      bloc.add(LoadAdoptionRequests());
      await future;
    });

    test('LoadAdoptionRequests emite error cuando la API falla', () async {
      when(() => mockApi.getAdoptionRequest()).thenThrow(Exception('sin conexión'));
      final future = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<PetsState>().having((s) => s.isLoading, 'loading', true),
          isA<PetsState>()
              .having((s) => s.isLoading, 'loading', false)
              .having((s) => s.errorMessage, 'error', isNotNull),
        ]),
      );
      bloc.add(LoadAdoptionRequests());
      await future;
    });
  });

  // AuthBloc adicionales 
  group('AuthBloc — casos adicionales', () {
    late MockApi mockApi;
    late AuthBloc bloc;

    setUp(() {
      mockApi = MockApi();
      bloc = AuthBloc(mockApi);
    });
    tearDown(() => bloc.close());

    test('estado inicial es correcto', () {
      expect(bloc.state.isLoading, false);
      expect(bloc.state.token, isNull);
      expect(bloc.state.errorMessage, isNull);
    });

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

    test('LogoutRequested resetea el estado completamente', () async {
      when(() => mockApi.login(any(), any()))
          .thenAnswer((_) async => {'token': 'abc'});
      when(() => mockApi.getMe()).thenAnswer(
        (_) async => UserWithoutPassword(
          id: 1, firstName: 'Andrea', lastName1: '', lastName2: '',
          email: '', phone: '', role: '', imageUrl: '',
        ),
      );
      bloc.add(LoginSubmitted('andreita@gmail.com', '123'));
      await bloc.stream.firstWhere((s) => s.token != null);
      final future = expectLater(
        bloc.stream,
        emits(isA<AuthState>()
            .having((s) => s.token, 'token', isNull)
            .having((s) => s.user, 'user', isNull)),
      );
      bloc.add(LogoutRequested());
      await future;
    });

    test('isAuthenticated es true cuando hay token y user', () async {
      when(() => mockApi.login(any(), any()))
          .thenAnswer((_) async => {'token': 'xyz'});
      when(() => mockApi.getMe()).thenAnswer(
        (_) async => UserWithoutPassword(
          id: 5, firstName: 'Maria', lastName1: 'García', lastName2: '',
          email: 'maria@test.com', phone: '', role: 'USER', imageUrl: '',
        ),
      );
      bloc.add(LoginSubmitted('maria@test.com', '1234'));
      await bloc.stream.firstWhere((s) => s.user != null);
      expect(bloc.state.isAuthenticated, true);
      expect(bloc.state.token, 'xyz');
      expect(bloc.state.user?.firstName, 'Maria');
    });

    test('isAuthenticated es false en estado inicial', () {
      expect(bloc.state.isAuthenticated, false);
      expect(bloc.state.token, isNull);
    });

    test('el role del usuario se guarda correctamente tras login', () async {
      when(() => mockApi.login(any(), any()))
          .thenAnswer((_) async => {'token': 'admintoken'});
      when(() => mockApi.getMe()).thenAnswer(
        (_) async => UserWithoutPassword(
          id: 10, firstName: 'Admin', lastName1: '', lastName2: '',
          email: 'admin@test.com', phone: '', role: 'ADMIN', imageUrl: '',
        ),
      );
      bloc.add(LoginSubmitted('admin@test.com', 'pass'));
      final future = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<AuthState>().having((s) => s.isLoading, 'loading', true),
          isA<AuthState>().having((s) => s.user?.role, 'role', 'ADMIN'),
        ]),
      );
      await future;
    });

    test('logout sin sesión activa no lanza excepción', () async {
      expect(() => bloc.add(LogoutRequested()), returnsNormally);
      final future = expectLater(
        bloc.stream,
        emits(isA<AuthState>()
            .having((s) => s.token, 'token', isNull)
            .having((s) => s.user, 'user', isNull)),
      );
      bloc.add(LogoutRequested());
      await future;
    });
  });

} // ← único cierre de main()