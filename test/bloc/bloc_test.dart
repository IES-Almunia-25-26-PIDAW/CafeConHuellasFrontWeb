
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
          species: Species.perro,
          breed: '',
          age: 1,
          adopted: false,
          imageUrl: '',
          description: '',
          emergency: true,
        ),
        Pet(
          id: 2,
          name: 'Cat',
          species: Species.gato,
          breed: '',
          age: 1,
          adopted: false,
          imageUrl: '',
          description: '',
          emergency: false,
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
}