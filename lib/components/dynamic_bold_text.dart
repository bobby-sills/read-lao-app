import 'package:flutter/material.dart';
import 'package:learn_lao_app/utilities/shared_styles.dart';

class DynamicBoldText extends StatelessWidget {
  final String text;
  final String targetCharacter;
  final double fontSize;
  final Color boldColor;
  final Color outlineColor;
  final double strokeWidth;

  const DynamicBoldText({
    Key? key,
    required this.text,
    required this.targetCharacter,
    this.fontSize = 32,
    this.boldColor = Colors.black,
    this.outlineColor = Colors.black,
    this.strokeWidth = 2.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final characters = text.characters;
    List<TextSpan> spans = [];

    for (String char in characters) {
      bool shouldBold = char == targetCharacter;

      spans.add(
        TextSpan(
          text: char,
          style: TextStyle(
            fontFamily: 'Saysettha',
            fontSize: fontSize,
            fontWeight: shouldBold ? FontWeight.bold : FontWeight.normal,
            color: shouldBold ? boldColor : null,
            foreground: shouldBold
                ? null
                : (Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = strokeWidth
                    ..color = outlineColor),
          ),
        ),
      );
    }

    return Text.rich(
      TextSpan(children: spans),
      textDirection: TextDirection.ltr,
    );
  }
}