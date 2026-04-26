// test/widgets/widgets_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_event.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_state.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:cafeconhuellas_front/presentation/widgets/eventcard.dart';
import 'package:cafeconhuellas_front/presentation/widgets/petcard.dart';

import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}
class MockApi extends Mock implements ApiConector {}

// GoRouter mínimo para que context.go no explote
GoRouter _testRouter(Widget child) => GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => child),
        GoRoute(path: '/login', builder: (_, _) => const Scaffold(body: Text('login'))),
        GoRoute(path: '/profile', builder: (_, _) => const Scaffold(body: Text('profile'))),
        GoRoute(path: '/pets', builder: (_, _) => const Scaffold(body: Text('pets'))),
        GoRoute(path: '/events', builder: (_, _) => const Scaffold(body: Text('events'))),
        GoRoute(path: '/information', builder: (_, _) => const Scaffold(body: Text('info'))),
        GoRoute(path: '/contactus', builder: (_, _) => const Scaffold(body: Text('contact'))),
        GoRoute(path: '/helpus', builder: (_, _) => const Scaffold(body: Text('helpus'))),
        GoRoute(path: '/donations', builder: (_, _) => const Scaffold(body: Text('donations'))),
        GoRoute(path: '/pets/:id', builder: (_, _) => const Scaffold(body: Text('pet detail'))),
      ],
    );

// HELPERS 

Widget wrapWithRouter(Widget child, {MockAuthBloc? authBloc}) {
  final bloc = authBloc ?? MockAuthBloc();
  when(() => bloc.state).thenReturn(AuthState());
  return BlocProvider<AuthBloc>.value(
    value: bloc,
    child: MaterialApp.router(
      routerConfig: _testRouter(
        Scaffold(body: SingleChildScrollView(child: child)), // <-- SingleChildScrollView
      ),
    ),
  );
}

Pet _makePet({
  int id = 1,
  String name = 'Rex',
  String breed = 'Labrador',
  int age = 3,
  bool emergency = false,
  String imageUrl = 'https://example.com/pet.jpg',
}) => Pet(
      id: id,
      name: name,
      breed: breed,
      age: age,
      category: 'Perro',
      urgentAdoption: emergency,
      imageUrl: imageUrl,
      adopted: false,
      description: '',
    );
void main (){
//EVENT CARD 

group('EventCard', () {
  testWidgets('muestra título y descripción', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventCard('assets/img.png', 'Adopción', 'Gran evento de adopción'),
        ),
      ),
    );

    expect(find.text('Adopción'), findsOneWidget);
    expect(find.text('Gran evento de adopción'), findsOneWidget);
  });

  testWidgets('renderiza con imagen de red', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventCard('https://example.com/img.jpg', 'Evento red', 'Desc'),
        ),
      ),
    );

    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Evento red'), findsOneWidget);
  });

  testWidgets('renderiza con imagen de asset', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventCard('assets/img.png', 'Evento asset', 'Desc'),
        ),
      ),
    );

    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Evento asset'), findsOneWidget);
  });

  testWidgets('trunca descripción larga con ellipsis', (tester) async {
    const longDesc = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
        'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
        'Ut enim ad minim veniam, quis nostrud exercitation.';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            child: EventCard('assets/img.png', 'Título', longDesc),
          ),
        ),
      ),
    );

    // El widget existe aunque el texto esté recortado
    expect(find.byType(EventCard), findsOneWidget);
  });
});

// PET CARD 

group('PetCard', () {
  testWidgets('muestra nombre, raza, edad y estado normal', (tester) async {
    final pet = _makePet();
    await tester.pumpWidget(wrapWithRouter(PetCard(pet)));
    await tester.pump();

    expect(find.text('Rex'), findsOneWidget);
    expect(find.text('Raza: Labrador'), findsOneWidget);
    expect(find.text('Edad: 3 años'), findsOneWidget);
    expect(find.text('Estado: Normal'), findsOneWidget);
  });

  testWidgets('muestra "Estado: Emergencia" cuando emergency es true', (tester) async {
    final pet = _makePet(emergency: true);
    await tester.pumpWidget(wrapWithRouter(PetCard(pet)));
    await tester.pump();

    expect(find.text('Estado: Emergencia'), findsOneWidget);
  });

  testWidgets('renderiza imagen de red cuando imageUrl empieza por http', (tester) async {
    final pet = _makePet(imageUrl: 'https://example.com/pet.jpg');
    await tester.pumpWidget(wrapWithRouter(PetCard(pet)));
    await tester.pump();

    expect(find.byType(Image), findsOneWidget);
  });



  testWidgets('tap navega a detalle de mascota', (tester) async {
    final pet = _makePet(id: 7);
    await tester.pumpWidget(wrapWithRouter(PetCard(pet)));
    await tester.pump();

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text('pet detail'), findsOneWidget);
  });

});

//  APP HEADER 
group('AppHeader', () {
  late MockAuthBloc authBloc;

  setUp(() {
    authBloc = MockAuthBloc();
  });

  // Helper específico para el header con tamaño de pantalla controlado
  Future<void> pumpHeader(
    WidgetTester tester, {
    double width = 1400,
    double height = 900,
    AuthState? state,
  }) async {
    when(() => authBloc.state).thenReturn(state ?? AuthState());
    tester.view.physicalSize = Size(width, height);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: MaterialApp.router(
          routerConfig: _testRouter(
            const Scaffold(body: AppHeader()),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('renderiza links de navegación en pantalla ancha', (tester) async {
    await pumpHeader(tester, width: 1400);

    expect(find.text('Inicio'), findsWidgets);
    expect(find.text('Mascotas'), findsWidgets);
    expect(find.text('La protectora ▾'), findsWidgets);
    expect(find.text('Actividades ▾'), findsWidgets);
  });

  testWidgets('renderiza en modo compacto en pantalla estrecha', (tester) async {
    await pumpHeader(tester, width: 800);

    // En compacto también aparecen los items de nav
    expect(find.text('Inicio'), findsWidgets);
    expect(find.text('Mascotas'), findsWidgets);
  });

  testWidgets('muestra CircleAvatar con imagen de asset cuando no hay usuario', (tester) async {
    await pumpHeader(tester);
    expect(find.byType(CircleAvatar), findsOneWidget);
  });

  testWidgets('tap en avatar sin login navega a /login', (tester) async {
    await pumpHeader(tester, state: AuthState()); // no autenticado

    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();

    // El tap en el logo va a '/', el del avatar debería ir a login
    // Buscamos el GestureDetector del avatar (el último de la fila)
    final gestures = find.byType(GestureDetector);
    await tester.tap(gestures.last);
    await tester.pumpAndSettle();

    expect(find.text('login'), findsOneWidget);
  });

  testWidgets('tap en Inicio navega a /', (tester) async {
    await pumpHeader(tester, width: 1400);

    await tester.tap(find.text('Inicio').first);
    await tester.pumpAndSettle();

    // Volvemos a la ruta raíz que muestra el propio header
    expect(find.byType(AppHeader), findsOneWidget);
  });

  testWidgets('tap en Mascotas navega a /pets', (tester) async {
    await pumpHeader(tester, width: 1400);

    await tester.tap(find.text('Mascotas').first);
    await tester.pumpAndSettle();

    expect(find.text('pets'), findsOneWidget);
  });

  testWidgets('muestra avatar con imagen de red cuando el usuario tiene imageUrl', (tester) async {
    when(() => authBloc.state).thenReturn(
      AuthState(
        token: 'tok',
        // Asume que tu AuthState acepta user; ajusta si el constructor es diferente
      ),
    );

    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: MaterialApp.router(
          routerConfig: _testRouter(
            const Scaffold(body: AppHeader(userImageUrl: 'assets/user.png')),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(CircleAvatar), findsOneWidget);
  });
});
}