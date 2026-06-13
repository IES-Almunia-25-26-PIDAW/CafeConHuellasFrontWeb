import 'package:cafeconhuellas_front/models/adoption_form.dart';
import 'package:cafeconhuellas_front/models/user_pet_relationship.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_event.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_state.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:cafeconhuellas_front/utils/api_conector.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

const Color _purple = Color(0xFF7B3FE4);

/// Main screen that displays user-pet relationships and adoption requests.
///
/// This screen handles:
/// - Displaying pet-user relationships.
/// - Displaying adoption requests.
/// - Role-based access (ADMIN vs USER).
/// - Authentication validation.
/// - Automatic data loading using BLoC events.
/// - Redirecting unauthenticated users to login.
///
/// ADMIN users can manage all data, while regular users only see their own.
class RelationshipsScreen extends StatelessWidget {
  const RelationshipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final bool isAdmin = authState.user?.role.toUpperCase() == 'ADMIN';
    final int? userId = authState.user?.id;

    /// If user is not authenticated, show login prompt screen
    if (!authState.isAuthenticated || authState.user == null) {
      return Scaffold(
        body: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock_outline, size: 64, color: _purple),
                    const SizedBox(height: 16),
                    const Text(
                      '¡Necesitas iniciar sesión!',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'MilkyVintage',
                        color: _purple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Inicia sesión o regístrate para ver tus solicitudes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _purple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () => context.go('/login'),
                      icon: const Icon(Icons.login),
                      label: const Text('Iniciar sesión'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    /// Trigger BLoC events after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isAdmin) {
        context.read<PetsBloc>().add(LoadAdoptionRequests());
        context.read<PetsBloc>().add(LoadPetUserRelations());
      } else {
        context.read<PetsBloc>().add(LoadMyAdoptionRequests());
        context.read<PetsBloc>().add(LoadMyPetUserRelations(userId ?? 0));
      }
    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            const AppHeader(),
            Image.asset(
              'assets/images/banners/banner-inicio.png',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              isAdmin ? 'Gestionar solicitudes' : 'Mis solicitudes',
              style: const TextStyle(
                fontSize: 32,
                fontFamily: 'MilkyVintage',
                color: _purple,
              ),
            ),
            const SizedBox(height: 16),
            const TabBar(
              labelColor: _purple,
              unselectedLabelColor: Colors.grey,
              indicatorColor: _purple,
              tabs: [
                Tab(text: 'Relaciones'),
                Tab(text: 'Solicitudes de adopción'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _RelacionesTab(isAdmin: isAdmin),
                  _AdopcionesTab(isAdmin: isAdmin),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tab that displays user-pet relationships.
///
/// Admin users can:
/// - View all relationships.
/// - Activate or deactivate relationships.
///
/// Regular users can:
/// - Only view their own relationships.
class _RelacionesTab extends StatelessWidget {
  final bool isAdmin;
  const _RelacionesTab({required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetsBloc, PetsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator(color: _purple));
        }

        if (state.errorMessage != null) {
          return Center(
            child: Text(
              state.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        final relations = state.relations;
        if (relations.isEmpty) {
          return const Center(child: Text('No se encontraron relaciones.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: relations.length,
          itemBuilder: (context, index) {
            final r = relations[index];
            return _RelationCard(
              relation: r,
              isAdmin: isAdmin,
              onToggleActive: isAdmin
                  ? () async {
                      final updated = Userpetrelationship(
                        id: r.id,
                        userId: r.userId,
                        petId: r.petId,
                        relationshipType: r.relationshipType,
                        startDate: r.startDate,
                        endDate: r.endDate,
                        active: !r.active,
                      );
                      final messenger = ScaffoldMessenger.of(context);
                      final petsBloc = context.read<PetsBloc>();
                      try {
                        await ApiConector().updateRelationshipStatus(
                          r.id,
                          updated,
                        );
                        petsBloc.add(LoadPetUserRelations());
                      } catch (e) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  : null,
            );
          },
        );
      },
    );
  }
}

/// Card widget that represents a user-pet relationship.
///
/// Displays:
/// - Relationship type
/// - Start and end dates
/// - Status (active/pending)
/// - User ID (admin only)
///
/// Admins can toggle activation using a switch.
class _RelationCard extends StatelessWidget {
  final Userpetrelationship relation;
  final bool isAdmin;
  final VoidCallback? onToggleActive;

  const _RelationCard({
    required this.relation,
    required this.isAdmin,
    this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    final color = relation.active ? Colors.green : Colors.orange;
    final label = relation.active ? 'Activa' : 'Pendiente de revisión';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: _purple,
            child: Icon(Icons.pets, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  relation.relationshipType,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'MilkyVintage',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Desde: ${_fmt(relation.startDate)}'
                  '${relation.endDate != null ? ' → ${_fmt(relation.endDate!)}' : ''}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                if (isAdmin)
                  Text(
                    'ID de usuario: ${relation.userId}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isAdmin)
            Switch(
              value: relation.active,
              activeThumbColor: _purple,
              onChanged: onToggleActive != null
                  ? (_) => onToggleActive!()
                  : null,
            ),
        ],
      ),
    );
  }

  /// Formats a date as dd/MM/yyyy
  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year}';
}

/// Tab that displays adoption requests.
///
/// Admin users can:
/// - Approve, reject, or reset requests.
///
/// Regular users can:
/// - Only view their own requests.
class _AdopcionesTab extends StatelessWidget {
  final bool isAdmin;
  const _AdopcionesTab({required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetsBloc, PetsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator(color: _purple));
        }

        if (state.errorMessage != null) {
          return Center(
            child: Text(
              state.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final requests = state.adoptionRequests;

        if (requests.isEmpty) {
          return const Center(child: Text('No se encontraron solicitudes de adopción.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            return _AdoptionCard(request: requests[index], isAdmin: isAdmin);
          },
        );
      },
    );
  }
}

/// Card widget that displays an adoption request.
///
/// Shows detailed information:
/// - Pet and user info
/// - Address and city
/// - Housing type
/// - Adoption reason
/// - Lifestyle indicators
/// - Current status
///
/// Admins can approve, reject, or reset the request status.
class _AdoptionCard extends StatelessWidget {
  final AdoptionRequest request;
  final bool isAdmin;

  const _AdoptionCard({required this.request, required this.isAdmin});

  Future<void> _cambiarStatus(BuildContext context, String nuevoStatus) async {
    final messenger = ScaffoldMessenger.of(context);
    final bloc = context.read<PetsBloc>();

    try {
      await ApiConector().updateAdoptionStatus(request.id, nuevoStatus);

      bloc.add(LoadAdoptionRequests());
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = request.status == 'APROBADO'
        ? Colors.green
        : request.status == 'RECHAZADO'
        ? Colors.red
        : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: _purple,
                child: Icon(Icons.description, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.petName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'MilkyVintage',
                      ),
                    ),
                    Text(
                      request.userName,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  request.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          _row('Ciudad', request.city),
          _row('Dirección', request.address),
          _row('Tipo de vivienda', request.housingType),
          _row('Horas sola al día', '${request.hoursAlonePerDay}h'),
          _row('Motivo', request.reasonForAdoption),

          const SizedBox(height: 6),

          Wrap(
            spacing: 8,
            children: [
              _chip('Jardín', request.hasGarden),
              _chip('Otros animales', request.hasOtherPets),
              _chip('Niños', request.hasChildren),
              _chip('Experiencia', request.experienceWithPets),
              _chip('Seguimiento', request.agreesToFollowUp),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            'Enviada: ${request.submittedAt.day.toString().padLeft(2, '0')}/'
            '${request.submittedAt.month.toString().padLeft(2, '0')}/'
            '${request.submittedAt.year}',
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),

          if (isAdmin) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (request.status != 'PENDIENTE')
                  TextButton(
                    onPressed: () => _cambiarStatus(context, 'PENDIENTE'),
                    child: const Text(
                      'Pendiente',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                if (request.status != 'APROBADA')
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _cambiarStatus(context, 'APROBADA'),
                    child: const Text('Aprobar'),
                  ),
                const SizedBox(width: 8),
                if (request.status != 'DENEGADA')
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _cambiarStatus(context, 'DENEGADA'),
                    child: const Text('Rechazar'),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, bool value) {
    final color = value ? Colors.green : Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        '${value ? '✓' : '✗'} $label',
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
