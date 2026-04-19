// test/screens/events_test.dart
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_bloc.dart';
import 'package:cafeconhuellas_front/presentation/screens/events.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildWidget() => MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => AuthBloc(ApiConector())),
            BlocProvider(create: (_) => PetsBloc(api: ApiConector())),
          ],
          child: const EventsScreen(),
        ),
      );

  Future<void> pumpBig(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(buildWidget());
    await tester.pump(); // no pumpAndSettle porque puede haber loading infinito
  }

  group('EventsScreen', () {
    testWidgets('muestra títulos de secciones', (tester) async {
      await pumpBig(tester);
      expect(find.text('Eventos Activos'), findsOneWidget);
      expect(find.text('Eventos Pasados'), findsOneWidget);
    });

    testWidgets('muestra mensaje cuando no hay eventos activos', (tester) async {
      await pumpBig(tester);
      // estado inicial sin eventos cargados
      expect(find.text('No hay eventos activos por fecha.'), findsOneWidget);
    });

    testWidgets('muestra mensaje cuando no hay eventos pasados', (tester) async {
      await pumpBig(tester);
      expect(find.text('No hay eventos pasados por fecha.'), findsOneWidget);
    });
  });
}