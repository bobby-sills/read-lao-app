import 'package:flutter/material.dart';

class BottomLessonButton extends StatefulWidget {
  final void Function()? onPressed;
  final String buttonText;
  final Color? buttonColor;
  final Icon buttonIcon;

  const BottomLessonButton({
    super.key,
    required this.onPressed,
    this.buttonText = 'Continue',
    this.buttonIcon = const Icon(Icons.arrow_forward_rounded),
    this.buttonColor,
  });

  @override
  State<BottomLessonButton> createState() => _BottomLessonButtonState();
}

class _BottomLessonButtonState extends State<BottomLessonButton> {
  bool _isPressed = false;

  void _handlePress() {
    if (_isPressed || widget.onPressed == null) return;
    
    setState(() {
      _isPressed = true;
    });
    
    widget.onPressed!();
    
    // Reset after a short delay to prevent rapid consecutive taps
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isPressed = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: FilledButton.icon(
        onPressed: _isPressed ? null : _handlePress,
        icon: widget.buttonIcon,
        label: Text(widget.buttonText),
        iconAlignment: IconAlignment.end,
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          // Only apply the button color if it's provided
          backgroundColor: widget.buttonColor,
        ),
      ),
    );
  }
}
