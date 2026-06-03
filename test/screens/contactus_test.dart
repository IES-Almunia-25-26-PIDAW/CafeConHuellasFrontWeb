import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/screens/contactus.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 1. Declarar el Mock
class MockApiConector extends Mock implements ApiConector {}

void main() {
  // 2. Declarar mockApi a nivel de main
  late MockApiConector mockApi;

  setUp(() {
    mockApi = MockApiConector();
  });

  Widget buildWidget() => MaterialApp(
        home: BlocProvider(
          create: (_) => AuthBloc(mockApi), // 3. Usar mockApi aquí también
          child: ContactusScreen(apiConector: mockApi), // 4. Inyectar el mock
        ),
      );

  Future<void> pumpBig(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(buildWidget());
    await tester.pumpAndSettle();
  }

  group('ContactusScreen', () {
    testWidgets('muestra los campos del formulario', (tester) async {
      await pumpBig(tester);
      expect(find.text('Nombre'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Mensaje'), findsOneWidget);
      expect(find.text('Enviar'), findsOneWidget);
    });

    testWidgets('muestra información de contacto', (tester) async {
      await pumpBig(tester);
      expect(find.text('contacto@protectora.com'), findsWidgets);
      expect(find.text('+34 600 123 456'), findsWidgets);
      expect(find.text('Síguenos en redes'), findsOneWidget);
    });

    testWidgets('al pulsar enviar muestra snackbar', (tester) async {
      // 5. Mock configurado antes del pump
      when(() => mockApi.sendContactMessage(any()))
          .thenAnswer((_) async => {});

      await pumpBig(tester);
      await tester.ensureVisible(find.text('Enviar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Enviar'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Mensaje enviado con éxito'), findsOneWidget);
    });
  });
}