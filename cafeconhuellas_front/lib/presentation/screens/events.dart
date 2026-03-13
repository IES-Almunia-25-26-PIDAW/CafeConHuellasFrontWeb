import 'package:cafeconhuellas_front/models/event.dart';
import 'package:cafeconhuellas_front/presentation/widgets/app_header.dart';
import 'package:cafeconhuellas_front/theme/AppColors.dart';
import 'package:cafeconhuellas_front/utils/globals.dart';
import 'package:flutter/material.dart';


class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final activeEvents =
       Globals.Futureevents.where((e) => e.active).toList();

    final pastEvents =
        Globals.PastEvents.where((e) => !e.active).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppHeader(userImageUrl: "assets/user.png"),
            //banner
            Image.asset("assets/images/banners/banner-inicio.png", width: double.infinity, height: 400, fit:BoxFit.cover),
            const SizedBox(height: 40),
            
            const SizedBox(height: 40),

            /// EVENTOS ACTIVOS
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

            /// EVENTOS PASADOS
            _title("Eventos Pasados"),

            Column(
              children: pastEvents
                  .map((event) => _pastEventRow(event))
                  .toList(),
            ),

            const SizedBox(height: 80),
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
      width: 260,
      child: Column(
        children: [

          /// IMAGEN
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              event.imageUrl,
              height: 160,
              width: 260,
              fit: BoxFit.cover,
            ),
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
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cream),
              color: Colors.white,
            ),
            child: Text(
              event.description,
              textAlign: TextAlign.center,
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
            child: Image.asset(
              event.imageUrl,
              width: 260,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),

          /// CARD INFO
          Container(
            width: 450,
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

                Text(event.description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}