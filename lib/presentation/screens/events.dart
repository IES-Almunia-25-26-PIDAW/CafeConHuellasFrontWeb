import 'package:cafeconhuellas_front/models/event.dart';
import 'package:cafeconhuellas_front/presentation/bloc/auth_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_bloc.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_event.dart';
import 'package:cafeconhuellas_front/presentation/bloc/pet_state.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:cafeconhuellas_front/presentation/widgets/eventformdialog.dart';
import 'package:cafeconhuellas_front/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Screen that displays active and past events.
///
/// Admin users can:
/// - Add new events.
/// - Edit existing events.
/// - Delete events.
///
/// It also includes the application's shared
/// header and footer components.
class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  /// Fixed width used for event cards.
  static const double _cardWidth = 300;

  /// Fixed height used for event card images.
  static const double _cardHeight = 200;

  /// Maximum width for past event info cards.
  static const double _pastInfoCardWidth = 460;

  /// Opens a dialog to create a new event.
  ///
  /// Dispatches [AddEvent] to [PetsBloc] on confirmation.
  Future<void> _openAddEventDialog(BuildContext context) async {
    final Event? result = await showDialog<Event>(
      context: context,
      builder: (_) => const EventFormDialog(),
    );
    if (result != null && context.mounted) {
      context.read<PetsBloc>().add(AddEvent(result));
    }
  }

  /// Opens a dialog to edit an existing event.
  ///
  /// Dispatches [UpdateEvent] to [PetsBloc] on confirmation.
  ///
  /// Parameters:
  /// - [event]: The event to be edited.
  Future<void> _openEditEventDialog(BuildContext context, Event event) async {
    final Event? result = await showDialog<Event>(
      context: context,
      builder: (_) => EventFormDialog(event: event),
    );
    if (result != null && context.mounted) {
      context.read<PetsBloc>().add(UpdateEvent(result));
    }
  }

  /// Shows a confirmation dialog before deleting an event.
  ///
  /// Dispatches [DeleteEvent] to [PetsBloc] on confirmation.
  ///
  /// Parameters:
  /// - [event]: The event to be deleted.
  Future<void> _confirmDelete(BuildContext context, Event event) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Borrar evento'),
        content: Text('¿Seguro que quieres borrar "${event.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Borrar'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<PetsBloc>().add(DeleteEvent(event.id));
    }
  }

  /// Renders an event image from either a network URL or a local asset.
  ///
  /// Falls back to a placeholder icon if the image fails to load.
  Widget _eventImage(String imagePath, {double? width, double? height}) {
    final isNetwork = imagePath.startsWith('http://') || imagePath.startsWith('https://');
    final placeholder = Container(
      width: width, height: height,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
    if (isNetwork) {
      return Image.network(imagePath, width: width, height: height, fit: BoxFit.cover,
          errorBuilder: (_, _, _) => placeholder);
    }
    return Image.asset(imagePath, width: width, height: height, fit: BoxFit.cover,
        errorBuilder: (_, _, _) => placeholder);
  }

  /// Builds the events screen UI.
  ///
  /// Layout structure:
  /// - Application header.
  /// - Banner image.
  /// - Loading indicator or error message.
  /// - Add event button (admin only).
  /// - Active events section.
  /// - Past events section.
  /// - Application footer.
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final bool isAdmin = authState.user?.role.toUpperCase() == 'ADMIN';

    return BlocBuilder<PetsBloc, PetsState>(
      builder: (context, state) {
        final DateTime now = DateTime.now();
        /// Events with a future date.
        final List<Event> activeEvents =
            state.events.where((e) => e.eventdate.isAfter(now)).toList();
        /// Events with a past date.
        final List<Event> pastEvents =
            state.events.where((e) => e.eventdate.isBefore(now)).toList();

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                /// Shared application header.
                const AppHeader(),
                /// Main banner image.
                Image.asset('assets/images/banners/banner-inicio.png',
                    width: double.infinity, height: 400, fit: BoxFit.cover),
                const SizedBox(height: 40),

                /// Loading indicator.
                if (state.isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: CircularProgressIndicator(color: Color(0xFF7B3FE4)),
                  ),

                /// Error message.
                if (!state.isLoading && state.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text(state.errorMessage!, style: const TextStyle(color: Colors.red)),
                  ),

                /// Add event button, visible to admin users only.
                if (isAdmin)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B3FE4),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => _openAddEventDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Añadir Evento'),
                    ),
                  ),

                const SizedBox(height: 40),

                /// Active events section.
                _title('Eventos Activos'),
                if (activeEvents.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('No hay eventos activos por fecha.'),
                  )
                else
                  Wrap(
                    spacing: 30,
                    runSpacing: 30,
                    alignment: WrapAlignment.center,
                    children: activeEvents
                        .map((e) => _activeEventCard(context, e, isAdmin))
                        .toList(),
                  ),

                const SizedBox(height: 80),

                /// Past events section.
                _title('Eventos Pasados'),
                if (pastEvents.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('No hay eventos pasados por fecha.'),
                  )
                else
                  Column(
                    children: pastEvents
                        .map((e) => _pastEventRow(context, e, isAdmin))
                        .toList(),
                  ),

                const SizedBox(height: 80),
                /// Shared application footer.
                const AppFooter(),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Creates a styled section title.
  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 38,
          fontFamily: 'WinkyMilky',
          color: AppColors.darkViolet,
        ),
      ),
    );
  }

  /// Creates a card for an active event with full description.
  ///
  /// Admin users see edit and delete icon buttons overlaid on the image.
  ///
  /// Parameters:
  /// - [event]: The event to display.
  /// - [isAdmin]: Whether the current user has admin privileges.
  Widget _activeEventCard(BuildContext context, Event event, bool isAdmin) {
    return SizedBox(
      width: _cardWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Event image with optional admin action buttons.
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _eventImage(event.imageUrl, height: _cardHeight, width: _cardWidth),
              ),
              if (isAdmin)
                Positioned(
                  top: 6, right: 6,
                  child: Row(
                    children: [
                      /// Edit button.
                      _iconBtn(Icons.edit, const Color(0xFF7B3FE4), () => _openEditEventDialog(context, event)),
                      const SizedBox(width: 4),
                      /// Delete button.
                      _iconBtn(Icons.delete, Colors.redAccent, () => _confirmDelete(context, event)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          /// Event name.
          Text(event.name,
              style: const TextStyle(fontSize: 22, fontFamily: 'MilkyVintage')),
          const SizedBox(height: 6),
          /// Event date and time.
          Row(children: [
            const Icon(Icons.calendar_today, size: 14, color: Color(0xFF7B3FE4)),
            const SizedBox(width: 4),
            Text(
              "${event.eventdate.day.toString().padLeft(2,'0')}/${event.eventdate.month.toString().padLeft(2,'0')}/${event.eventdate.year}  "
              "${event.eventdate.hour.toString().padLeft(2,'0')}:${event.eventdate.minute.toString().padLeft(2,'0')}",
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ]),
          /// Event location (if available).
          if (event.location.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.location_on, size: 14, color: Color(0xFF7B3FE4)),
              const SizedBox(width: 4),
              Expanded(child: Text(event.location, style: const TextStyle(fontSize: 13))),
            ]),
          ],
          const SizedBox(height: 8),
          /// Event type, status and capacity badges.
          Wrap(spacing: 6, children: [
            _badge(event.eventType, Colors.blue),
            _badge(event.status, event.status == 'FINALIZADO' || event.status == 'CANCELADO' ? Colors.grey : Colors.green),
            _badge('👥 ${event.maxCapacity}', Colors.grey),
          ]),
          const SizedBox(height: 10),
          /// Full event description.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cream),
              color: Colors.white,
            ),
            child: Text(
              event.description,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a horizontal row layout for a past event with full description.
  ///
  /// Admin users see edit and delete icon buttons next to the title.
  ///
  /// Parameters:
  /// - [event]: The event to display.
  /// - [isAdmin]: Whether the current user has admin privileges.
  Widget _pastEventRow(BuildContext context, Event event, bool isAdmin) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Wrap(
        spacing: 30,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: [
          /// Event image.
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _eventImage(event.imageUrl, width: _cardWidth, height: _cardHeight),
          ),
          /// Event info card without fixed height.
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _pastInfoCardWidth, minWidth: 200),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cream),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Event title with optional admin action buttons.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(event.name,
                            style: const TextStyle(fontSize: 22, fontFamily: 'MilkyVintage')),
                      ),
                      if (isAdmin) ...[
                        /// Edit button.
                        _iconBtn(Icons.edit, const Color(0xFF7B3FE4), () => _openEditEventDialog(context, event)),
                        const SizedBox(width: 4),
                        /// Delete button.
                        _iconBtn(Icons.delete, Colors.redAccent, () => _confirmDelete(context, event)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  /// Event date and optional location.
                  Row(children: [
                    const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      "${event.eventdate.day.toString().padLeft(2,'0')}/${event.eventdate.month.toString().padLeft(2,'0')}/${event.eventdate.year}",
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    if (event.location.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      const Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(event.location, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ]),
                  const SizedBox(height: 8),
                  /// Event type and status badges.
                  Wrap(spacing: 6, children: [
                    _badge(event.eventType, Colors.blue),
                    _badge(event.status, Colors.grey),
                  ]),
                  const SizedBox(height: 10),
                  /// Full event description.
                  Text(event.description,
                      style: const TextStyle(fontSize: 14, height: 1.4)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a styled badge used for event type, status, and capacity.
  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  /// Creates a circular icon button used for edit and delete actions.
  ///
  /// Parameters:
  /// - [icon]: Icon to display inside the button.
  /// - [color]: Background color of the button.
  /// - [onTap]: Callback triggered when the button is tapped.
  Widget _iconBtn(IconData icon, Color color, VoidCallback onTap) {
    return Tooltip(
      message: icon == Icons.edit ? 'Editar' : 'Borrar',
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