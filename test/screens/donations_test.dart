// test/screens/donations_screen_test.dart
import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/models/user.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_state.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_state.dart';
import 'package:cafeconhuellas_front/presentation/screens/donations.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────────

class MockApi extends Mock implements ApiConector {}

class FakeAuthBloc extends AuthBloc {
  final AuthState _s;
  FakeAuthBloc(this._s) : super(MockApi());
  @override
  AuthState get state => _s;
}

class FakePetsBloc extends PetsBloc {
  final PetsState _s;
  FakePetsBloc(this._s) : super(api: MockApi());
  @override
  PetsState get state => _s;
}

// ── Estados de prueba ─────────────────────────────────────────────────────────

AuthState get _unauthState => AuthState(isLoading: false);

AuthState get _userState => AuthState(
      token: 'tok',
      isLoading: false,
      user: UserWithoutPassword(
        id: 1,
        firstName: 'Ana',
        lastName1: '',
        lastName2: '',
        email: '',
        phone: '',
        role: 'USER',
        imageUrl: '',
      ),
    );

Pet _makePet(int id, String name) => Pet(
      id: id,
      name: name,
      
      breed: 'Labrador',
      age: 3,
      adoptionStatus: 'NO_ADOPTADO',
      imageUrl: '',
      description: '',
       category: '', urgentAdoption: true,
    );

PetsState _petsState(List<Pet> pets) => PetsState(
      pets: pets,
      selectedSpecies: '',
      isEmergencyActive: false,
      isLoading: false,
      events: const [],
      relations: const [],
      adoptionRequests: const [],
    );

PetsState get _emptyPets => _petsState([]);
PetsState get _withPets  => _petsState([_makePet(1, 'Rex'), _makePet(2, 'Luna')]);

// ── Helper buildWidget ────────────────────────────────────────────────────────

Widget buildWidget({AuthState? auth, PetsState? pets}) => MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (_) => FakeAuthBloc(auth ?? _unauthState)),
          BlocProvider<PetsBloc>(create: (_) => FakePetsBloc(pets ?? _emptyPets)),
        ],
        child: const DonationsScreen(),
      ),
    );

Future<void> pumpBig(WidgetTester tester, Widget widget) async {
  tester.view.physicalSize = const Size(1400, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(widget);
  await tester.pumpAndSettle();
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  // ── Contenido básico ────────────────────────────────────────────────────────

  group('DonationsScreen — contenido básico', () {
    testWidgets('muestra título principal', (tester) async {
      await pumpBig(tester, buildWidget());
      expect(find.text('¿Quieres ayudarnos?'), findsOneWidget);
    });

    testWidgets('muestra sección de adopción', (tester) async {
      await pumpBig(tester, buildWidget());
      expect(find.text('¡Adopta!'), findsOneWidget);
    });

    testWidgets('muestra sección de donación', (tester) async {
      await pumpBig(tester, buildWidget());
      expect(find.text('¡Haznos una donación!'), findsOneWidget);
    });

    testWidgets('muestra texto descriptivo de adopción', (tester) async {
      await pumpBig(tester, buildWidget());
      expect(find.textContaining('vida salvada'), findsOneWidget);
    });

    testWidgets('muestra texto descriptivo de donación', (tester) async {
      await pumpBig(tester, buildWidget());
      expect(find.textContaining('rescatando y cuidando'), findsOneWidget);
    });

    testWidgets('muestra botón Adoptar', (tester) async {
      await pumpBig(tester, buildWidget());
      expect(find.text('Adoptar'), findsOneWidget);
    });

    testWidgets('muestra botón Donar', (tester) async {
      await pumpBig(tester, buildWidget());
      expect(find.text('Donar'), findsOneWidget);
    });

    testWidgets('se puede hacer scroll sin errores', (tester) async {
      await pumpBig(tester, buildWidget());
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  // ── Dialog de donación ──────────────────────────────────────────────────────

  group('DonationsScreen — dialog de donación', () {
    testWidgets('abre el dialog al pulsar Donar', (tester) async {
      await pumpBig(tester, buildWidget());
      await tester.tap(find.text('Donar'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('dialog muestra título "Hacer una donación"', (tester) async {
      await pumpBig(tester, buildWidget());
      await tester.tap(find.text('Donar'));
      await tester.pumpAndSettle();
      expect(find.text('Hacer una donación'), findsOneWidget);
    });

    testWidgets('dialog muestra selector de fecha', (tester) async {
      await pumpBig(tester, buildWidget());
      await tester.tap(find.text('Donar'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      expect(find.text('Cambiar'), findsOneWidget);
    });

    testWidgets('dialog muestra dropdown de categoría', (tester) async {
      await pumpBig(tester, buildWidget());
      await tester.tap(find.text('Donar'));
      await tester.pumpAndSettle();
      expect(find.text('MONETARIA'), findsOneWidget);
    });

    testWidgets('dialog muestra dropdown de método de pago', (tester) async {
      await pumpBig(tester, buildWidget());
      await tester.tap(find.text('Donar'));
      await tester.pumpAndSettle();
      expect(find.text('TARJETA'), findsOneWidget);
    });

    testWidgets('dialog muestra campo de cantidad', (tester) async {
      await pumpBig(tester, buildWidget());
      await tester.tap(find.text('Donar'));
      await tester.pumpAndSettle();
      expect(find.text('Cantidad (€)'), findsOneWidget);
    });

    testWidgets('dialog muestra campo de notas', (tester) async {
      await pumpBig(tester, buildWidget());
      await tester.tap(find.text('Donar'));
      await tester.pumpAndSettle();
      expect(find.text('Notas (opcional)'), findsOneWidget);
    });

    testWidgets('dialog muestra botón Confirmar donación', (tester) async {
      await pumpBig(tester, buildWidget());
      await tester.tap(find.text('Donar'));
      await tester.pumpAndSettle();
      expect(find.text('Confirmar donación'), findsOneWidget);
    });

    testWidgets('dialog muestra botón Cancelar', (tester) async {
      await pumpBig(tester, buildWidget());
      await tester.tap(find.text('Donar'));
      await tester.pumpAndSettle();
      expect(find.text('Cancelar'), findsOneWidget);
    });

    testWidgets('Cancelar cierra el dialog', (tester) async {
      await pumpBig(tester, buildWidget());
      await tester.tap(find.text('Donar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('confirmar sin cantidad muestra snackbar de error', (tester) async {
      await pumpBig(tester, buildWidget());
      await tester.tap(find.text('Donar'));
      await tester.pumpAndSettle();
      // no introducimos cantidad → campo vacío
      await tester.tap(find.text('Confirmar donación'));
      await tester.pumpAndSettle();
      expect(find.text('Introduce una cantidad válida'), findsOneWidget);
    });

    testWidgets('confirmar con cantidad 0 muestra snackbar de error', (tester) async {
      await pumpBig(tester, buildWidget());
      await tester.tap(find.text('Donar'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, '0');
      await tester.tap(find.text('Confirmar donación'));
      await tester.pumpAndSettle();
      expect(find.text('Introduce una cantidad válida'), findsOneWidget);
    });

    testWidgets('confirmar con texto no numérico muestra snackbar de error', (tester) async {
      await pumpBig(tester, buildWidget());
      await tester.tap(find.text('Donar'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'abc');
      await tester.tap(find.text('Confirmar donación'));
      await tester.pumpAndSettle();
      expect(find.text('Introduce una cantidad válida'), findsOneWidget);
    });

    testWidgets('el dialog no se cierra si la cantidad es inválida', (tester) async {
      await pumpBig(tester, buildWidget());
      await tester.tap(find.text('Donar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirmar donación'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('se pueden cambiar categorías en el dropdown', (tester) async {
      await pumpBig(tester, buildWidget());
      await tester.tap(find.text('Donar'));
      await tester.pumpAndSettle();

      // abrimos el dropdown de categoría
      await tester.tap(find.text('MONETARIA'));
      await tester.pumpAndSettle();

      // seleccionamos otra opción
      await tester.tap(find.text('ALIMENTACION').last);
      await tester.pumpAndSettle();

      expect(find.text('ALIMENTACION'), findsOneWidget);
    });

    testWidgets('se pueden cambiar métodos de pago en el dropdown', (tester) async {
      await pumpBig(tester, buildWidget());
      await tester.tap(find.text('Donar'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('TARJETA'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('BIZUM').last);
      await tester.pumpAndSettle();

      expect(find.text('BIZUM'), findsOneWidget);
    });

    testWidgets('se puede escribir en el campo de notas', (tester) async {
      await pumpBig(tester, buildWidget());
      await tester.tap(find.text('Donar'));
      await tester.pumpAndSettle();

      // el segundo TextField es el de notas
      await tester.enterText(find.byType(TextField).last, 'Con mucho cariño');
      expect(find.text('Con mucho cariño'), findsOneWidget);
    });
  });

  // ── Dialog de adopción — sin autenticar ────────────────────────────────────

  group('DonationsScreen — adopción sin login', () {
    testWidgets('pulsar Adoptar sin login muestra snackbar de error', (tester) async {
      await pumpBig(tester, buildWidget(auth: _unauthState));
      await tester.tap(find.text('Adoptar'));
      await tester.pumpAndSettle();
      expect(find.text('Inicia sesión primero'), findsOneWidget);
    });

    testWidgets('sin login no se abre ningún AlertDialog', (tester) async {
      await pumpBig(tester, buildWidget(auth: _unauthState));
      await tester.tap(find.text('Adoptar'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  // ── Dialog de adopción — autenticado sin mascotas ──────────────────────────

  group('DonationsScreen — adopción autenticado sin mascotas', () {
    testWidgets('muestra snackbar cuando no hay mascotas disponibles', (tester) async {
      await pumpBig(tester, buildWidget(auth: _userState, pets: _emptyPets));
      await tester.tap(find.text('Adoptar'));
      await tester.pumpAndSettle();
      expect(find.text('No hay mascotas disponibles para adopción'), findsOneWidget);
    });

    testWidgets('sin mascotas no se abre ningún AlertDialog', (tester) async {
      await pumpBig(tester, buildWidget(auth: _userState, pets: _emptyPets));
      await tester.tap(find.text('Adoptar'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  // ── Dialog de adopción — autenticado con mascotas ──────────────────────────

  group('DonationsScreen — adopción autenticado con mascotas', () {
    testWidgets('abre dialog de adopción', (tester) async {
      await pumpBig(tester, buildWidget(auth: _userState, pets: _withPets));
      await tester.tap(find.text('Adoptar'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('dialog muestra título de selección de mascota', (tester) async {
      await pumpBig(tester, buildWidget(auth: _userState, pets: _withPets));
      await tester.tap(find.text('Adoptar'));
      await tester.pumpAndSettle();
      expect(find.text('¿Qué mascota quieres adoptar?'), findsOneWidget);
    });

    testWidgets('dialog muestra la primera mascota seleccionada', (tester) async {
      await pumpBig(tester, buildWidget(auth: _userState, pets: _withPets));
      await tester.tap(find.text('Adoptar'));
      await tester.pumpAndSettle();
      expect(find.text('Rex'), findsOneWidget);
    });

    testWidgets('dialog muestra botón Solicitar adopción', (tester) async {
      await pumpBig(tester, buildWidget(auth: _userState, pets: _withPets));
      await tester.tap(find.text('Adoptar'));
      await tester.pumpAndSettle();
      expect(find.text('Solicitar adopción'), findsOneWidget);
    });

    testWidgets('dialog muestra botón Cancelar', (tester) async {
      await pumpBig(tester, buildWidget(auth: _userState, pets: _withPets));
      await tester.tap(find.text('Adoptar'));
      await tester.pumpAndSettle();
      expect(find.text('Cancelar'), findsOneWidget);
    });

    testWidgets('Cancelar cierra el dialog de adopción', (tester) async {
      await pumpBig(tester, buildWidget(auth: _userState, pets: _withPets));
      await tester.tap(find.text('Adoptar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('se puede cambiar la mascota en el dropdown', (tester) async {
      await pumpBig(tester, buildWidget(auth: _userState, pets: _withPets));
      await tester.tap(find.text('Adoptar'));
      await tester.pumpAndSettle();

      // abrimos el dropdown
      await tester.tap(find.text('Rex'));
      await tester.pumpAndSettle();

      // elegimos la segunda mascota
      await tester.tap(find.text('Luna').last);
      await tester.pumpAndSettle();

      expect(find.text('Luna'), findsOneWidget);
    });
  });
}