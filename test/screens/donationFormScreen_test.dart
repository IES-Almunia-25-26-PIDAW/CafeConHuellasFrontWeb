// test/screens/donation_form_test.dart
import 'package:cafeconhuellas_front/presentation/screens/donationFormScreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Widget buildWidget() => MaterialApp.router(
  routerConfig: GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (_, _) => const DonationFormScreen(token: 'test-token'),
    ),
  ]),
);

Future<void> pumpBig(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1400, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(buildWidget());
  await tester.pumpAndSettle();
}

void main() {
  group('DonationFormScreen — campos', () {
    testWidgets('muestra título del formulario', (tester) async {
      await pumpBig(tester);
      expect(find.text('Formulario de Adopción'), findsOneWidget);
    });

    testWidgets('muestra campo Dirección', (tester) async {
      await pumpBig(tester);
      expect(find.text('Dirección *'), findsOneWidget);
    });

    testWidgets('muestra campo Ciudad', (tester) async {
      await pumpBig(tester);
      expect(find.text('Ciudad *'), findsOneWidget);
    });

    testWidgets('muestra campo Tipo de vivienda', (tester) async {
      await pumpBig(tester);
      expect(find.textContaining('Tipo de vivienda'), findsOneWidget);
    });

    testWidgets('muestra campo Horas solo al día', (tester) async {
      await pumpBig(tester);
      expect(find.textContaining('Horas solo'), findsOneWidget);
    });

    testWidgets('muestra campo Motivo de adopción', (tester) async {
      await pumpBig(tester);
      expect(find.textContaining('Motivo de adopción'), findsOneWidget);
    });

    testWidgets('muestra campo Información adicional', (tester) async {
      await pumpBig(tester);
      expect(find.text('Información adicional'), findsOneWidget);
    });

    testWidgets('muestra botón Enviar solicitud', (tester) async {
      await pumpBig(tester);
      expect(find.text('Enviar solicitud'), findsOneWidget);
    });

    testWidgets('botón enviar está activo en estado inicial', (tester) async {
      await pumpBig(tester);
      final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton).first);
      expect(btn.onPressed, isNotNull);
    });
  });

  group('DonationFormScreen — switches', () {
    testWidgets('muestra switch ¿Tienes jardín?', (tester) async {
      await pumpBig(tester);
      expect(find.text('¿Tienes jardín?'), findsOneWidget);
    });

    testWidgets('muestra switch ¿Tienes otras mascotas?', (tester) async {
      await pumpBig(tester);
      expect(find.text('¿Tienes otras mascotas?'), findsOneWidget);
    });

    testWidgets('muestra switch ¿Tienes niños en casa?', (tester) async {
      await pumpBig(tester);
      expect(find.text('¿Tienes niños en casa?'), findsOneWidget);
    });

    testWidgets('muestra switch experiencia con mascotas', (tester) async {
      await pumpBig(tester);
      expect(find.textContaining('experiencia'), findsOneWidget);
    });

    testWidgets('muestra switch seguimiento post-adopción', (tester) async {
      await pumpBig(tester);
      expect(find.textContaining('seguimiento'), findsOneWidget);
    });

    testWidgets('switches empiezan en false', (tester) async {
      await pumpBig(tester);
      final switches = tester.widgetList<Switch>(find.byType(Switch)).toList();
      for (final s in switches) {
        expect(s.value, false);
      }
    });

    testWidgets('switch jardín cambia de estado al pulsarlo', (tester) async {
      await pumpBig(tester);
      final switchFinder = find.byType(Switch).first;
      expect(tester.widget<Switch>(switchFinder).value, false);
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();
      expect(tester.widget<Switch>(switchFinder).value, true);
    });
  });

  group('DonationFormScreen — validaciones', () {
    testWidgets('muestra error si campos obligatorios vacíos', (tester) async {
      await pumpBig(tester);
      await tester.tap(find.text('Enviar solicitud'));
      await tester.pumpAndSettle();
      expect(find.textContaining('obligatorios'), findsOneWidget);
    });

    testWidgets('muestra error si horas no es número', (tester) async {
      await pumpBig(tester);
      await tester.enterText(
          find.widgetWithText(TextField, 'Dirección *'), 'Calle Test');
      await tester.enterText(
          find.widgetWithText(TextField, 'Ciudad *'), 'Sevilla');
      await tester.enterText(
          find.widgetWithText(TextField, 'Tipo de vivienda * (piso, casa, chalet...)'), 'Piso');
      await tester.enterText(
          find.widgetWithText(TextField, 'Motivo de adopción *'), 'Me gustan los animales');
      await tester.enterText(
          find.widgetWithText(TextField, 'Horas solo al día *'), 'abc');
      await tester.tap(find.text('Enviar solicitud'));
      await tester.pumpAndSettle();
      expect(find.textContaining('número'), findsOneWidget);
    });
  });
}