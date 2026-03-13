
import 'package:cafeconhuellas_front/presentation/screens/home_screen.dart';
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
       
  ],
);