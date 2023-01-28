import 'package:flutter/material.dart';
import 'package:superheroes/resources/superhero_colors.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ActionButton({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: SuperheroColors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
              fontSize: 14,
              color: SuperheroColors.whiteText,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
