
import 'package:cafeconhuellas_front/presentation/screens/donatios_screen.dart';
import 'package:cafeconhuellas_front/presentation/screens/panel_screen.dart';
import 'package:cafeconhuellas_front/presentation/screens/contactus.dart';
import 'package:cafeconhuellas_front/presentation/screens/donations.dart';
import 'package:cafeconhuellas_front/presentation/screens/events.dart';
import 'package:cafeconhuellas_front/presentation/screens/helpus_screen.dart';
import 'package:cafeconhuellas_front/presentation/screens/home_screen.dart';
import 'package:cafeconhuellas_front/presentation/screens/information_screen.dart';
import 'package:cafeconhuellas_front/presentation/screens/login_screen.dart';
import 'package:cafeconhuellas_front/presentation/screens/petdetail.dart';
import 'package:cafeconhuellas_front/presentation/screens/pets_screen.dart';
import 'package:cafeconhuellas_front/presentation/screens/profile_sreen.dart';
import 'package:cafeconhuellas_front/presentation/screens/register_screen.dart';
import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  routes: [
  
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      ),
  
    GoRoute(path: '/pets', builder: (context, state) => const PetScreen()),
    //aquí es super importante que hagamos esto ya que debemos pasarle la mascota y su id
    //para que la siguiente pantalla sepa que pantalla hacer con que exactamente
    //además es importante que hagamos el -1 porque sabemos q las listas empiezan en 0.

    GoRoute(
      path: '/pets/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        final int petId = int.tryParse(id ?? '') ?? -1;
        final Pet? selectedPet = state.extra is Pet ? state.extra as Pet : null;
        return PetDetailScreen(petId: petId, pet: selectedPet);
      },
    ),
    GoRoute(
      path: '/information',
      builder: (context, state) => const InformationScreen(),
    ),
    GoRoute(path: '/helpus', builder: (context, state) => const HelpScreen()),
    GoRoute(
      path: '/donations',
      builder: (context, state) => const DonationsScreen(),
    ),

    GoRoute(
      path: '/events',
      builder: (context, state) => EventsScreen(),
      ),
    GoRoute(
      path: '/contactus',
      builder: (context, state) => const ContactusScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute (path: '/panel', builder: (context, state) => const PanelScreen()),
    GoRoute (path: '/panel/donations', builder: (context, state) => const MyDonationsScreen()),
  ],
);
