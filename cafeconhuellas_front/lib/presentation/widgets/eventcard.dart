import 'package:cafeconhuellas_front/theme/AppColors.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const EventCard(this.image, this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cream),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Image.asset(
            image,
            width: 200,
            height: 140,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontFamily: "MilkyVintage",
            ),
          ),
          const SizedBox(height: 8),
          Text(description, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}