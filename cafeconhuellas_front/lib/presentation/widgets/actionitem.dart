import 'package:flutter/material.dart';

class ActionItem extends StatelessWidget {
  final String image;
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