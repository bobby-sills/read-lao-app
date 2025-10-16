import 'package:flutter/material.dart';
import 'package:read_lao/enums/button_type.dart';
import 'package:read_lao/enums/button_state.dart';
import 'package:read_lao/typedefs/letter_type.dart';
import 'package:read_lao/utilities/audio_utility.dart';

class MatchingButton extends StatelessWidget {
  final ButtonType buttonType;
  final int index;
  final Map<ButtonType, List<ButtonState>> states;
  final Letter letter;
  final Function(int index, ButtonType buttonType) selectButtonCallback;
  final AudioUtility player;

  const MatchingButton({
    super.key,
    required this.buttonType,
    required this.index,
    required this.states,
    required this.letter,
    required this.selectButtonCallback,
    required this.player,
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
              player.playLetter(letter);
            }
          }
          selectButtonCallback(index, buttonType);
        };
    }
  }

  Color _getTargetColor(ThemeData theme) {
    return switch (states[buttonType]![index]) {
      ButtonState.complete => Colors.greenAccent,
      ButtonState.incorrect => Colors.redAccent,
      ButtonState.selected => theme.colorScheme.secondary,
      ButtonState.deselected => theme.colorScheme.surface,
      ButtonState.disabled => theme.colorScheme.surface,
    };
  }

  Color _getTextColor(ThemeData theme) {
    return switch (states[buttonType]![index]) {
      ButtonState.complete => theme.colorScheme.onPrimary,
      ButtonState.incorrect => theme.colorScheme.onError,
      ButtonState.selected => theme.colorScheme.onSecondary,
      ButtonState.deselected => theme.colorScheme.onSurfaceVariant,
      ButtonState.disabled => theme.colorScheme.onSurface,
    };
  }

  Widget? _buttonContent(ThemeData theme, ButtonState state) {
    final textColor = _getTextColor(theme);

    if (buttonType == ButtonType.letter) {
      return Text(
        letter.character,
        style: TextStyle(
          fontSize: theme.textTheme.displayLarge?.fontSize,
          fontFamily: 'NotoSansLaoLooped',
          color: state == ButtonState.disabled ? null : textColor,
        ),
      );
    } else if (buttonType == ButtonType.sound) {
      return Icon(
        Icons.volume_up_rounded,
        size: theme.textTheme.displayMedium?.fontSize,
        color: state == ButtonState.disabled ? null : textColor,
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
        return ElevatedButton(
          onPressed: state == ButtonState.disabled ? null : _onPressed,
          style:
              state == ButtonState.disabled || state == ButtonState.deselected
              ? null
              : ElevatedButton.styleFrom(backgroundColor: color),
          child: _buttonContent(theme, state),
        );
      },
    );
  }
}
