
import 'package:cafeconhuellas_front/presentation/screens/donations.dart';
import 'package:cafeconhuellas_front/presentation/screens/events.dart';
import 'package:cafeconhuellas_front/presentation/screens/helpus_screen.dart';
import 'package:cafeconhuellas_front/presentation/screens/home_screen.dart';
import 'package:cafeconhuellas_front/presentation/screens/information_screen.dart';
import 'package:cafeconhuellas_front/presentation/screens/petdetail.dart';
import 'package:cafeconhuellas_front/presentation/screens/pets_screen.dart';
import 'package:cafeconhuellas_front/utils/globals.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(randomPets: Globals.pets),
    ),
    GoRoute(
      path: '/pets',
      builder: (context, state) => const PetScreen(),
    ),
      GoRoute(
      path: '/pets/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return PetDetailScreen(petId: int.parse(id!), petsList: Globals.pets);
      },
    ),
    GoRoute(path: '/information', builder: (context, state) => const InformationScreen()),
    GoRoute(path: '/helpus', builder: (context, state) => const HelpScreen()),
    GoRoute(path: '/donations', builder: (context, state) => const DonationsScreen()),
    GoRoute(path: '/events', builder: (context, state) => const EventsScreen()),
  ],
);