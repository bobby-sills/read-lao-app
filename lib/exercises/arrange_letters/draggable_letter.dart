import 'package:flutter/material.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class DraggableLetter extends StatelessWidget {
  const DraggableLetter({
    super.key,
    required this.data,
    required this.onDragStart,
    required this.child,
  });

  final String data;
  final void Function() onDragStart;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DragItemWidget(
      dragItemProvider: (DragItemRequest request) {
        onDragStart();
        final item = DragItem(localData: data);
        return item;
      },
      allowedOperations: () => [DropOperation.copy],
      dragBuilder: (context, child) => child,
      child: DraggableWidget(child: child),
    );
  }
}
