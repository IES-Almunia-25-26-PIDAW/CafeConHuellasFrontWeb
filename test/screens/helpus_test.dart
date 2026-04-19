// test/screens/helpus_test.dart
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/screens/helpus_screen.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildWidget() => MaterialApp(
        home: BlocProvider(
          create: (_) => AuthBloc(ApiConector()),
          child: const HelpScreen(),
        ),
      );

  Future<void> pumpBig(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(buildWidget());
    await tester.pumpAndSettle();
  }

  group('HelpScreen', () {
    testWidgets('muestra título principal', (tester) async {
      await pumpBig(tester);
      expect(find.text('¿Cómo puedes ayudar?'), findsOneWidget);
    });

    testWidgets('muestra links de navegación', (tester) async {
      await pumpBig(tester);
      expect(find.text('Voluntariado'), findsWidgets);
      expect(find.text('Casa de acogida'), findsWidgets);
      expect(find.text('Paseos'), findsWidgets);
      expect(find.text('Apadrinamiento'), findsWidgets);
    });

    testWidgets('muestra botones de acción', (tester) async {
      await pumpBig(tester);
      expect(find.text('Quiero ser voluntario'), findsOneWidget);
      expect(find.text('Ofrecer acogida'), findsOneWidget);
      expect(find.text('Apuntarme a paseos'), findsOneWidget);
      expect(find.text('Apadrinar'), findsOneWidget);
    });
  });
}