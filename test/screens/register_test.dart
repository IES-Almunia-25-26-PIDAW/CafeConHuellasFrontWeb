// test/screens/register_test.dart
import 'package:cafeconhuellas_front/presentation/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  Widget buildWidget() => MaterialApp.router(
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              // usamos context y state con nombres distintos
              builder: (context, state) => const RegisterScreen(),
            ),
            GoRoute(
              path: '/login',
              builder: (context, state) => const Scaffold(),
            ),
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

  group('RegisterPage', () {
    testWidgets('muestra campos de email, contraseña, nombre, apellidos, numero de telefono', (tester) async {
      await pumpBig(tester);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Nombre'), findsOneWidget);
      expect(find.text('Apellido'), findsOneWidget);
      expect(find.text('Apellido2'), findsOneWidget);
      expect(find.text('Teléfono'), findsOneWidget); // ojo con la tilde
    });

    testWidgets('muestra botón de registro', (tester) async {
      await pumpBig(tester);
      expect(find.text('Registrarse'), findsOneWidget);
    });

    testWidgets('muestra enlace a inicio de sesión', (tester) async {
      await pumpBig(tester);
      expect(find.text('¿Ya tienes cuenta? Inicia sesión'), findsOneWidget);
    });

    testWidgets('botón activo en estado inicial', (tester) async {
      await pumpBig(tester);
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton).first);
      // en estado inicial no está cargando, así que el botón está activo
      expect(button.onPressed, isNotNull);
    });
  });
}