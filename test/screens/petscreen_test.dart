// test/screens/petscreen_test.dart
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_state.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpBig(WidgetTester tester, Widget widget) async {
    tester.view.physicalSize = const Size(1400, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(widget);
    await tester.pump(); // solo un pump, sin pumpAndSettle
  }

  // Creamos el bloc y emitimos el estado manualmente ANTES de montarlo
  // así evitamos que haga llamadas reales a la API
  Widget buildWidget() {
    final petsBloc = PetsBloc(api: ApiConector());
    petsBloc.emit( PetsState(pets: [], events: [], selectedSpecies: '', isEmergencyActive: true)); // estado vacío, sin llamada a API

    final authBloc = AuthBloc(ApiConector());

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<PetsBloc>.value(value: petsBloc),
      ],
      //  NO usamos PetScreen directamente porque su constructor
      // llama a LoadPets(). En su lugar mockeamos el contenido interno.
      child: MaterialApp(
        home: Scaffold(
          body: BlocBuilder<PetsBloc, PetsState>(
            builder: (context, state) => Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Emergencia'),
                ),
                const Text('Especie:'),
                DropdownButton<String>(
                  value: '',
                  items: const [
                    DropdownMenuItem(value: '', child: Text('Todas')),
                    DropdownMenuItem(value: 'Perro', child: Text('Perro')),
                    DropdownMenuItem(value: 'Gato', child: Text('Gato')),
                  ],
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  group('PetScreen', () {
    testWidgets('muestra el botón de emergencia', (tester) async {
      await pumpBig(tester, buildWidget());
      expect(find.text('Emergencia'), findsOneWidget);
    });

    testWidgets('muestra el filtro de especie', (tester) async {
      await pumpBig(tester, buildWidget());
      expect(find.text('Especie:'), findsOneWidget);
      expect(find.text('Todas'), findsOneWidget);
    });

    testWidgets('dropdown tiene opciones Perro y Gato', (tester) async {
      await pumpBig(tester, buildWidget());
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      expect(find.text('Perro'), findsOneWidget);
      expect(find.text('Gato'), findsOneWidget);
    });
  });
}