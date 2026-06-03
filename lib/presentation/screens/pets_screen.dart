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

/// Purple color constant used throughout this screen.
const Color _purple = Color(0xFF7B3FE4);

/// Screen that displays the full list of available pets.
///
/// Regular users can:
/// - Filter pets by species.
/// - Filter pets by emergency status.
///
/// Admin users can additionally:
/// - Add new pets.
/// - Edit existing pets.
/// - Delete pets.
///
/// It also includes the application's shared
/// header and footer components.
class PetScreen extends StatelessWidget {
  const PetScreen({super.key});

  /// Opens a dialog to create a new pet.
  ///
  /// Dispatches [AddPet] to [PetsBloc] on confirmation.
  Future<void> _openAddDialog(BuildContext context) async {
    final Pet? result = await showDialog<Pet>(
      context: context,
      builder: (_) => const PetFormDialog(),
    );
    if (result != null && context.mounted) {
      context.read<PetsBloc>().add(AddPet(result));
    }
  }

  /// Opens a dialog to edit an existing pet.
  ///
  /// Dispatches [UpdatePet] to [PetsBloc] on confirmation.
  ///
  /// Parameters:
  /// - [pet]: The pet to be edited.
  Future<void> _openEditDialog(BuildContext context, Pet pet) async {
    final Pet? result = await showDialog<Pet>(
      context: context,
      builder: (_) => PetFormDialog(pet: pet),
    );
    if (result != null && context.mounted) {
      context.read<PetsBloc>().add(UpdatePet(result));
    }
  }

  /// Shows a confirmation dialog before deleting a pet.
  ///
  /// Dispatches [DeletePet] to [PetsBloc] on confirmation.
  ///
  /// Parameters:
  /// - [pet]: The pet to be deleted.
  Future<void> _confirmDelete(BuildContext context, Pet pet) async {
    /// Stores the dialog result:
    /// - true if the user confirms.
    /// - false if the user cancels.
    /// - null if the dialog is dismissed.
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Borrar mascota'),
        content: Text('¿Seguro que quieres borrar a ${pet.name}? Esta acción no se puede deshacer.'),
        actions: [
          /// Cancel button.
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          /// Confirm delete button.
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
    /// Dispatch delete event if the user confirmed.
    if (confirmed == true && context.mounted) {
      context.read<PetsBloc>().add(DeletePet(pet.id));
    }
  }

  /// Builds the pets screen UI.
  ///
  /// Layout structure:
  /// - Application header.
  /// - Banner image.
  /// - Filter controls and add button (admin only).
  /// - Responsive pet grid loaded from [PetsBloc].
  /// - Application footer.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PetsBloc(api: ApiConector())..add(LoadPets()),
      child: Scaffold(
        body: Column(
          children: [
            /// Shared application header.
            AppHeader(userImageUrl: "assets/user.png"),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        /// Main banner image.
                        Image.asset(
                          'assets/images/banners/banner-inicio.png',
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 24),

                        /// Filter controls and admin add button.
                        BlocBuilder<PetsBloc, PetsState>(
                          builder: (context, state) {
                            /// Read user role from [AuthBloc] to control admin-only buttons.
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
                                  /// Emergency filter toggle button.
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

                                  /// Species filter dropdown.
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

                                  /// Add pet button, visible to admin users only.
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

                  /// Responsive pet grid loaded from [PetsBloc].
                  ///
                  /// Column count and aspect ratio adapt to screen width.
                  /// Admin users see edit and delete buttons overlaid on each card.
                  BlocBuilder<PetsBloc, PetsState>(
                    builder: (context, state) {
                      /// Read user role to control admin action buttons.
                      final authState = context.read<AuthBloc>().state;
                      final bool isAdmin =
                          authState.user?.role.toUpperCase() == 'ADMIN';

                      final double width = MediaQuery.of(context).size.width;
                      final int crossAxisCount = width < 600 ? 2 : width < 1000 ? 3 : 4;
                      final double horizontalPadding = width < 700 ? 16.0 : width < 1100 ? 40.0 : 80.0;
                      /// Admin cards need extra height to accommodate action buttons.
                      final double childAspectRatio = isAdmin
                          ? (width < 600 ? 0.58 : width < 1000 ? 0.65 : 0.72)
                          : (width < 600 ? 0.66 : width < 1000 ? 0.74 : 0.82);

                      /// Loading state.
                      if (state.isLoading) {
                        return const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(child: CircularProgressIndicator(color: _purple)),
                          ),
                        );
                      }

                      /// Error state.
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
                              /// Admin view: pet card with overlaid edit and delete buttons.
                              if (isAdmin) {
                                return Stack(
                                  children: [
                                    /// Regular pet card.
                                    PetCard(pet),
                                    /// Admin action buttons positioned on top right.
                                    Positioned(
                                      top: 6,
                                      right: 6,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          /// Edit button.
                                          _adminActionButton(
                                            icon: Icons.edit_rounded,
                                            color: _purple,
                                            tooltip: 'Editar',
                                            onTap: () => _openEditDialog(context, pet),
                                          ),
                                          const SizedBox(width: 4),
                                          /// Delete button.
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

                              /// Regular user view: pet card without action buttons.
                              return PetCard(pet);
                            },
                            childCount: state.pets.length,
                          ),
                        ),
                      );
                    },
                  ),

                  /// Shared application footer at the bottom of the scroll.
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

  /// Creates a small circular action button used on admin pet cards.
  ///
  /// Parameters:
  /// - [icon]: Icon to display inside the button.
  /// - [color]: Background color of the button.
  /// - [tooltip]: Tooltip message shown on long press.
  /// - [onTap]: Callback triggered when the button is tapped.
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