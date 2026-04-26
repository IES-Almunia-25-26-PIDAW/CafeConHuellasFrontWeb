// test/screens/home_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:cafeconhuellas_front/models/event.dart';
import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_event.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_state.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_event.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_state.dart';
import 'package:cafeconhuellas_front/presentation/screens/home_screen.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockPetsBloc extends MockBloc<PetsEvent, PetsState> implements PetsBloc {}
class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}
class MockApi extends Mock implements ApiConector {}

void main() {
  late MockPetsBloc petsBloc;
  late MockAuthBloc authBloc;

  // Estado base vacío
  final estadoVacio = PetsState(
    pets: const [],
    events: const [],
    selectedSpecies: '',
    isEmergencyActive: false,
    isLoading: false,
  );

  // Mascotas de ejemplo
  final pets = [
    Pet(id: 1, name: 'Rex', category: 'Perro', breed: 'Labrador',
        age: 3, adopted: false, imageUrl: 'https://example.com/pet.jpg',
        description: '', urgentAdoption: false),
    Pet(id: 2, name: 'Luna', category: 'Gato', breed: 'Siamés',
        age: 2, adopted: false, imageUrl: 'https://example.com/cat.jpg',
        description: '', urgentAdoption: false),
  ];

  // Eventos de ejemplo
  final events = [
    Event(id: 1, name: 'Adopción', description: 'Gran evento',
        imageUrl: 'https://example.com/ev.jpg',
        eventdate: DateTime.now().add(const Duration(days: 5))),
  ];

  setUp(() {
    petsBloc = MockPetsBloc();
    authBloc = MockAuthBloc();
    when(() => authBloc.state).thenReturn(AuthState());
  });

  tearDown(() {
    petsBloc.close();
    authBloc.close();
  });

  Widget buildWidget() => MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<PetsBloc>.value(value: petsBloc),
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
              GoRoute(
                path: '/pets',
                builder: (context, state) => const Scaffold(body: Text('pets screen')),
              ),
              GoRoute(
                path: '/videojuego',
                builder: (context, state) => const Scaffold(body: Text('videojuego screen')),
              ),
            ],
          ),
        ),
      );

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(buildWidget());
    await tester.pump();
  }

  //  Estado vacío 
  group('HomeScreen — estado vacío', () {
    setUp(() {
      when(() => petsBloc.state).thenReturn(estadoVacio);
    });

    testWidgets('muestra secciones principales', (tester) async {
      await pump(tester);
      expect(find.text('Qué hacemos'), findsOneWidget);
      expect(find.text('Nuestras mascotas'), findsOneWidget);
      expect(find.text('Eventos'), findsOneWidget);
    });

    testWidgets('muestra texto de bienvenida', (tester) async {
      await pump(tester);
      expect(find.textContaining('Bienvenid@'), findsOneWidget);
    });

    testWidgets('muestra botones de navegación', (tester) async {
      await pump(tester);
      expect(find.text('Ver más'), findsOneWidget);
      expect(find.text('Jugar ahora →'), findsOneWidget);
    });

    testWidgets('muestra mensaje cuando no hay mascotas', (tester) async {
      await pump(tester);
      expect(
        find.text('No hay mascotas disponibles en este momento.'),
        findsOneWidget,
      );
    });

    testWidgets('muestra mensaje cuando no hay eventos', (tester) async {
      await pump(tester);
      expect(
        find.text('No hay eventos disponibles en este momento.'),
        findsOneWidget,
      );
    });

    testWidgets('tap en Ver más navega a /pets', (tester) async {
      await pump(tester);
      await tester.tap(find.text('Ver más'));
      await tester.pumpAndSettle();
      expect(find.text('pets screen'), findsOneWidget);
    });

    testWidgets('tap en Jugar ahora navega a /videojuego', (tester) async {
      await pump(tester);
      await tester.tap(find.text('Jugar ahora →'));
      await tester.pumpAndSettle();
      expect(find.text('videojuego screen'), findsOneWidget);
    });
  });

  // Estado cargando 
  group('HomeScreen - estado cargando', () {
    setUp(() {
      when(() => petsBloc.state).thenReturn(
        estadoVacio.copyWith(isLoading: true),
      );
    });

    testWidgets('muestra CircularProgressIndicator para mascotas y eventos', (tester) async {
      await pump(tester);
      // Hay dos BlocBuilder con isLoading, uno para pets y otro para events
      expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
    });
  });

  // Estado con error
  group('HomeScreen — estado con error', () {
    setUp(() {
      when(() => petsBloc.state).thenReturn(
        estadoVacio.copyWith(
          errorMessage: 'No se pudieron cargar las mascotas desde la API.',
        ),
      );
    });

    testWidgets('muestra el mensaje de error', (tester) async {
      await pump(tester);
      expect(
        find.text('No se pudieron cargar las mascotas desde la API.'),
        findsWidgets, // aparece en ambos BlocBuilder (pets y events)
      );
    });
  });

  // Estado con datos 
  group('HomeScreen - con mascotas y eventos', () {
    setUp(() {
      when(() => petsBloc.state).thenReturn(
        estadoVacio.copyWith(pets: pets, events: events),
      );
    });

    testWidgets('muestra nombres de mascotas', (tester) async {
      await pump(tester);
      expect(find.text('Rex'), findsOneWidget);
      expect(find.text('Luna'), findsOneWidget);
    });

    testWidgets('muestra nombre del evento', (tester) async {
      await pump(tester);
      expect(find.text('Adopción'), findsOneWidget);
    });

    testWidgets('no muestra mensajes de lista vacía', (tester) async {
      await pump(tester);
      expect(
        find.text('No hay mascotas disponibles en este momento.'),
        findsNothing,
      );
      expect(
        find.text('No hay eventos disponibles en este momento.'),
        findsNothing,
      );
    });

    testWidgets('muestra máximo 4 mascotas aunque haya más', (tester) async {
      // Ponemos 6 mascotas, debe mostrar solo 4
      final muchasMascotas = List.generate(
        6,
        (i) => Pet(
          id: i,
          name: 'Pet$i',
          category: 'Perro',
          breed: '',
          age: 1,
          adopted: false,
          imageUrl: 'https://example.com/pet$i.jpg',
          description: '',
          urgentAdoption: false,
        ),
      );
      when(() => petsBloc.state).thenReturn(
        estadoVacio.copyWith(pets: muchasMascotas),
      );

      await pump(tester);

      // Solo aparecen Pet0..Pet3, no Pet4 ni Pet5
      expect(find.text('Pet0'), findsOneWidget);
      expect(find.text('Pet3'), findsOneWidget);
      expect(find.text('Pet4'), findsNothing);
      expect(find.text('Pet5'), findsNothing);
    });
  });
}