// test/screens/profile_test.dart
import 'package:cafeconhuellas_front/models/user.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_state.dart';
import 'package:cafeconhuellas_front/presentation/screens/profile_sreen.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  //necesitamos un usuario para mostrarlo en el perfil
  final UserWithoutPassword fakeUser = UserWithoutPassword(
    id: 1,
    firstName: 'Yoli',
    lastName1: 'Cabrera',
    lastName2: 'Naranjo',
    email: 'yoli@test.com',
    phone: '600123456',
    role: 'USER',
    imageUrl: '',
  );

  Future<void> pumpBig(WidgetTester tester, Widget widget) async {
    tester.view.physicalSize = const Size(1400, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  }
//test si no se autentica
  group('ProfileScreen - no autenticado', () {
    testWidgets('muestra mensaje de no sesión', (tester) async {
      await pumpBig(
        tester,
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: AuthBloc(ApiConector()),
            child: const ProfileScreen(),
          ),
        ),
      );
      expect(find.text('No has iniciado sesión'), findsOneWidget);
    });
  });
//test de lo que sale si estamos autenticados
  group('ProfileScreen - autenticado con usuario', () {
    // AuthBloc con estado ya autenticado inyectado directamente
    late AuthBloc authBloc;

    setUp(() {
      authBloc = AuthBloc(ApiConector());
      // emitimos estado autenticado con usuario
      authBloc.emit(AuthState(
        token: 'fake-token',
        user: fakeUser,
      ));
    });

    Widget buildAuthenticated() => MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (_, _) => BlocProvider<AuthBloc>.value(
                  value: authBloc,
                  child: const ProfileScreen(),
                ),
              ),
              GoRoute(path: '/login', builder: (_, _) => const Scaffold()),
            ],
          ),
        );

    testWidgets('muestra nombre y email del usuario', (tester) async {
      await pumpBig(tester, buildAuthenticated());
      expect(find.text('Yoli Cabrera'), findsOneWidget);
      expect(find.text('yoli@test.com'), findsOneWidget);
    });

    testWidgets('muestra teléfono y rol', (tester) async {
      await pumpBig(tester, buildAuthenticated());
      expect(find.text('600123456'), findsOneWidget);
      expect(find.text('USER'), findsOneWidget);
    });

    testWidgets('muestra botón de cerrar sesión', (tester) async {
      await pumpBig(tester, buildAuthenticated());
      expect(find.text('Cerrar Sesión'), findsOneWidget);
    });
  });
}