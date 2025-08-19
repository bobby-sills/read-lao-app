import 'package:flutter/material.dart';

const TextStyle laoStyle = TextStyle(fontFamily: 'NotoSansLaoLooped');

class CharacterCardStyles {
  static BoxDecoration undepressedCardDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
    );
  }

  static BoxDecoration depressedCardDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }

  static const double undepressedElevation = 1.0;
  static const double depressedElevation = 0.0;

  static TextStyle undepressedTextStyle(BuildContext context) {
    return TextStyle(
      fontFamily: "NotoSansLaoLooped",
      fontWeight: FontWeight.w500,
      fontSize: 36,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle depressedTextStyle(BuildContext context) {
    return TextStyle(
      fontFamily: "NotoSansLaoLooped",
      fontWeight: FontWeight.w500,
      fontSize: 36,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }
}
