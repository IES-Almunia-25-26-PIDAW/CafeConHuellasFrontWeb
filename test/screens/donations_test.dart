import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/screens/donations.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildWidget() => MaterialApp(
        home: BlocProvider(
          create: (_) => AuthBloc(ApiConector()),
          child: const DonationsScreen(),
        ),
      );

  Future<void> pumpBig(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(buildWidget());
    await tester.pumpAndSettle();
  }

  group('DonationsScreen', () {
      testWidgets('muestra título principal y secciones', (tester) async {
      await pumpBig(tester);

      expect(find.text('¿Quieres ayudarnos?'), findsOneWidget);         // ← texto real
      expect(find.text('¡Adopta!'), findsOneWidget);                    // ← texto real
      expect(find.text('¡Haznos una donación!'), findsOneWidget);       // ← texto real
    });

    testWidgets('muestra textos de información de donación', (tester) async {
      await pumpBig(tester);

      expect(find.textContaining('rescatando y cuidando'), findsOneWidget);  // ← texto real
      expect(find.textContaining('vida salvada'), findsOneWidget);           // ← texto real
    });

    testWidgets('muestra botones de acción', (tester) async {
      await pumpBig(tester);

      expect(find.text('Adoptar'), findsOneWidget);   // ← texto real
      expect(find.text('Donar'), findsOneWidget);     // ← texto real
    });
  });
}