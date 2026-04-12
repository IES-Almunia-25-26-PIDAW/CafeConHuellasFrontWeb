import 'package:cafeconhuellas_front/presentation/bloc/pet_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_event.dart';
import 'package:cafeconhuellas_front/presentation/screens/contactus.dart';
import 'package:cafeconhuellas_front/presentation/screens/donations.dart';
import 'package:cafeconhuellas_front/presentation/screens/events.dart';
import 'package:cafeconhuellas_front/presentation/screens/helpus_screen.dart';
import 'package:cafeconhuellas_front/presentation/screens/home_screen.dart';
import 'package:cafeconhuellas_front/presentation/screens/information_screen.dart';
import 'package:cafeconhuellas_front/presentation/screens/login_screen.dart';
import 'package:cafeconhuellas_front/presentation/screens/petdetail.dart';
import 'package:cafeconhuellas_front/presentation/screens/pets_screen.dart';
import 'package:cafeconhuellas_front/presentation/screens/register_screen.dart';
import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    //Como en está ruta cargamos las mascotas tenemos que hacer un builder con 
    // el bloc provider, ya que hay que cargar el bloc anteriormente para poder mostrar las mascotas en la pantalla de inicio
    GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (_) => PetsBloc()
          ..add(LoadPets())
          ..add(LoadEvents()),
        child: const HomeScreen(),
      ),
    ),
    //como ya se ha cargado el bloc en la pantalla de inicio, no es necesario cargarlo de nuevo en la pantalla de mascotas, ya que el bloc se mantiene vivo mientras la aplicación esté abierta, por lo que podemos acceder a él desde cualquier pantalla sin necesidad de cargarlo de nuevo
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
    //pasa lo mismo que con las mascotas, hay que cargarlos antes de mostrar la pantalla de eventos, aunque no se usen en la pantalla de mascotas, ya que si no se cargan no se mostrarán en la pantalla de eventos
    GoRoute(
      path: '/events',
      builder: (context, state) => BlocProvider(
        create: (_) => PetsBloc()..add(LoadEvents()),
        child: const EventsScreen(),
      ),
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
  ],
);
