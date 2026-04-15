import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../bloc/auth_event.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {

          // Si hay token, estamos autenticados, aunque falten datos del usuario
          if (!state.isAuthenticated) {
            return const Center(child: Text("No has iniciado sesión"));
          }

          // cogemos el usuario del estado del bloc
          final user = state.user;

          return SingleChildScrollView(
            child: Column(
              children: [

                AppHeader(),

                // HEADER BONITO CON EL AVATAR FLOTANTE
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [

                    // Banner
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/banners/banner-inicio.png",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Avatar flotante para que se vea bonito
                    Positioned(
                      bottom: -50,
                      child: CircleAvatar(
                        radius: 62,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 56,
                          backgroundImage: user != null &&
                                  user.imageUrl.isNotEmpty
                              ? NetworkImage(user.imageUrl)
                              : const AssetImage("assets/user.png")
                                  as ImageProvider,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // CONTENIDO
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),

                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            children: [
                              //si hemos podido obtener los datos del usuario, los mostramos en modo de tarjetita abajo para que se vea mas bonito
                              if (user != null) ...[
                                Text(
                                  "${user.firstName} ${user.lastName1}",
                                  style: const TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "MilkyVintage"
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.grey[600],
                                    fontFamily: "MilkyVintage"
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Divider(),
                                const SizedBox(height: 10),
                                // TARJETITAS BONITAS
                                _infoCard(Icons.phone, "Teléfono", user.phone),
                                _infoCard(Icons.badge, "Rol", user.role),
                              ]

                              // si no hemos podido obtener los datos del usuario mostramos loading
                              else ...[
                                const Text(
                                  "Sesión Activa",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                const Text(
                                  "Cargando datos del usuario...",
                                  style: TextStyle(color: Colors.grey),
                                ),

                                const SizedBox(height: 20),

                                CircularProgressIndicator(
                                  color: Colors.purple,
                                ),
                              ],

                              const SizedBox(height: 30),

                              // botón logout
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  context
                                      .read<AuthBloc>()
                                      .add(LogoutRequested());
                                  context.go('/');
                                },
                                icon: const Icon(Icons.logout),
                                label: const Text("Cerrar Sesión"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const AppFooter(),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget más bonito tipo card para mostrar la información del usuario, con un icono a la izquierda, el label y el valor, todo dentro de una caja con fondo gris claro y bordes redondeados.
  Widget _infoCard(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}