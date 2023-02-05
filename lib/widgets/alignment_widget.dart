import 'package:flutter/cupertino.dart';

import '../model/alignment_info.dart';
import '../resources/superhero_colors.dart';

class AlignmentWidget extends StatelessWidget {
  final AlignmentInfo alignmentInfo;
  final BorderRadius borderRadius;

  const AlignmentWidget({Key? key, required this.alignmentInfo, required this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        height: 24,
        width: 70,
        decoration: BoxDecoration(
          color: alignmentInfo.color,
          borderRadius: borderRadius,
        ),
        alignment: Alignment.center,
        child: Text(
          alignmentInfo.name.toUpperCase(),
          style: const TextStyle(
              color: SuperheroColors.whiteText,
              fontSize: 10,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}