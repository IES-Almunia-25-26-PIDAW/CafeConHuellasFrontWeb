// test/screens/help_screen_test.dart
import 'package:cafeconhuellas_front/models/user.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_state.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_state.dart';
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

// estado sin login
AuthState get _unauthState => AuthState(isLoading: false);

// estado con usuario normal
AuthState get _userState => AuthState(
  token: 'tok', isLoading: false,
  user: UserWithoutPassword(
    id: 1, firstName: 'Ana', lastName1: '', lastName2: '',
    email: '', phone: '', role: 'USER', imageUrl: '',
  ),
);

PetsState get _emptyPets => PetsState(
  pets: const [], selectedSpecies: '', isEmergencyActive: false,
  isLoading: false, events: const [],
  relations: const [], adoptionRequests: const [],
);

// buildWidget con GoRouter porque HelpScreen usa context.go('/login')
Widget buildWidget(AuthState authState) => MaterialApp.router(
  routerConfig: GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (_) => FakeAuthBloc(authState)),
          BlocProvider<PetsBloc>(create: (_) => FakePetsBloc(_emptyPets)),
        ],
        child: HelpusScreen(),
      ),
    ),
    GoRoute(
      path: '/login',
      builder: (_, __) => const Scaffold(body: Text('login')),
    ),
  ]),
);

Future<void> pumpBig(WidgetTester tester, Widget widget) async {
  tester.view.physicalSize = const Size(1400, 2400); // alto para ver todo
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(widget);
  await tester.pumpAndSettle();
}

void main() {
  group('HelpScreen — contenido básico', () {
    testWidgets('muestra título principal', (tester) async {
      await pumpBig(tester, buildWidget(_unauthState));
      expect(find.text('¿Cómo puedes ayudar?'), findsOneWidget);
    });

    testWidgets('muestra links de navegación', (tester) async {
      await pumpBig(tester, buildWidget(_unauthState));
      expect(find.text('Voluntariado'), findsWidgets);
      expect(find.text('Casa de acogida'), findsWidgets);
      expect(find.text('Paseos'), findsWidgets);
      expect(find.text('Apadrinamiento'), findsWidgets);
    });

    testWidgets('muestra texto introductorio', (tester) async {
      await pumpBig(tester, buildWidget(_unauthState));
      expect(find.textContaining('formas de colaborar'), findsOneWidget);
    });

    testWidgets('muestra los 4 botones de acción', (tester) async {
      await pumpBig(tester, buildWidget(_unauthState));
      expect(find.text('Quiero ser voluntario'), findsOneWidget);
      expect(find.text('Ofrecer acogida'), findsOneWidget);
      expect(find.text('Apuntarme a paseos'), findsOneWidget);
      expect(find.text('Apadrinar'), findsOneWidget);
    });

    testWidgets('muestra títulos de las secciones', (tester) async {
      await pumpBig(tester, buildWidget(_unauthState));
      expect(find.text('Voluntariado'), findsWidgets);
      expect(find.text('Casa de acogida'), findsWidgets);
      expect(find.text('Paseos'), findsWidgets);
      expect(find.text('Apadrinamiento'), findsWidgets);
    });

    testWidgets('muestra textos descriptivos de cada sección', (tester) async {
      await pumpBig(tester, buildWidget(_unauthState));
      expect(find.textContaining('cuidado diario'), findsOneWidget);
      expect(find.textContaining('hogar temporalmente'), findsOneWidget);
      expect(find.textContaining('saliendo a pasear'), findsOneWidget);
      expect(find.textContaining('económicamente'), findsOneWidget);
    });
  });

  group('HelpScreen — sin autenticar', () {
    testWidgets('botón voluntariado abre dialog de login', (tester) async {
      await pumpBig(tester, buildWidget(_unauthState));

      await tester.ensureVisible(find.text('Quiero ser voluntario'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Quiero ser voluntario'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('¡Necesitas una cuenta!'), findsOneWidget);
    });

    testWidgets('dialog sin login muestra botón iniciar sesión', (tester) async {
      await pumpBig(tester, buildWidget(_unauthState));

      await tester.ensureVisible(find.text('Quiero ser voluntario'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Quiero ser voluntario'));
      await tester.pumpAndSettle();

      expect(find.text('Iniciar sesión / Registrarse'), findsOneWidget);
    });

    testWidgets('dialog sin login muestra botón cancelar', (tester) async {
      await pumpBig(tester, buildWidget(_unauthState));

      await tester.ensureVisible(find.text('Quiero ser voluntario'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Quiero ser voluntario'));
      await tester.pumpAndSettle();

      expect(find.text('Cancelar'), findsOneWidget);
    });

    testWidgets('cancelar en dialog sin login cierra el dialog', (tester) async {
      await pumpBig(tester, buildWidget(_unauthState));

      await tester.ensureVisible(find.text('Quiero ser voluntario'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Quiero ser voluntario'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('botón iniciar sesión navega a /login', (tester) async {
      await pumpBig(tester, buildWidget(_unauthState));

      await tester.ensureVisible(find.text('Quiero ser voluntario'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Quiero ser voluntario'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Iniciar sesión / Registrarse'));
      await tester.pumpAndSettle();

      expect(find.text('login'), findsOneWidget);
    });

    testWidgets('botón casa de acogida abre dialog sin login', (tester) async {
      await pumpBig(tester, buildWidget(_unauthState));

      await tester.ensureVisible(find.text('Ofrecer acogida'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ofrecer acogida'));
      await tester.pumpAndSettle();

      expect(find.text('¡Necesitas una cuenta!'), findsOneWidget);
    });

    testWidgets('botón paseos abre dialog sin login', (tester) async {
      await pumpBig(tester, buildWidget(_unauthState));

      await tester.ensureVisible(find.text('Apuntarme a paseos'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apuntarme a paseos'));
      await tester.pumpAndSettle();

      expect(find.text('¡Necesitas una cuenta!'), findsOneWidget);
    });

    testWidgets('botón apadrinar abre dialog sin login', (tester) async {
      await pumpBig(tester, buildWidget(_unauthState));

      await tester.ensureVisible(find.text('Apadrinar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apadrinar'));
      await tester.pumpAndSettle();

      expect(find.text('¡Necesitas una cuenta!'), findsOneWidget);
    });
  });

  group('HelpScreen — usuario autenticado sin mascotas', () {
    testWidgets('botón voluntariado abre dialog de relación', (tester) async {
      await pumpBig(tester, buildWidget(_userState));

      await tester.ensureVisible(find.text('Quiero ser voluntario'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Quiero ser voluntario'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      // sin mascotas muestra mensaje
      expect(find.text('No hay mascotas disponibles.'), findsOneWidget);
    });

    testWidgets('dialog de relación muestra selector de fecha inicio', (tester) async {
      await pumpBig(tester, buildWidget(_userState));

      await tester.ensureVisible(find.text('Quiero ser voluntario'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Quiero ser voluntario'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Fecha de inicio'), findsOneWidget);
    });

    testWidgets('dialog de relación muestra selector de fecha fin', (tester) async {
      await pumpBig(tester, buildWidget(_userState));

      await tester.ensureVisible(find.text('Quiero ser voluntario'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Quiero ser voluntario'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Fecha de fin'), findsOneWidget);
    });

    testWidgets('dialog de relación muestra botón Enviar solicitud', (tester) async {
      await pumpBig(tester, buildWidget(_userState));

      await tester.ensureVisible(find.text('Quiero ser voluntario'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Quiero ser voluntario'));
      await tester.pumpAndSettle();

      expect(find.text('Enviar solicitud'), findsOneWidget);
    });

    testWidgets('cancelar en dialog de relación cierra el dialog', (tester) async {
      await pumpBig(tester, buildWidget(_userState));

      await tester.ensureVisible(find.text('Quiero ser voluntario'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Quiero ser voluntario'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  group('HelpScreen — scroll', () {
    testWidgets('se puede hacer scroll sin errores', (tester) async {
      await pumpBig(tester, buildWidget(_unauthState));

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}