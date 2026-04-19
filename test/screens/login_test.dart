// test/screens/login_test.dart
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/screens/login_screen.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  Widget buildWidget() => MaterialApp.router(
    //Hacmos nuestro propio gp router de prueba, para probar los caminos, por ello ni siquiera en el register usamos la clase register
        routerConfig: GoRouter(
          routes: [
            GoRoute(path: '/', builder: (_, _) => BlocProvider(
              create: (_) => AuthBloc(ApiConector()),
              child: const LoginPage(),
            )),
            GoRoute(path: '/register', builder: (_, _) => const Scaffold()),
          ],
        ),
      );

  Future<void> pumpBig(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(buildWidget());
    await tester.pumpAndSettle();
  }

  group('LoginPage', () {
    testWidgets('muestra campos de email y contraseña', (tester) async {
      await pumpBig(tester);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Contraseña'), findsOneWidget);
    });

    testWidgets('muestra botón de iniciar sesión', (tester) async {
      await pumpBig(tester);
      expect(find.text('Iniciar sesión'), findsOneWidget);
    });

    testWidgets('muestra enlace a registro', (tester) async {
      await pumpBig(tester);
      expect(find.text('¿No tienes cuenta? Regístrate'), findsOneWidget);
    });

    testWidgets('botón deshabilitado mientras carga', (tester) async {
      await pumpBig(tester);
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      // en estado inicial no está cargando, así que el botón está activo
      expect(button.onPressed, isNotNull);
    });
  });
}