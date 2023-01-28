import 'package:flutter/material.dart';
import 'package:superheroes/resources/superhero_colors.dart';
import 'package:superheroes/widgets/action_button.dart';

class SuperheroPage extends StatelessWidget {
  final String name;

  const SuperheroPage({Key? key, required this.name,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SuperheroColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Text(
                name,
                style: const TextStyle(
                  color: SuperheroColors.whiteText,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: ActionButton(
                    text: 'Back', onTap: () => Navigator.of(context).pop()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
