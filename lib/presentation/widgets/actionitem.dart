import 'package:flutter/material.dart';

/// A widget that displays an image above a centered text label.
///
/// Used to represent an action or category item
/// with a visual icon and a descriptive text.
class ActionItem extends StatelessWidget {
  /// Path to the asset image displayed at the top.
  final String image;
  /// Label text displayed below the image.
  final String text;
  const ActionItem(this.image, this.text);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          Image.asset(image, width: 100, height: 100),
          const SizedBox(height: 15),
          Text(
            text,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}