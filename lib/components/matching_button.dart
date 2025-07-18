import 'package:flutter/material.dart';
import 'package:learn_lao_app/enums/section_type.dart';
import 'package:learn_lao_app/utilities/sounds_utility.dart';
import 'package:learn_lao_app/enums/button_state.dart';
import 'package:learn_lao_app/enums/button_type.dart';

class MatchingButton extends StatelessWidget {
  final ButtonType buttonType;
  final int index;
  final Map<ButtonType, List<ButtonState>> states;
  final String letter;
  final Function(int index, ButtonType buttonType) selectButtonCallback;
  final SoundsUtility player;
  final SectionType sectionType;

  const MatchingButton({
    super.key,
    required this.buttonType,
    required this.index,
    required this.states,
    required this.letter,
    required this.selectButtonCallback,
    required this.player,
    required this.sectionType,
  });

  VoidCallback? get _onPressed {
    ButtonState state = states[buttonType]![index];
    switch (state) {
      // If it's disabled, the button will look and be unclickable
      case ButtonState.disabled:
        return null;
      // If it's complete or incorrect, the button will have whatever styling is applied, but won't be clickable
      case ButtonState.complete || ButtonState.incorrect:
        return () {};
      // If the button state is anything else that isn't disabled, figure out what the button should do when pressed,
      // and pass that information along to another selectButtonCallback
      default:
        return () {
          // If the button is just the "normal" deselected state,
          // and the buttonType is a sound button
          if (buttonType == ButtonType.sound) {
            if (state == ButtonState.deselected) {
              player.playLetter(letter, sectionType);
            }
          }
          selectButtonCallback(index, buttonType);
        };
    }
  }

  Color _getTargetColor(ThemeData theme) {
    return switch (states[buttonType]![index]) {
      ButtonState.complete => Colors.green,
      ButtonState.incorrect => Colors.red,
      ButtonState.selected => theme.colorScheme.primary,
      ButtonState.deselected => theme.colorScheme.secondary,
      ButtonState.disabled => theme.colorScheme.secondary,
    };
  }

  Widget? _buttonContent(ThemeData theme) {
    if (buttonType == ButtonType.letter) {
      return Text(
        letter,
        style: TextStyle(
          fontSize: theme.textTheme.displayLarge?.fontSize,
          fontFamily: 'NotoSansLaoLooped',
        ),
      );
    } else if (buttonType == ButtonType.sound) {
      return Icon(
        Icons.volume_up_rounded,
        size: theme.textTheme.displayMedium?.fontSize,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final targetColor = _getTargetColor(theme);
    final state = states[buttonType]![index];

    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: targetColor),
      duration: Duration(milliseconds: 300),
      builder: (context, color, child) {
        return OutlinedButton(
          onPressed: _onPressed,
          style: state == ButtonState.disabled
              ? null
              : OutlinedButton.styleFrom(
                  backgroundColor: color,
                  side: BorderSide(color: Colors.transparent),
                  foregroundColor: theme.colorScheme.inversePrimary,
                ),
          child: _buttonContent(theme),
        );
      },
    );
  }
}
