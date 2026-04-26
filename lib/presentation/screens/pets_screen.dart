import 'package:cafeconhuellas_front/models/pet.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_event.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_state.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:cafeconhuellas_front/presentation/widgets/petcard.dart';
import 'package:cafeconhuellas_front/presentation/widgets/petformdialog.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const Color _purple = Color(0xFF7B3FE4);

class PetScreen extends StatelessWidget {
  const PetScreen({super.key});

  //vamos a añadir una mascota y si el usuario confirmar lanzar el evento add pet
  Future<void> _openAddDialog(BuildContext context) async {
    final Pet? result = await showDialog<Pet>(
      context: context,
      builder: (_) => const PetFormDialog(),
    );
    if (result != null && context.mounted) {
      context.read<PetsBloc>().add(AddPet(result));
    }
  }

  //Helper que Abre el formulario de editar con los datos de pet y si confirma lanza update pet
  Future<void> _openEditDialog(BuildContext context, Pet pet) async {
    final Pet? result = await showDialog<Pet>(
      context: context,
      builder: (_) => PetFormDialog(pet: pet),
    );
    if (result != null && context.mounted) {
      context.read<PetsBloc>().add(UpdatePet(result));
    }
  }

  // Helper para mostrar el diálogo de confirmación de eliminación, si confirma lanza el evento de eliminar mascota
  Future<void> _confirmDelete(BuildContext context, Pet pet) async {
    //guardamos el resultado del diálogo, que será true si el usuario confirma, false si cancela o null si cierra el diálogo de otra forma
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Borrar mascota'),
        content: Text('¿Seguro que quieres borrar a ${pet.name}? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Borrar'),
          ),
        ],
      ),
    );
    //si el usuario ha confirmado la eliminación, lanzamos el evento para eliminar la mascota
    if (confirmed == true && context.mounted) {
      context.read<PetsBloc>().add(DeletePet(pet.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PetsBloc(api: ApiConector())..add(LoadPets()),
      child: Scaffold(
        body: Column(
          children: [
            AppHeader(userImageUrl: "assets/user.png"),

            // Usamos un CustomScrollView para que el header y el banner también hagan scroll
            Expanded(
              child: CustomScrollView(
                slivers: [

                  // Banner e Imagen
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/banners/banner-inicio.png',
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 24),

                        /// CONTROLES: filtros + botones admin, todo centrado
                        BlocBuilder<PetsBloc, PetsState>(
                          builder: (context, state) {
                            //leemos el rol del usuario del AuthBloc para mostrar el botón de añadir mascota solo a los admin
                            final authState = context.watch<AuthBloc>().state;
                            final bool isAdmin =
                                authState.user?.role.toUpperCase() == 'ADMIN';

                            return Center(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 12,
                                runSpacing: 12,
                                children: [

                                  // botón emergencia
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: state.isEmergencyActive
                                          ? _purple
                                          : Colors.purple[100],
                                      foregroundColor: state.isEmergencyActive
                                          ? Colors.white
                                          : _purple,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () => context.read<PetsBloc>().add(ToggleEmergency()),
                                    icon: const Icon(Icons.warning_amber_rounded),
                                    label: const Text("Emergencia"),
                                  ),

                                  // dropdown especie
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.purple[50],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.purple[200]!),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: state.selectedSpecies.isEmpty ? "" : state.selectedSpecies,
                                        icon: const Icon(Icons.arrow_drop_down, color: _purple),
                                        items: const [
                                          DropdownMenuItem(value: "", child: Text("Todas las especies")),
                                          DropdownMenuItem(value: "Perro", child: Text("Perro")),
                                          DropdownMenuItem(value: "Gato", child: Text("Gato")),
                                        ],
                                        onChanged: (value) {
                                          context.read<PetsBloc>().add(FilterSpecies(value ?? ""));
                                        },
                                      ),
                                    ),
                                  ),

                                  // botón añadir — solo si es ADMIN
                                  if (isAdmin)
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _purple,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () => _openAddDialog(context),
                                      icon: const Icon(Icons.add),
                                      label: const Text('Añadir mascota'),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),

                  /// GRID DE MASCOTAS
                  BlocBuilder<PetsBloc, PetsState>(
                    builder: (context, state) {
                      // leemos el rol también aquí para los botones de editar/borrar
                      final authState = context.read<AuthBloc>().state;
                      final bool isAdmin =
                          authState.user?.role.toUpperCase() == 'ADMIN';

                      final double width = MediaQuery.of(context).size.width;
                      final int crossAxisCount = width < 600 ? 2 : width < 1000 ? 3 : 4;
                      final double horizontalPadding = width < 700 ? 16.0 : width < 1100 ? 40.0 : 80.0;
                      // si es admin dejamos un poco más de altura para los botones de acción
                      final double childAspectRatio = isAdmin
                          ? (width < 600 ? 0.58 : width < 1000 ? 0.65 : 0.72)
                          : (width < 600 ? 0.66 : width < 1000 ? 0.74 : 0.82);

                      // cargando
                      if (state.isLoading) {
                        return const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(child: CircularProgressIndicator(color: _purple)),
                          ),
                        );
                      }

                      // error
                      if (state.errorMessage != null) {
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(state.errorMessage!, style: const TextStyle(color: Colors.red)),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
                        sliver: SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            childAspectRatio: childAspectRatio,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final pet = state.pets[index];

                              // Si es admin envolvemos la PetCard con los botones de acción
                              if (isAdmin) {
                                return Stack(
                                  children: [
                                    // la tarjeta normal
                                    PetCard(pet),

                                    // botones flotantes en la esquina superior derecha
                                    Positioned(
                                      top: 6,
                                      right: 6,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Editar
                                          _adminActionButton(
                                            icon: Icons.edit_rounded,
                                            color: _purple,
                                            tooltip: 'Editar',
                                            onTap: () => _openEditDialog(context, pet),
                                          ),
                                          const SizedBox(width: 4),
                                          // Borrar
                                          _adminActionButton(
                                            icon: Icons.delete_rounded,
                                            color: Colors.redAccent,
                                            tooltip: 'Borrar',
                                            onTap: () => _confirmDelete(context, pet),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }

                              // Usuario normal: tarjeta sin botones
                              return PetCard(pet);
                            },
                            childCount: state.pets.length,
                          ),
                        ),
                      );
                    },
                  ),

                  // Footer al final del scroll
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        AppFooter(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Pequeño botón circular para las acciones de admin sobre cada tarjeta
  Widget _adminActionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: CircleAvatar(
          radius: 16,
          backgroundColor: color,
          child: Icon(icon, size: 16, color: Colors.white),
        ),
      ),
    );
  }
}