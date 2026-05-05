// test/screens/relationships_test.dart
import 'package:cafeconhuellas_front/models/adoptionForm.dart';
import 'package:cafeconhuellas_front/models/user.dart';
import 'package:cafeconhuellas_front/models/userPetRelationship.dart';
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

AuthState get _unauthState => AuthState(isLoading: false);

AuthState get _userState => AuthState(
  token: 'tok', isLoading: false,
  user: UserWithoutPassword(
    id: 1, firstName: 'Ana', lastName1: '', lastName2: '',
    email: '', phone: '', role: 'USER', imageUrl: '',
  ),
);

AuthState get _adminState => AuthState(
  token: 'tok', isLoading: false,
  user: UserWithoutPassword(
    id: 2, firstName: 'Admin', lastName1: '', lastName2: '',
    email: '', phone: '', role: 'ADMIN', imageUrl: '',
  ),
);

PetsState emptyPetsState() => PetsState(
  pets: const [], selectedSpecies: '', isEmergencyActive: false,
  isLoading: false, events: const [],
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
  tester.view.physicalSize = const Size(1400, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(widget);
  await tester.pumpAndSettle();
}

void main() {
  group('RelationshipsScreen — sin autenticar', () {
    testWidgets('muestra pantalla de login si no está autenticado', (tester) async {
      await pumpBig(tester, buildWidget(_unauthState, emptyPetsState()));
      expect(find.text('¡Necesitas iniciar sesión!'), findsOneWidget);
    });

    testWidgets('muestra botón de iniciar sesión', (tester) async {
      await pumpBig(tester, buildWidget(_unauthState, emptyPetsState()));
      expect(find.text('Iniciar sesión'), findsOneWidget);
    });

    testWidgets('tap en iniciar sesión navega a /login', (tester) async {
      await pumpBig(tester, buildWidget(_unauthState, emptyPetsState()));
      await tester.tap(find.text('Iniciar sesión'));
      await tester.pumpAndSettle();
      expect(find.text('login'), findsOneWidget);
    });
  });

  group('RelationshipsScreen — usuario autenticado', () {
    testWidgets('muestra título Mis Peticiones', (tester) async {
      await pumpBig(tester, buildWidget(_userState, emptyPetsState()));
      expect(find.text('Mis Peticiones'), findsOneWidget);
    });

    testWidgets('muestra las dos pestañas', (tester) async {
      await pumpBig(tester, buildWidget(_userState, emptyPetsState()));
      expect(find.text('Relaciones'), findsOneWidget);
      expect(find.text('Solicitudes de adopción'), findsOneWidget);
    });

    testWidgets('muestra mensaje vacío en pestaña relaciones', (tester) async {
      await pumpBig(tester, buildWidget(_userState, emptyPetsState()));
      expect(find.text('No hay relaciones registradas.'), findsOneWidget);
    });

    testWidgets('muestra relación cuando hay datos', (tester) async {
      final relation = Userpetrelationship(
        id: 1, userId: 1, petId: 1,
        relationshipType: 'ACOGIDA',
        startDate: DateTime(2024, 1, 1),
        endDate: null, active: true,
      );
      final state = emptyPetsState().copyWith(relations: [relation]);
      await pumpBig(tester, buildWidget(_userState, state));
      expect(find.text('ACOGIDA'), findsOneWidget);
    });

    testWidgets('pestaña adopciones muestra mensaje vacío', (tester) async {
      await pumpBig(tester, buildWidget(_userState, emptyPetsState()));
      await tester.tap(find.text('Solicitudes de adopción'));
      await tester.pumpAndSettle();
      expect(find.text('No hay solicitudes de adopción.'), findsOneWidget);
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
        agreesToFollowUp: false, submittedAt: DateTime(2024, 6, 1), formTokenId: 1, userEmail: '', additionalInfo: '', relationshipId: 1,
      );
      final state = emptyPetsState().copyWith(adoptionRequests: [request]);
      await pumpBig(tester, buildWidget(_userState, state));
      await tester.tap(find.text('Solicitudes de adopción'));
      await tester.pumpAndSettle();
      expect(find.text('Firulais'), findsOneWidget);
      expect(find.text('PENDIENTE'), findsOneWidget);
    });
  });

  group('RelationshipsScreen — admin', () {
    testWidgets('muestra título Gestionar Peticiones', (tester) async {
      await pumpBig(tester, buildWidget(_adminState, emptyPetsState()));
      expect(find.text('Gestionar Peticiones'), findsOneWidget);
    });

    testWidgets('admin ve switch en tarjeta de relación', (tester) async {
      final relation = Userpetrelationship(
        id: 1, userId: 1, petId: 1,
        relationshipType: 'ACOGIDA',
        startDate: DateTime(2024, 1, 1),
        endDate: null, active: true,
      );
      final state = emptyPetsState().copyWith(relations: [relation]);
      await pumpBig(tester, buildWidget(_adminState, state));
      expect(find.byType(Switch), findsOneWidget);
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
        agreesToFollowUp: false, submittedAt: DateTime(2024, 6, 1), formTokenId: 1, userEmail: '', additionalInfo: '', relationshipId: 1,
      );
      final state = emptyPetsState().copyWith(adoptionRequests: [request]);
      await pumpBig(tester, buildWidget(_adminState, state));
      await tester.tap(find.text('Solicitudes de adopción'));
      await tester.pumpAndSettle();
      expect(find.text('Aprobar'), findsOneWidget);
      expect(find.text('Rechazar'), findsOneWidget);
    });
  });
}