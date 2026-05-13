
import 'package:cafeconhuellas_front/presentation/screens/donationFormScreen.dart';
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
import 'package:cafeconhuellas_front/presentation/screens/relationships_screen.dart';
import 'package:go_router/go_router.dart';

/// Main application router configuration.
///
/// This router manages all application navigation
/// using the `go_router` package.
///
/// It defines:
/// - public routes
/// - dynamic routes
/// - profile and panel routes
/// - adoption form navigation
///
/// Dynamic route examples:
/// - `/pets/:id`
/// - `/adopcion/formulario/:token`
final GoRouter appRouter = GoRouter(

  /// List of all application routes.
  routes: [

    /// Home screen route.
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),

    /// Pets listing screen route.
    GoRoute(
      path: '/pets',
      builder: (context, state) => const PetScreen(),
    ),

    /// Pet detail screen route.
    ///
    /// Receives:
    /// - [id] as a path parameter
    /// - optional [Pet] object through `state.extra`
    ///
    /// This allows the detail screen to load
    /// either from an already loaded pet instance
    /// or by using the pet identifier.
    GoRoute(
      path: '/pets/:id',
      builder: (context, state) {

        /// Extracts the pet ID from the URL.
        final id = state.pathParameters['id'];

        /// Converts the route parameter into an integer.
        final int petId =
            int.tryParse(id ?? '') ?? -1;

        /// Retrieves the optional pet object.
        final Pet? selectedPet =
            state.extra is Pet
                ? state.extra as Pet
                : null;

        return PetDetailScreen(
          petId: petId,
          pet: selectedPet,
        );
      },
    ),

    /// Information screen route.
    GoRoute(
      path: '/information',
      builder: (context, state) =>
          const InformationScreen(),
    ),

    /// Help and collaboration screen route.
    GoRoute(
      path: '/helpus',
      builder: (context, state) =>
          const HelpScreen(),
    ),

    /// Donations information screen route.
    GoRoute(
      path: '/donations',
      builder: (context, state) =>
          const DonationsScreen(),
    ),

    /// Events screen route.
    GoRoute(
      path: '/events',
      builder: (context, state) =>
          EventsScreen(),
    ),

    /// Contact screen route.
    GoRoute(
      path: '/contactus',
      builder: (context, state) =>
          const ContactusScreen(),
    ),

    /// Login screen route.
    GoRoute(
      path: '/login',
      builder: (context, state) =>
          const LoginPage(),
    ),

    /// User registration screen route.
    GoRoute(
      path: '/register',
      builder: (context, state) =>
          const RegisterScreen(),
    ),

    /// User profile screen route.
    GoRoute(
      path: '/profile',
      builder: (context, state) =>
          const ProfileScreen(),
    ),

    /// Administration panel route.
    GoRoute(
      path: '/panel',
      builder: (context, state) =>
          const PanelScreen(),
    ),

    /// User donations panel route.
    GoRoute(
      path: '/panel/donations',
      builder: (context, state) =>
          const MyDonationsScreen(),
    ),

    /// User relationships management route.
    GoRoute(
      path: '/panel/relationships',
      builder: (context, state) =>
          const RelationshipsScreen(),
    ),

    /// Adoption form route.
    ///
    /// Receives a secure token as a path parameter
    /// in order to identify the adoption process.
    GoRoute(
      path: '/adopcion/formulario/:token',
      builder: (context, state) {

        /// Extracts the adoption token.
        final token =
            state.pathParameters['token'] ?? '';

        return DonationFormScreen(token: token);
      },
    ),
  ],
);