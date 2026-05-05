// test/screens/panel_test.dart
import 'package:cafeconhuellas_front/models/user.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_state.dart';
import 'package:cafeconhuellas_front/presentation/screens/panel_screen.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockApi extends Mock implements ApiConector {}

// AuthBloc que arranca con un estado concreto
class FakeAuthBloc extends AuthBloc {
  final AuthState _fakeState;
  FakeAuthBloc(this._fakeState) : super(MockApi());

  @override
  AuthState get state => _fakeState;
}

Widget buildWidget({required AuthState authState, List<GoRoute> extraRoutes = const []}) {
  return MaterialApp.router(
    routerConfig: GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => BlocProvider<AuthBloc>(
            create: (_) => FakeAuthBloc(authState),
            child: const PanelScreen(),
          ),
        ),
        GoRoute(path: '/panel/donations',     builder: (_, __) => const Scaffold(body: Text('donations'))),
        GoRoute(path: '/panel/relationships', builder: (_, __) => const Scaffold(body: Text('relationships'))),
        ...extraRoutes,
      ],
    ),
  );
}

Future<void> pumpBig(WidgetTester tester, Widget widget) async {
  tester.view.physicalSize = const Size(1400, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(widget);
  await tester.pumpAndSettle();
}

// Estados de prueba
AuthState get _userState => AuthState(
  token: 'tok', isLoading: false,
  user: UserWithoutPassword(
    id: 1, firstName: 'Ana', lastName1: '', lastName2: '',
    email: 'ana@test.com', phone: '', role: 'USER', imageUrl: '',
  ),
);

AuthState get _adminState => AuthState(
  token: 'tok', isLoading: false,
  user: UserWithoutPassword(
    id: 2, firstName: 'Admin', lastName1: '', lastName2: '',
    email: 'admin@test.com', phone: '', role: 'ADMIN', imageUrl: '',
  ),
);

void main() {
  group('PanelScreen — usuario normal', () {
    testWidgets('muestra título "Mis cosas"', (tester) async {
      await pumpBig(tester, buildWidget(authState: _userState));
      expect(find.text('Mis cosas'), findsOneWidget);
    });

    testWidgets('muestra tarjeta Mis Donaciones', (tester) async {
      await pumpBig(tester, buildWidget(authState: _userState));
      expect(find.text('Mis Donaciones'), findsOneWidget);
    });

    testWidgets('muestra tarjeta Mis Peticiones', (tester) async {
      await pumpBig(tester, buildWidget(authState: _userState));
      expect(find.text('Mis Peticiones'), findsOneWidget);
    });

    testWidgets('muestra subtítulo de donaciones de usuario', (tester) async {
      await pumpBig(tester, buildWidget(authState: _userState));
      expect(find.text('Ver mis donaciones'), findsOneWidget);
    });

    testWidgets('muestra subtítulo de peticiones de usuario', (tester) async {
      await pumpBig(tester, buildWidget(authState: _userState));
      expect(find.text('Ver mis solicitudes de adopción'), findsOneWidget);
    });

    testWidgets('tap en Mis Donaciones navega a /panel/donations', (tester) async {
      await pumpBig(tester, buildWidget(authState: _userState));
      await tester.tap(find.text('Mis Donaciones'));
      await tester.pumpAndSettle();
      expect(find.text('donations'), findsOneWidget);
    });

    testWidgets('tap en Mis Peticiones navega a /panel/relationships', (tester) async {
      await pumpBig(tester, buildWidget(authState: _userState));
      await tester.tap(find.text('Mis Peticiones'));
      await tester.pumpAndSettle();
      expect(find.text('relationships'), findsOneWidget);
    });
  });

  group('PanelScreen — administrador', () {
    testWidgets('muestra título "Panel de Administración"', (tester) async {
      await pumpBig(tester, buildWidget(authState: _adminState));
      expect(find.text('Panel de Administración'), findsOneWidget);
    });

    testWidgets('muestra tarjeta Gestionar Donaciones', (tester) async {
      await pumpBig(tester, buildWidget(authState: _adminState));
      expect(find.text('Gestionar Donaciones'), findsOneWidget);
    });

    testWidgets('muestra tarjeta Gestionar Peticiones', (tester) async {
      await pumpBig(tester, buildWidget(authState: _adminState));
      expect(find.text('Gestionar Peticiones'), findsOneWidget);
    });

    testWidgets('muestra subtítulo de donaciones de admin', (tester) async {
      await pumpBig(tester, buildWidget(authState: _adminState));
      expect(find.text('Ver todas las donaciones recibidas'), findsOneWidget);
    });

    testWidgets('muestra subtítulo de peticiones de admin', (tester) async {
      await pumpBig(tester, buildWidget(authState: _adminState));
      expect(find.text('Gestionar solicitudes de adopción'), findsOneWidget);
    });

    testWidgets('tap en Gestionar Donaciones navega a /panel/donations', (tester) async {
      await pumpBig(tester, buildWidget(authState: _adminState));
      await tester.tap(find.text('Gestionar Donaciones'));
      await tester.pumpAndSettle();
      expect(find.text('donations'), findsOneWidget);
    });

    testWidgets('tap en Gestionar Peticiones navega a /panel/relationships', (tester) async {
      await pumpBig(tester, buildWidget(authState: _adminState));
      await tester.tap(find.text('Gestionar Peticiones'));
      await tester.pumpAndSettle();
      expect(find.text('relationships'), findsOneWidget);
    });
  });

  group('PanelScreen — estructura visual', () {
    testWidgets('muestra exactamente 2 tarjetas', (tester) async {
      await pumpBig(tester, buildWidget(authState: _userState));
      // cada tarjeta tiene un CircleAvatar con un icono
      expect(find.byType(CircleAvatar), findsWidgets);
    });

    testWidgets('admin NO muestra textos de usuario', (tester) async {
      await pumpBig(tester, buildWidget(authState: _adminState));
      expect(find.text('Mis cosas'), findsNothing);
      expect(find.text('Mis Donaciones'), findsNothing);
      expect(find.text('Mis Peticiones'), findsNothing);
    });

    testWidgets('usuario NO muestra textos de admin', (tester) async {
      await pumpBig(tester, buildWidget(authState: _userState));
      expect(find.text('Panel de Administración'), findsNothing);
      expect(find.text('Gestionar Donaciones'), findsNothing);
      expect(find.text('Gestionar Peticiones'), findsNothing);
    });
  });
}