import 'package:cafeconhuellas_front/models/event.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_footer.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:cafeconhuellas_front/theme/AppColors.dart';
import 'package:cafeconhuellas_front/utils/globals.dart';
import 'package:flutter/material.dart';


class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  static const double _cardWidth = 280;
  static const double _cardHeight = 180;
  static const double _activeDescriptionHeight = 140;
  static const double _pastInfoCardWidth = 460;

  Widget _eventImage(String imagePath, {double? width, double? height}) {
    final isNetworkImage = imagePath.startsWith('http://') || imagePath.startsWith('https://');

    if (isNetworkImage) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    }

    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: width,
        height: height,
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /*
    final Future<List<Event>> eventsFuture = ApiConector().getEvents();
    return FutureBuilder<List<Event>>(
      future: eventsFuture,
      builder: (context, snapshot) {
        ...
      },
    );
    */

    final activeEvents = Globals.Futureevents.where((e) => e.active).toList();
    final pastEvents = Globals.PastEvents.where((e) => !e.active).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppHeader(userImageUrl: "assets/user.png"),
            Image.asset("assets/images/banners/banner-inicio.png", width: double.infinity, height: 400, fit:BoxFit.cover),
            const SizedBox(height: 40),
            const SizedBox(height: 40),
            _title("Eventos Activos"),
            Wrap(
              spacing: 30,
              runSpacing: 30,
              alignment: WrapAlignment.center,
              children: activeEvents
                  .map((event) => _activeEventCard(event))
                  .toList(),
            ),
            const SizedBox(height: 80),
            _title("Eventos Pasados"),
            Column(
              children: pastEvents
                  .map((event) => _pastEventRow(event))
                  .toList(),
            ),
            const SizedBox(height: 80),
            AppFooter()
          ],
        ),
      ),
    );
  }

  /// TITULO
  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 38,
          fontFamily: "WinkyMilky",
          color: AppColors.darkViolet,
        ),
      ),
    );
  }

  /// EVENTO ACTIVO (GRID)
  Widget _activeEventCard(Event event) {
    return SizedBox(
      width: _cardWidth,
      child: Column(
        children: [
          /// IMAGEN
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _eventImage(event.imageUrl, height: _cardHeight, width: _cardWidth),
          ),

          const SizedBox(height: 10),

          /// NOMBRE
          Text(
            event.name,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: "MilkyVintage",
            ),
          ),

          const SizedBox(height: 10),

          /// CARD
          Container(
            height: _activeDescriptionHeight,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cream),
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                event.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.25,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// EVENTO PASADO (FILA)
  Widget _pastEventRow(Event event) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 60,
      ),
      child: Wrap(
        spacing: 30,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: [

          /// IMAGEN
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _eventImage(event.imageUrl, width: _cardWidth, height: _cardHeight),
          ),

          /// CARD INFO
          Container(
            width: _pastInfoCardWidth,
            height: _cardHeight,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cream),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  event.name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontFamily: "MilkyVintage",
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: Text(
                    event.description,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}