import 'package:flutter/material.dart';

class AutoFixedSize extends StatefulWidget {
  final Widget child;

  const AutoFixedSize({super.key, required this.child});

  @override
  State<AutoFixedSize> createState() => _AutoFixedSizeState();
}

class _AutoFixedSizeState extends State<AutoFixedSize> {
  Size? _fixedSize;
  bool _measured = false;

  @override
  Widget build(BuildContext context) {
    if (_fixedSize != null) {
      return SizedBox.fromSize(size: _fixedSize, child: widget.child);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (!_measured) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
            if (mounted) {
              setState(() {
                _fixedSize = renderBox.size;
                _measured = true;
              });
            }
          });
        }

        return widget.child;
      },
    );
  }
}
