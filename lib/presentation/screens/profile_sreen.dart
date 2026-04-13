import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../bloc/auth_event.dart';
import '../widgets/app_header.dart';

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
          //cogemos el usuario del estado del bloc 
          final user = state.user;

          return Column(
            children: [
              // Usamos la imagen del usuario real en el header o fallback
              AppHeader(
                userImageUrl: user?.imageUrl.isNotEmpty == true
                    ? user!.imageUrl
                    : "assets/user.png",
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              //si hemos podido obttener los datos del usuario mostramos la imagen del usuario en modo circular, si no tiene imagen mostramos una imagen por defecto
                              if (user != null) ...[                              
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage: user.imageUrl.isNotEmpty
                                      ? NetworkImage(user.imageUrl)
                                      : const AssetImage("assets/user.png") as ImageProvider,
                                ),
                                const SizedBox(height: 20),
                                //mostramos el nombre completo del usuario y su email, si el usuario es null mostramos un mensaje de carga
                                Text(
                                  "${user.firstName} ${user.lastName1}",
                                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                                ),
                                Text(user.email, style: TextStyle(color: Colors.grey[600])),
                                const Divider(height: 40),
                                _infoRow(Icons.phone, "Teléfono", user.phone),
                                _infoRow(Icons.badge, "Rol", user.role),
                                //si no hemos podido obtener los datos del usuario mostramos una imagen y una imagen de carga diciendo que nos
                                //hemos autentificado pero no hemos podido cargar los datos del usuario
                              ] else
                                Column(
                                  children: [
                                    const CircleAvatar(
                                      radius: 60,
                                      backgroundImage: AssetImage("assets/user.png"),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      "Sesión Activa",
                                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                                    ),
                                    const Text("Cargando datos del usuario...", style: TextStyle(color: Colors.grey)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: CircularProgressIndicator(color: Colors.purple[300]),
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 40),
                              // ponemos la opción de cerrar sesión e intentarlo con otro usuario
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                                onPressed: () {
                                  context.read<AuthBloc>().add(LogoutRequested());
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
              ),
            ],
          );
        },
      ),
    );
  }
  //para q se vea mas bonito
  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple[300]),
          const SizedBox(width: 15),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}