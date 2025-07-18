import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learn_lao_app/enums/section_type.dart';
import 'package:learn_lao_app/pages/navigation_page.dart';
import 'package:learn_lao_app/utilities/app_data.dart';
import 'package:learn_lao_app/utilities/hive_utility.dart';
import 'package:learn_lao_app/components/lesson_nav_button.dart';
import 'package:learn_lao_app/utilities/helper_functions.dart';

class LessonView extends StatelessWidget {
  final SectionType sectionType;
  final ({SectionType sectionType, int index}) lastLesson;

  const LessonView({
    super.key,
    required this.sectionType,
    required this.lastLesson,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<bool>(
        sectionType == SectionType.consonant
            ? HiveUtility.consonantCompletionBox
            : HiveUtility.vowelCompletionBox,
      ).listenable(),
      builder: (context, box, _) {
        return SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final double xOffset = sin(index * 100) * 96;
                // If the lesson is complete, set the status to completed
                // If the previous lesson is completed, set the status to nextUp
                // But even if the previous lesson is not complete, set the status to nextUp if it's the first lesson
                // Otherwise, set the status to notStarted
                final lessonStatus =
                    HiveUtility.isLessonCompleted(index, SectionType.consonant)
                    ? LessonStatus.completed
                    : HiveUtility.isLessonCompleted(
                        index - 1,
                        SectionType.consonant,
                      )
                    ? LessonStatus.nextUp
                    : index == 0
                    ? LessonStatus.nextUp
                    : LessonStatus.notStarted;
                Widget lessonButton = SizedBox(
                  width: 100,
                  height: 100,
                  child: LessonNavButton(
                    index: index,
                    lessonStatus: lessonStatus,
                    sectionType: sectionType,
                  ),
                );
                late Widget content;

                if (index % 3 == 0) {
                  String headerContent =
                      "${(index / 3).ceil() + 1}. ${consonantOrder.sublist(index, index + 3).join(', ')}";
                  Widget header = Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(headerContent, style: TextStyle(fontSize: 20)),
                  );
                  content = Column(children: [header, lessonButton]);
                } else {
                  content = lessonButton;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Center(
                    child: Transform.translate(
                      offset: Offset(xOffset, 0),
                      child: content,
                    ),
                  ),
                );
              },
              // Automatically setting list length
              childCount: sectionType == SectionType.consonant
                  ? AppData.consonantLessons.length
                  : AppData.vowelLessons.length,
            ),
          ),
        );
      },
    );
  }
}
