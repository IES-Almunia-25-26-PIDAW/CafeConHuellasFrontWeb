// test/screens/my_donations_test.dart
import 'package:cafeconhuellas_front/models/donation.dart';
import 'package:cafeconhuellas_front/models/user.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_state.dart';
import 'package:cafeconhuellas_front/presentation/screens/donatios_screen.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApi extends Mock implements ApiConector {}

class FakeAuthBloc extends AuthBloc {
  final AuthState _fakeState;
  FakeAuthBloc(this._fakeState) : super(MockApi());
  @override
  AuthState get state => _fakeState;
}

AuthState userState() => AuthState(
  token: 'tok', isLoading: false,
  user: UserWithoutPassword(
    id: 1, firstName: 'Ana', lastName1: '', lastName2: '',
    email: '', phone: '', role: 'USER', imageUrl: '',
  ),
);

AuthState adminState() => AuthState(
  token: 'tok', isLoading: false,
  user: UserWithoutPassword(
    id: 2, firstName: 'Admin', lastName1: '', lastName2: '',
    email: '', phone: '', role: 'ADMIN', imageUrl: '',
  ),
);

final _fakeDonation = Donation(
  id: 1, userId: 1, amount: 50,
  category: 'MONETARIA', method: 'BIZUM',
  notes: 'Test note', date: DateTime(2024, 6, 1),
);

Widget buildWidget(AuthState authState, MockApi api) => MaterialApp(
  home: BlocProvider<AuthBloc>(
    create: (_) => FakeAuthBloc(authState),
    child: MyDonationsScreen(),
  ),
);

Future<void> pumpBig(WidgetTester tester, Widget widget) async {
  tester.view.physicalSize = const Size(1400, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(widget);
  await tester.pumpAndSettle();
}

void main() {
  late MockApi mockApi;

  setUp(() => mockApi = MockApi());

  group('MyDonationsScreen — usuario', () {
    testWidgets('muestra título Mis Donaciones', (tester) async {
      when(() => mockApi.getMeDonation()).thenAnswer((_) async => []);
      await pumpBig(tester, buildWidget(userState(), mockApi));
      expect(find.text('Mis Donaciones'), findsOneWidget);
    });

    testWidgets('muestra mensaje vacío si no hay donaciones', (tester) async {
      when(() => mockApi.getMeDonation()).thenAnswer((_) async => []);
      await pumpBig(tester, buildWidget(userState(), mockApi));
      expect(find.text('No hay donaciones disponibles.'), findsOneWidget);
    });

    testWidgets('muestra donación cuando hay datos', (tester) async {
      when(() => mockApi.getMeDonation())
          .thenAnswer((_) async => [_fakeDonation]);
      await pumpBig(tester, buildWidget(userState(), mockApi));
      expect(find.textContaining('50'), findsOneWidget);
      expect(find.textContaining('MONETARIA'), findsOneWidget);
      expect(find.textContaining('BIZUM'), findsOneWidget);
    });

    testWidgets('muestra nota de la donación si existe', (tester) async {
      when(() => mockApi.getMeDonation())
          .thenAnswer((_) async => [_fakeDonation]);
      await pumpBig(tester, buildWidget(userState(), mockApi));
      expect(find.text('Test note'), findsOneWidget);
    });

    testWidgets('muestra fecha de la donación formateada', (tester) async {
      when(() => mockApi.getMeDonation())
          .thenAnswer((_) async => [_fakeDonation]);
      await pumpBig(tester, buildWidget(userState(), mockApi));
      expect(find.textContaining('01/06/2024'), findsOneWidget);
    });
  });

  group('MyDonationsScreen — admin', () {
    testWidgets('muestra título Todas las Donaciones', (tester) async {
      when(() => mockApi.getDonations()).thenAnswer((_) async => []);
      await pumpBig(tester, buildWidget(adminState(), mockApi));
      expect(find.text('Todas las Donaciones'), findsOneWidget);
    });

    testWidgets('llama a getDonations en vez de getMeDonation', (tester) async {
      when(() => mockApi.getDonations())
          .thenAnswer((_) async => [_fakeDonation]);
      await pumpBig(tester, buildWidget(adminState(), mockApi));
      verify(() => mockApi.getDonations()).called(1);
      verifyNever(() => mockApi.getMeDonation());
    });
  });

  group('MyDonationsScreen — error', () {
    testWidgets('muestra error si la API falla', (tester) async {
      when(() => mockApi.getMeDonation()).thenThrow(Exception('sin red'));
      await pumpBig(tester, buildWidget(userState(), mockApi));
      expect(find.textContaining('Error'), findsOneWidget);
    });
  });
}