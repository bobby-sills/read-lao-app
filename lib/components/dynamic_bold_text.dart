import 'package:flutter/material.dart';

class DynamicBoldText extends StatelessWidget {
  final String text;
  final String targetCharacter;
  final double fontSize;
  final Color boldColor;
  final Color outlineColor;
  final double strokeWidth;

  const DynamicBoldText({
    super.key,
    required this.text,
    required this.targetCharacter,
    this.fontSize = 32,
    this.boldColor = Colors.black,
    this.outlineColor = Colors.black,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DynamicBoldTextPainter(
        text: text,
        targetCharacter: targetCharacter,
        fontSize: fontSize,
        boldColor: boldColor,
        outlineColor: outlineColor,
        strokeWidth: strokeWidth,
      ),
      child: SizedBox(width: _getTextWidth(), height: fontSize * 1.5),
    );
  }

  double _getTextWidth() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'Saysettha',
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.width;
  }
}

class DynamicBoldTextPainter extends CustomPainter {
  final String text;
  final String targetCharacter;
  final double fontSize;
  final Color boldColor;
  final Color outlineColor;
  final double strokeWidth;

  DynamicBoldTextPainter({
    required this.text,
    required this.targetCharacter,
    required this.fontSize,
    required this.boldColor,
    required this.outlineColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // First, draw the outlined text
    final outlineTextPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'Saysettha',
          fontSize: fontSize,
          fontWeight: FontWeight.normal,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..color = outlineColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    outlineTextPainter.layout();
    outlineTextPainter.paint(canvas, Offset.zero);

    // Then, draw the bold character overlay
    final targetRune = targetCharacter.runes.single;
    final textRunes = text.runes.toList();

    for (int i = 0; i < textRunes.length; i++) {
      if (textRunes[i] == targetRune) {
        // Get the position of this character
        final charOffset = _getCharacterOffset(i);

        // Draw just this character in bold
        final boldCharPainter = TextPainter(
          text: TextSpan(
            text: String.fromCharCode(textRunes[i]),
            style: TextStyle(
              fontFamily: 'Saysettha',
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: boldColor,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        boldCharPainter.layout();
        boldCharPainter.paint(canvas, Offset(charOffset, 0));
      }
    }
  }

  double _getCharacterOffset(int charIndex) {
    if (charIndex == 0) return 0;

    // Get the width of text up to this character
    final textUpToChar = String.fromCharCodes(text.runes.take(charIndex));
    final textPainter = TextPainter(
      text: TextSpan(
        text: textUpToChar,
        style: TextStyle(
          fontFamily: 'Saysettha',
          fontSize: fontSize,
          fontWeight: FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.width;
  }

  @override
  bool shouldRepaint(DynamicBoldTextPainter oldDelegate) {
    return oldDelegate.text != text ||
        oldDelegate.targetCharacter != targetCharacter ||
        oldDelegate.fontSize != fontSize ||
        oldDelegate.boldColor != boldColor ||
        oldDelegate.outlineColor != outlineColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
