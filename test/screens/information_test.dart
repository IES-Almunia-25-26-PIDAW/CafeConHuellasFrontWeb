// test/screens/information_test.dart
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/screens/information_screen.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //lo mismo q en los otros test, lo preparamos para probarlo gracias a un provider
  Widget buildWidget() => MaterialApp(
        home: BlocProvider(
          create: (_) => AuthBloc(ApiConector()),
          child: const InformationScreen(),
        ),
      );

  Future<void> pumpBig(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(buildWidget());
    await tester.pumpAndSettle();
  }

  group('InformationScreen', () {
    testWidgets('muestra secciones principales', (tester) async {
      await pumpBig(tester);
      expect(find.text('¿Quiénes somos?'), findsOneWidget);
      expect(find.text('Nuestro propósito:'), findsOneWidget);
      expect(find.text('Aquí estamos:'), findsOneWidget);
      expect(find.text('Historia'), findsOneWidget);
    });

    testWidgets('muestra texto de descripción', (tester) async {
      await pumpBig(tester);
      expect(find.textContaining('patitas unidas'), findsWidgets);
    });
  });
}