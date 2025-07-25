import 'package:flutter/foundation.dart';
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
    final bool isDarkMode = theme.brightness == Brightness.dark;
    int highlightedRune = targetCharacter.runes.single;

    final List<TextSpan> spans = [];

    for (int rune in text.runes) {
      if (rune == highlightedRune) {
        spans.add(TextSpan(text: String.fromCharCode(rune), style: textStyle));
      } else {
        spans.add(
          TextSpan(
            text: String.fromCharCode(rune),
            style: textStyle.copyWith(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1.0
                ..color =
                    textStyle.color ?? (isDarkMode ? Colors.white : Colors.black)
            ),
          ),
        );
      }
    }

    return RichText(text: TextSpan(children: spans));
  }
}
