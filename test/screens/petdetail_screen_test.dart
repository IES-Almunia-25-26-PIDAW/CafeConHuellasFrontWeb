// test/screens/pet_detail_test.dart
import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/screens/petdetail.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  // mascota de prueba para no depender de la API
  final Pet fakePet = Pet(
    id: 1,
    name: 'Luna',
    breed: 'Mestiza',
    age: 3,
    weight: 8.5,
    isPpp: false,
    neutered: true,
    description: 'Una perrita muy cariñosa.',
    imageUrl: 'assets/user.png',
    species: Species.perro, 
    adopted: true, 
    emergency: true,
  );

  Widget buildWidget() => MaterialApp.router(
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => BlocProvider(
                create: (_) => AuthBloc(ApiConector()),
                child: PetDetailScreen(petId: 1, pet: fakePet),
              ),
            ),
            GoRoute(path: '/contactus', builder: (_, _) => const Scaffold()),
          ],
        ),
      );

  Future<void> pumpBig(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(buildWidget());
    await tester.pumpAndSettle();
  }

  group('PetDetailScreen', () {
    testWidgets('muestra el nombre de la mascota', (tester) async {
      await pumpBig(tester);
      expect(find.text('Luna'), findsWidgets);
    });

    testWidgets('muestra los datos de la mascota', (tester) async {
      await pumpBig(tester);
      expect(find.textContaining('Mestiza'), findsOneWidget);
      expect(find.textContaining('3'), findsWidgets);
      expect(find.textContaining('8.5'), findsOneWidget);
    });

    testWidgets('muestra sección sobre la mascota', (tester) async {
      await pumpBig(tester);
      expect(find.text('Sobre Luna'), findsOneWidget);
      expect(find.text('Una perrita muy cariñosa.'), findsOneWidget);
    });

    testWidgets('muestra botón de contacto', (tester) async {
      await pumpBig(tester);
      expect(find.text('Contacta con nosotros'), findsOneWidget);
      expect(find.text('¿Quieres ayudarle?'), findsOneWidget);
    });

    testWidgets('muestra not found cuando petId es negativo', (tester) async {
      tester.view.physicalSize = const Size(1400, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
          create: (_) => AuthBloc(ApiConector()),
          child: const PetDetailScreen(petId: -1),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Mascota no encontrada'), findsOneWidget);
    });
  });
}