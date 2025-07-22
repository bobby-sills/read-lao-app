import 'package:flutter/material.dart';
import 'package:learn_lao_app/exercises/arrange_letters/types.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class LetterDropRegion extends StatefulWidget {
  const LetterDropRegion({
    super.key,
    required this.childSize,
    required this.columns,
    required this.section,
    required this.updateDropPreview,
    required this.child,
  });

  final Size childSize;
  final int columns;
  final Section section;
  final void Function(DropLocation) updateDropPreview;
  final Widget child;

  @override
  State<LetterDropRegion> createState() => _LetterDropRegionState();
}

class _LetterDropRegionState extends State<LetterDropRegion> {
  int? dropIndex;

  @override
  Widget build(BuildContext context) {
    return DropRegion(
      formats: Formats.standardFormats,
      onDropOver: (event) {
        _updatePreview(event.position.local);
        return DropOperation.copy;
      },
      onPerformDrop: (event) async {},
      child: widget.child,
    );
  }

  void _updatePreview(Offset hoverPosition) {
    final int row = hoverPosition.dy ~/ widget.childSize.height;
    final int column =
        (hoverPosition.dx - (widget.childSize.width / 2)) ~/
        widget.childSize.width;
    int newDropIndex = (row * widget.columns) + column;
    if (newDropIndex != dropIndex) {
      dropIndex = newDropIndex;
      widget.updateDropPreview((dropIndex!, widget.section));
    }
  }
}
