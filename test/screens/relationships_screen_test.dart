/// test/screens/relationships_test.dart
library;
import 'package:cafeconhuellas_front/models/adoption_form.dart';
import 'package:cafeconhuellas_front/models/user.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_state.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_state.dart';
import 'package:cafeconhuellas_front/presentation/screens/relationships_screen.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockApi extends Mock implements ApiConector {}

class FakeAuthBloc extends AuthBloc {
  final AuthState _s;
  FakeAuthBloc(this._s) : super(MockApi());
  @override AuthState get state => _s;
}

class FakePetsBloc extends PetsBloc {
  final PetsState _s;
  FakePetsBloc(this._s) : super(api: MockApi());
  @override PetsState get state => _s;
}

AuthState get _unauthState => AuthState();

AuthState get _userState => AuthState(
  token: 'tok',
  user: UserWithoutPassword(
    id: 1, firstName: 'Ana', lastName1: '', lastName2: '',
    email: '', phone: '', role: 'USER', imageUrl: '',
  ),
);

AuthState get _adminState => AuthState(
  token: 'tok',
  user: UserWithoutPassword(
    id: 2, firstName: 'Admin', lastName1: '', lastName2: '',
    email: '', phone: '', role: 'ADMIN', imageUrl: '',
  ),
);

PetsState emptyPetsState() => PetsState(
  pets: const [], selectedSpecies: '', isEmergencyActive: false, events: const [],
  relations: const [], adoptionRequests: const [],
);

Widget buildWidget(AuthState authState, PetsState petsState) =>
    MaterialApp.router(
      routerConfig: GoRouter(routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(create: (_) => FakeAuthBloc(authState)),
              BlocProvider<PetsBloc>(create: (_) => FakePetsBloc(petsState)),
            ],
            child: const RelationshipsScreen(),
          ),
        ),
        GoRoute(
          path: '/login',
          builder: (_, _) => const Scaffold(body: Text('login')),
        ),
      ]),
    );

Future<void> pumpBig(WidgetTester tester, Widget widget) async {
  tester.view.physicalSize = const Size(1400, 2400); // ← más altura
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(widget);
  await tester.pump(); // primer frame
  await tester.pump(const Duration(milliseconds: 300)); // espera animaciones tab
  await tester.pumpAndSettle();
}

void main() {
  group('RelationshipsScreen — sin autenticar', () {
    testWidgets('muestra pantalla de login si no está autenticado', (tester) async {
      await pumpBig(tester, buildWidget(_unauthState, emptyPetsState()));
      expect(find.text('You need to log in!'), findsOneWidget);
    });

    testWidgets('muestra botón de iniciar sesión', (tester) async {
      await pumpBig(tester, buildWidget(_unauthState, emptyPetsState()));
      expect(find.text('Sign in or register to view your requests.'), findsOneWidget);
    });
    ///  Tap en el botón real
    testWidgets('tap en Login navega a /login', (tester) async {
      await pumpBig(tester, buildWidget(_unauthState, emptyPetsState()));
      await tester.tap(find.text('Login')); // ← el ElevatedButton
      await tester.pumpAndSettle();
      expect(find.text('login'), findsOneWidget);
    });
  });

  group('RelationshipsScreen — usuario autenticado', () {
    testWidgets('muestra título Mis Peticiones', (tester) async {
      await pumpBig(tester, buildWidget(_userState, emptyPetsState()));
      expect(find.text('My Requests'), findsOneWidget);
    });

    testWidgets('muestra las dos pestañas', (tester) async {
      await pumpBig(tester, buildWidget(_userState, emptyPetsState()));
      expect(find.text('Relationships'), findsOneWidget);
      expect(find.text('Adoption Requests'), findsOneWidget);
    });

   /// Este test abre la pestaña "Solicitudes de adopción" pero busca texto de RELACIONES
   testWidgets('pestaña adopciones muestra mensaje vacío', (tester) async {
    await pumpBig(tester, buildWidget(_userState, emptyPetsState())); // ← faltaba esto
    await tester.tap(find.text('Adoption Requests'));
    await tester.pumpAndSettle();
    expect(find.text('No adoption requests found.'), findsOneWidget);
  });

    testWidgets('pestaña adopciones muestra solicitud cuando hay datos', (tester) async {
      final request = AdoptionRequest(
        id: 1,
        status: 'PENDIENTE', 
        petName: 'Firulais', userName: 'Admin',
        city: 'Sevilla', address: 'Calle Test 1',
        housingType: 'Piso', hoursAlonePerDay: 4,
        reasonForAdoption: 'Test',
        hasGarden: false, hasOtherPets: false,
        hasChildren: false, experienceWithPets: false,
        agreesToFollowUp: false, submittedAt: DateTime(2024, 6), formTokenId: 1, userEmail: '', additionalInfo: '', relationshipId: 1,
      );
      final state = emptyPetsState().copyWith(adoptionRequests: [request]);
      await pumpBig(tester, buildWidget(_userState, state));
      await tester.tap(find.text('Adoption Requests'));
      await tester.pumpAndSettle();
      expect(find.text('Firulais'), findsOneWidget);
      expect(find.text('PENDIENTE'), findsOneWidget);
    });
  });

  group('RelationshipsScreen — admin', () {
    testWidgets('muestra título Gestionar Peticiones', (tester) async {
      await pumpBig(tester, buildWidget(_adminState, emptyPetsState()));
      expect(find.text('Manage Requests'), findsOneWidget);
    });

  
    testWidgets('admin ve botones aprobar y rechazar en solicitudes', (tester) async {
      final request = AdoptionRequest(
        id: 1,
        status: 'PENDIENTE', 
        petName: 'Firulais', userName: 'Admin',
        city: 'Sevilla', address: 'Calle Test 1',
        housingType: 'Piso', hoursAlonePerDay: 4,
        reasonForAdoption: 'Test',
        hasGarden: false, hasOtherPets: false,
        hasChildren: false, experienceWithPets: false,
        agreesToFollowUp: false, submittedAt: DateTime(2024, 6), formTokenId: 1, userEmail: '', additionalInfo: '', relationshipId: 1,
      );
      final state = emptyPetsState().copyWith(adoptionRequests: [request]);
      await pumpBig(tester, buildWidget(_adminState, state));
      await tester.tap(find.text('Adoption Requests'));
      await tester.pumpAndSettle();
      expect(find.text('Approve'), findsOneWidget);
      expect(find.text('Reject'), findsOneWidget);
    });
  });
}