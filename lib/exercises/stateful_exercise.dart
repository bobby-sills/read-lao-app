import 'package:flutter/material.dart';

abstract class StatefulExercise extends StatefulWidget {
  StatefulExercise({Key? key}) : super(key: key ?? UniqueKey());

  @override
  State<StatefulExercise> createState();
}

abstract class StatefulExerciseState<T extends StatefulExercise>
    extends State<T> {
  PersistentBottomSheetController? _bottomSheetController;

  void showBottomBar({
    required BuildContext context,
    required VoidCallback onShow,
    required VoidCallback onHide,
  }) {
    onShow();
    _bottomSheetController = showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // Add padding to the bottom of the bottom sheet to account for the system's navigation bar
          padding: EdgeInsets.only(
            bottom: MediaQueryData.fromView(View.of(context)).padding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [bottomSheetContent(context)],
          ),
        );
      },
    ) as PersistentBottomSheetController?;
    _bottomSheetController?.closed.then((_) {
      onHide();
    });
  }

  void updateBottomSheet() {
    _bottomSheetController?.setState?.call(() {});
  }

  Widget bottomSheetContent(BuildContext context);

  @override
  Widget build(BuildContext context);
}
