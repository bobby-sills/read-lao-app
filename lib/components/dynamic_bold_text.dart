import 'package:flutter/material.dart';

class DynamicBoldText extends StatelessWidget {
  final String text;
  final String targetCharacter;
  final TextStyle textStyle;

  const DynamicBoldText({
    super.key,
    required this.text,
    required this.targetCharacter,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    Set<int> highlightedRunes = targetCharacter.runes.toSet();

    final List<TextSpan> spans = [];

    final Color prominentColor = theme.colorScheme.primary;

    for (int rune in text.runes) {
      if (highlightedRunes.contains(rune)) {
        spans.add(
          TextSpan(
            text: String.fromCharCode(rune),
            style: textStyle.copyWith(color: prominentColor, foreground: null),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: String.fromCharCode(rune),
            style: textStyle.copyWith(foreground: null),
          ),
        );
      }
    }

    return RichText(text: TextSpan(children: spans));
  }
}
