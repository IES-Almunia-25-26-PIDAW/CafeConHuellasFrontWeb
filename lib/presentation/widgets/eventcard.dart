import 'package:cafeconhuellas_front/theme/AppColors.dart';
import 'package:flutter/material.dart';

/// A card widget that displays an event with
/// its image, title, and a short description.
///
/// Supports both network and asset images.
class EventCard extends StatelessWidget {
  /// URL or asset path of the event image.
  final String image;
  /// Title of the event.
  final String title;
  /// Short description of the event.
  final String description;

  const EventCard(this.image, this.title, this.description);

  @override
  Widget build(BuildContext context) {
    // Determines whether to load the image from network or assets.
    final bool isNetworkImage =
        image.startsWith('http://') || image.startsWith('https://');

    return Container(
      width: 280,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cream),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: [
          isNetworkImage
              ? Image.network(
                  image,
                  width: 280,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 280,
                    height: 150,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                )
              : Image.asset(
                  image,
                  width: 280,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 280,
                    height: 150,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
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
          Text(
            description,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}