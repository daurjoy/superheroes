import 'package:flutter/material.dart';
import 'package:superheroes/resources/superhero_colors.dart';

class AlignmentInfo {
  final String name;
  final Color color;

  const AlignmentInfo._(this.name, this.color);

  static const bad = AlignmentInfo._('bad', SuperheroColors.red);
  static const good = AlignmentInfo._('good', SuperheroColors.green);
  static const neutral = AlignmentInfo._('neutral', SuperheroColors.grey);

  static AlignmentInfo? fromAlignment(final String alignment) {
    if (alignment == 'bad') {
      return bad;
    } else if (alignment == 'good') {
      return good;
    } else if (alignment == 'neutral') {
      return neutral;
    }
    return null;
  }
}