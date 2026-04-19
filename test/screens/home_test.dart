// test/screens/home_test.dart
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_bloc.dart';
import 'package:cafeconhuellas_front/presentation/screens/home_screen.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  // HomeScreen usa context.go() así que necesita GoRouter
  //preparamos las rutas antes de probarlas
  Widget buildWidget() => MaterialApp.router(
        routerConfig: GoRouter(
          routes: [
            GoRoute(path: '/', builder: (_, _) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => AuthBloc(ApiConector())),
                BlocProvider(create: (_) => PetsBloc(api: ApiConector())),
              ],
              child: const HomeScreen(),
            )),
            GoRoute(path: '/pets', builder: (_, _) => const Scaffold()),
            GoRoute(path: '/videojuego', builder: (_, _) => const Scaffold()),
          ],
        ),
      );

  Future<void> pumpBig(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(buildWidget());
    await tester.pump();
  }

  group('HomeScreen', () {
    testWidgets('muestra secciones principales', (tester) async {
      await pumpBig(tester);
      expect(find.text('Qué hacemos'), findsOneWidget);
      expect(find.text('Nuestras mascotas'), findsOneWidget);
      expect(find.text('Eventos'), findsOneWidget);
    });

    testWidgets('muestra texto de bienvenida', (tester) async {
      await pumpBig(tester);
      expect(find.textContaining('Bienvenid@'), findsOneWidget);
    });

    testWidgets('muestra botones de navegación', (tester) async {
      await pumpBig(tester);
      expect(find.text('Ver más'), findsOneWidget);
      expect(find.text('Jugar ahora →'), findsOneWidget);
    });

    testWidgets('muestra mensaje cuando no hay mascotas', (tester) async {
      await pumpBig(tester);
      // estado inicial sin datos cargados de la API
      expect(find.text('No hay mascotas disponibles en este momento.'), findsOneWidget);
    });
  });
}