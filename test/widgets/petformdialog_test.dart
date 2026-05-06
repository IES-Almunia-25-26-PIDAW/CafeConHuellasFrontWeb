// test/screens/pet_form_dialog_test.dart
import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/presentation/widgets/petformdialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget buildWidget({Pet? pet}) => MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (ctx) => ElevatedButton(
            onPressed: () => showDialog(
              context: ctx,
              builder: (_) => PetFormDialog(pet: pet),
            ),
            child: const Text('Abrir'),
          ),
        ),
      ),
    );

Future<void> pumpAndOpen(WidgetTester tester, {Pet? pet}) async {
  tester.view.physicalSize = const Size(1400, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(buildWidget(pet: pet));
  await tester.tap(find.text('Abrir'));
  await tester.pumpAndSettle();
}

final _petExistente = Pet(
  id: 1,
  name: 'Firulais',
  breed: 'Mestizo',
  category: 'Perro',
  age: 3,
  imageUrl: '',
  description: 'Muy bueno',
  urgentAdoption: false,
  adoptionStatus: 'NO_ADOPTADO',
  weight: 12.5,
  neutered: true,
  isPpp: false,
  imageUrls: [],
);

void main() {
  group('PetFormDialog — modo añadir', () {
    testWidgets('muestra título Añadir mascota', (tester) async {
      await pumpAndOpen(tester);
      expect(find.text('Añadir mascota'), findsWidgets);
    });

    testWidgets('muestra campo Nombre', (tester) async {
      await pumpAndOpen(tester);
      expect(find.text('Nombre *'), findsOneWidget);
    });

    testWidgets('muestra campo Raza', (tester) async {
      await pumpAndOpen(tester);
      expect(find.text('Raza'), findsOneWidget);
    });

    testWidgets('muestra campo Descripción', (tester) async {
      await pumpAndOpen(tester);
      expect(find.text('Descripción'), findsOneWidget);
    });

    testWidgets('muestra campo Edad', (tester) async {
      await pumpAndOpen(tester);
      expect(find.text('Edad (años)'), findsOneWidget);
    });

    testWidgets('muestra campo Peso', (tester) async {
      await pumpAndOpen(tester);
      expect(find.text('Peso (kg)'), findsOneWidget);
    });

    testWidgets('muestra selector de especie Perro y Gato', (tester) async {
      await pumpAndOpen(tester);
      expect(find.text('Perro'), findsOneWidget);
      expect(find.text('Gato'), findsOneWidget);
    });

    testWidgets('Perro está seleccionado por defecto', (tester) async {
      await pumpAndOpen(tester);
      final chips = tester.widgetList<ChoiceChip>(find.byType(ChoiceChip)).toList();
      final perroChip = chips.firstWhere(
        (c) => (c.label as Row).children
            .whereType<Text>()
            .any((t) => t.data == 'Perro'),
      );
      expect(perroChip.selected, true);
    });

    testWidgets('Gato no está seleccionado por defecto', (tester) async {
      await pumpAndOpen(tester);
      final chips = tester.widgetList<ChoiceChip>(find.byType(ChoiceChip)).toList();
      final gatoChip = chips.firstWhere(
        (c) => (c.label as Row).children
            .whereType<Text>()
            .any((t) => t.data == 'Gato'),
      );
      expect(gatoChip.selected, false);
    });

    testWidgets('muestra dropdown de estado de adopción', (tester) async {
      await pumpAndOpen(tester);
      expect(find.text('Estado de adopción'), findsOneWidget);
      expect(find.text('NO_ADOPTADO'), findsOneWidget);
    });

    testWidgets('muestra switch Castrado / Esterilizado', (tester) async {
      await pumpAndOpen(tester);
      expect(find.text('Castrado / Esterilizado'), findsOneWidget);
    });

    testWidgets('muestra switch Es PPP', (tester) async {
      await pumpAndOpen(tester);
      expect(find.textContaining('PPP'), findsOneWidget);
    });

    testWidgets('muestra switch Emergencia', (tester) async {
      await pumpAndOpen(tester);
      expect(find.text('Emergencia'), findsOneWidget);
    });

    testWidgets('todos los switches empiezan en false', (tester) async {
      await pumpAndOpen(tester);
      final switches = tester.widgetList<Switch>(find.byType(Switch)).toList();
      for (final s in switches) {
        expect(s.value, false);
      }
    });

    testWidgets('muestra texto Toca para añadir foto', (tester) async {
      await pumpAndOpen(tester);
      expect(find.text('Toca para añadir foto'), findsOneWidget);
    });

    testWidgets('muestra botón Cancelar', (tester) async {
      await pumpAndOpen(tester);
      expect(find.text('Cancelar'), findsOneWidget);
    });

    testWidgets('cancelar cierra el diálogo', (tester) async {
      await pumpAndOpen(tester);
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('muestra error si nombre vacío al guardar', (tester) async {
      await pumpAndOpen(tester);
      // pulsa el botón de guardar sin rellenar nada
      await tester.tap(find.text('Añadir mascota').last);
      await tester.pumpAndSettle();
      expect(find.text('El nombre es obligatorio'), findsOneWidget);
    });

    testWidgets('campos de texto vacíos en modo añadir', (tester) async {
      await pumpAndOpen(tester);
      final controllers = tester
          .widgetList<TextField>(find.byType(TextField))
          .map((f) => f.controller?.text ?? '')
          .toList();
      for (final text in controllers) {
        expect(text, isEmpty);
      }
    });

    testWidgets('seleccionar Gato cambia el chip seleccionado', (tester) async {
      await pumpAndOpen(tester);
      await tester.tap(find.text('Gato'));
      await tester.pumpAndSettle();
      final chips = tester.widgetList<ChoiceChip>(find.byType(ChoiceChip)).toList();
      final gatoChip = chips.firstWhere(
        (c) => (c.label as Row).children
            .whereType<Text>()
            .any((t) => t.data == 'Gato'),
      );
      expect(gatoChip.selected, true);
    });

    testWidgets('activar switch Emergencia lo pone en true', (tester) async {
      await pumpAndOpen(tester);
      // el último switch es Emergencia
      final switchFinder = find.byType(Switch).last;
      expect(tester.widget<Switch>(switchFinder).value, false);
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();
      expect(tester.widget<Switch>(switchFinder).value, true);
    });

    testWidgets('con nombre relleno el diálogo se cierra al guardar', (tester) async {
      await pumpAndOpen(tester);
      await tester.enterText(find.widgetWithText(TextField, 'Nombre *'), 'Rex');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Añadir mascota').last);
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
    });
  });

  group('PetFormDialog — modo editar', () {
    testWidgets('muestra título Editar mascota', (tester) async {
      await pumpAndOpen(tester, pet: _petExistente);
      expect(find.text('Editar mascota'), findsOneWidget);
    });

    testWidgets('prerellena el nombre', (tester) async {
      await pumpAndOpen(tester, pet: _petExistente);
      expect(find.widgetWithText(TextField, 'Firulais'), findsOneWidget);
    });

    testWidgets('prerellena la raza', (tester) async {
      await pumpAndOpen(tester, pet: _petExistente);
      expect(find.widgetWithText(TextField, 'Mestizo'), findsOneWidget);
    });

    testWidgets('prerellena la descripción', (tester) async {
      await pumpAndOpen(tester, pet: _petExistente);
      expect(find.widgetWithText(TextField, 'Muy bueno'), findsOneWidget);
    });

    testWidgets('prerellena la edad', (tester) async {
      await pumpAndOpen(tester, pet: _petExistente);
      expect(find.widgetWithText(TextField, '3'), findsOneWidget);
    });

    testWidgets('prerellena el peso', (tester) async {
      await pumpAndOpen(tester, pet: _petExistente);
      expect(find.widgetWithText(TextField, '12.5'), findsOneWidget);
    });

    testWidgets('switch Castrado prerelleno a true', (tester) async {
      await pumpAndOpen(tester, pet: _petExistente);
      // primer switch = Castrado
      expect(tester.widget<Switch>(find.byType(Switch).first).value, true);
    });

    testWidgets('switch PPP prerelleno a false', (tester) async {
      await pumpAndOpen(tester, pet: _petExistente);
      // segundo switch = PPP
      expect(tester.widget<Switch>(find.byType(Switch).at(1)).value, false);
    });

    testWidgets('muestra botón Guardar cambios', (tester) async {
      await pumpAndOpen(tester, pet: _petExistente);
      expect(find.text('Guardar cambios'), findsOneWidget);
    });

    testWidgets('NO muestra botón Añadir mascota en modo editar', (tester) async {
      await pumpAndOpen(tester, pet: _petExistente);
      expect(find.text('Añadir mascota'), findsNothing);
    });

    testWidgets('estado de adopción prerelleno a NO_ADOPTADO', (tester) async {
      await pumpAndOpen(tester, pet: _petExistente);
      expect(find.text('NO_ADOPTADO'), findsOneWidget);
    });

    testWidgets('guardar en modo editar cierra el diálogo', (tester) async {
      await pumpAndOpen(tester, pet: _petExistente);
      await tester.tap(find.text('Guardar cambios'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('cancelar en modo editar cierra el diálogo', (tester) async {
      await pumpAndOpen(tester, pet: _petExistente);
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
    });
  });
}