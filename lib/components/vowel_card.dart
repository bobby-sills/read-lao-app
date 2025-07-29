import 'package:flutter/material.dart';
import 'package:learn_lao_app/utilities/shared_styles.dart';

class VowelCard extends StatelessWidget {
  const VowelCard({super.key, required this.vowel});

  final String vowel;

  @override
  Widget build(BuildContext context) {
    late final List<String> vowels;
    // If the string contains a comma, split it into two strings
    if (vowel.contains(',')) {
      vowels = vowel.split(', ');
    } else {
      // Else, just use the single string
      vowels = [vowel];
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            for (String vowel in vowels)
              SizedBox(
                width: constraints.maxWidth / 2,
                child: Card(
                  child: Column(
                    children: [
                      Text(
                        vowel,
                        style: laoStyle.copyWith(fontSize: 64),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
