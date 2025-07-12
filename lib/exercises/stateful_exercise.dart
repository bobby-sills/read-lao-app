import 'package:flutter/material.dart';

abstract class StatefulExercise extends StatefulWidget {
  StatefulExercise({Key? key}) : super(key: key ?? UniqueKey());

  @override
  State<StatefulExercise> createState();
}

abstract class StatefulExerciseState<T extends StatefulExercise>
    extends State<T> {
  void showBottomBar({
    required BuildContext context,
    required VoidCallback onShow,
    required VoidCallback onHide,
  }) {
    onShow();
    showBottomSheet(
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
    ).closed.then((_) {
      onHide();
    });
  }

  Widget bottomSheetContent(BuildContext context);

  @override
  Widget build(BuildContext context);
}
