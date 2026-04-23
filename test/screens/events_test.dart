// test/screens/events_test.dart
import 'package:cafeconhuellas_front/models/event.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_event.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_state.dart';
import 'package:cafeconhuellas_front/presentation/screens/events.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class MockApi extends Mock implements ApiConector {}
class MockPetsBloc extends MockBloc<PetsEvent, PetsState> implements PetsBloc {}

void main() {
  late MockPetsBloc mockBloc;

  // Evento futuro y pasado para los tests
  final eventActivo = Event(
    id: 1,
    name: 'Adopción Primavera',
    description: 'Ven a conocer a nuestros animales',
    imageUrl: 'https://example.com/img.jpg',
    eventdate: DateTime.now().add(const Duration(days: 5)), active: true,
  );

  final eventPasado = Event(
    id: 2,
    name: 'Feria de Navidad',
    description: 'Evento ya celebrado',
    imageUrl: 'https://example.com/img2.jpg',
    eventdate: DateTime.now().subtract(const Duration(days: 5)), active: true,
  );

  // Estado base vacío
  final estadoVacio = PetsState(
    pets: const [],
    events: const [],
    selectedSpecies: '',
    isEmergencyActive: false,
    isLoading: false,
  );

  setUp(() {
    mockBloc = MockPetsBloc();
  });

  tearDown(() => mockBloc.close());

  // Helper para construir el widget con el bloc mockeado
  Widget buildWidget() => MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => AuthBloc(MockApi())),
            BlocProvider<PetsBloc>.value(value: mockBloc),
          ],
          child: const EventsScreen(),
        ),
      );

  Future<void> pumpBig(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(buildWidget());
    await tester.pump();
  }

  group('EventsScreen - estado vacío', () {
    setUp(() {
      when(() => mockBloc.state).thenReturn(estadoVacio);
    });

    testWidgets('muestra los títulos de sección', (tester) async {
      await pumpBig(tester);
      expect(find.text('Eventos Activos'), findsOneWidget);
      expect(find.text('Eventos Pasados'), findsOneWidget);
    });

    testWidgets('muestra mensaje cuando no hay eventos activos', (tester) async {
      await pumpBig(tester);
      expect(find.text('No hay eventos activos por fecha.'), findsOneWidget);
    });

    testWidgets('muestra mensaje cuando no hay eventos pasados', (tester) async {
      await pumpBig(tester);
      expect(find.text('No hay eventos pasados por fecha.'), findsOneWidget);
    });
  });

  group('EventsScreen - estado cargando', () {
    setUp(() {
      when(() => mockBloc.state).thenReturn(
        estadoVacio.copyWith(isLoading: true),
      );
    });

    testWidgets('muestra CircularProgressIndicator mientras carga', (tester) async {
      await pumpBig(tester);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('EventsScreen - con error', () {
    setUp(() {
      when(() => mockBloc.state).thenReturn(
        estadoVacio.copyWith(errorMessage: 'No se pudieron cargar los eventos desde la API.'),
      );
    });

    testWidgets('muestra el mensaje de error en rojo', (tester) async {
      await pumpBig(tester);
      expect(
        find.text('No se pudieron cargar los eventos desde la API.'),
        findsOneWidget,
      );
    });
  });

  group('EventsScreen - con eventos activos', () {
    setUp(() {
      when(() => mockBloc.state).thenReturn(
        estadoVacio.copyWith(events: [eventActivo]),
      );
    });

    testWidgets('muestra el nombre del evento activo', (tester) async {
      await pumpBig(tester);
      expect(find.text('Adopción Primavera'), findsOneWidget);
    });

    testWidgets('muestra la descripción del evento activo', (tester) async {
      await pumpBig(tester);
      expect(find.text('Ven a conocer a nuestros animales'), findsOneWidget);
    });

    testWidgets('NO muestra mensaje de sin eventos activos', (tester) async {
      await pumpBig(tester);
      expect(find.text('No hay eventos activos por fecha.'), findsNothing);
    });
  });

  group('EventsScreen - con eventos pasados', () {
    setUp(() {
      when(() => mockBloc.state).thenReturn(
        estadoVacio.copyWith(events: [eventPasado]),
      );
    });

    testWidgets('muestra el nombre del evento pasado', (tester) async {
      await pumpBig(tester);
      expect(find.text('Feria de Navidad'), findsOneWidget);
    });

    testWidgets('muestra la descripción del evento pasado', (tester) async {
      await pumpBig(tester);
      expect(find.text('Evento ya celebrado'), findsOneWidget);
    });

    testWidgets('NO muestra mensaje de sin eventos pasados', (tester) async {
      await pumpBig(tester);
      expect(find.text('No hay eventos pasados por fecha.'), findsNothing);
    });
  });

  group('EventsScreen - con ambos tipos de eventos', () {
    setUp(() {
      when(() => mockBloc.state).thenReturn(
        estadoVacio.copyWith(events: [eventActivo, eventPasado]),
      );
    });

    testWidgets('muestra eventos activos y pasados a la vez', (tester) async {
      await pumpBig(tester);
      expect(find.text('Adopción Primavera'), findsOneWidget);
      expect(find.text('Feria de Navidad'), findsOneWidget);
    });

    testWidgets('no muestra ningún mensaje de lista vacía', (tester) async {
      await pumpBig(tester);
      expect(find.text('No hay eventos activos por fecha.'), findsNothing);
      expect(find.text('No hay eventos pasados por fecha.'), findsNothing);
    });
  });

  group('EventsScreen - imagen con error de red', () {
    setUp(() {
      // Imagen con URL rota para ejercitar el errorBuilder
      when(() => mockBloc.state).thenReturn(
        estadoVacio.copyWith(events: [
          Event(
            id: 3,
            name: 'Evento roto',
            description: 'Imagen fallida',
            imageUrl: 'https://url-que-no-existe.xyz/img.jpg',
            eventdate: DateTime.now().add(const Duration(days: 1)), active: true,
          ),
        ]),
      );
    });

    testWidgets('muestra el evento aunque la imagen falle', (tester) async {
      await pumpBig(tester);
      expect(find.text('Evento roto'), findsOneWidget);
    });
  });
}