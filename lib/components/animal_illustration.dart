import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Wraps a Bloom-set animal SVG in a soft outer halo. Each animal already has
// its own colored puck baked into the artwork, but a handful (chicken, cat,
// bee) use a cream puck that disappears against the app's near-white scaffold
// background. The halo is theme-aware so it sits unobtrusively in both light
// and dark mode and just looks like a deliberate "spotlight" on the others.
class AnimalIllustration extends StatelessWidget {
  final String asset;
  final double size;

  const AnimalIllustration({
    super.key,
    required this.asset,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      padding: EdgeInsets.all(size * 0.04),
      child: SvgPicture.asset(asset),
    );
  }
}
