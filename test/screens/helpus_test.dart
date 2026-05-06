import 'package:cafeconhuellas_front/presentation/screens/helpus_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpBig(WidgetTester tester, Widget widget) async {
    tester.view.physicalSize = const Size(1400, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  }

  group('HelpScreen extra coverage', () {

    testWidgets('scroll funciona sin errores', (tester) async {
      await pumpBig(tester, const MaterialApp(home: HelpScreen()));

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );

      await tester.pumpAndSettle();

      expect(find.text('Apadrinar'), findsOneWidget);
    });

    testWidgets('botón voluntariado es clickable', (tester) async {
      await pumpBig(tester, const MaterialApp(home: HelpScreen()));

      await tester.dragUntilVisible(
        find.text('Quiero ser voluntario'),
        find.byType(SingleChildScrollView),
        const Offset(0, -200),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Quiero ser voluntario'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsWidgets);
    });

    testWidgets('botón casa de acogida abre dialog', (tester) async {
      await pumpBig(tester, const MaterialApp(home: HelpScreen()));

      await tester.dragUntilVisible(
        find.text('Ofrecer acogida'),
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Ofrecer acogida'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsWidgets);
    });

    testWidgets('todos los botones existen en pantalla', (tester) async {
      await pumpBig(tester, const MaterialApp(home: HelpScreen()));

      expect(find.text('Quiero ser voluntario'), findsOneWidget);
      expect(find.text('Ofrecer acogida'), findsOneWidget);
      expect(find.text('Apuntarme a paseos'), findsOneWidget);
      expect(find.text('Apadrinar'), findsOneWidget);
    });

    testWidgets('links de ayuda están visibles', (tester) async {
      await pumpBig(tester, const MaterialApp(home: HelpScreen()));

      expect(find.text('Voluntariado'), findsWidgets);
      expect(find.text('Casa de acogida'), findsWidgets);
      expect(find.text('Paseos'), findsWidgets);
      expect(find.text('Apadrinamiento'), findsWidgets);
    });
  });
}