import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:read_lao/utilities/lesson_data.dart';
import 'package:read_lao/utilities/hive_utility.dart';
import 'package:read_lao/components/lesson_nav_button.dart';

enum LessonStatus { notStarted, nextUp, completed }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int lessonButtonSize = 100;
  final ScrollController _scrollController = ScrollController();

  void _scrollToLesson() {
    final lastLessonIndex = HiveUtility.getLastLessonComplete();

    // Calculate the position based on lesson index
    double targetPosition =
        lastLessonIndex * 120.0; // 100 lesson height + 20 padding

    // Add some offset to center the lesson on screen
    targetPosition = targetPosition - 200;

    // Ensure we don't scroll beyond the bounds
    targetPosition = targetPosition.clamp(
      0,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();

    // Schedule the scroll to happen after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToLesson();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: LessonData.allLessons.length,
                itemBuilder: (context, index) {
                  return ValueListenableBuilder(
                    valueListenable: Hive.box<bool>(
                      HiveUtility.lessonCompletionBox,
                    ).listenable(),
                    builder:
                        (BuildContext context, Box<bool> box, Widget? child) {
                          final int offsetIndex =
                              index >= LessonData.consonantLessons.length
                              ? index - LessonData.consonantLessons.length
                              : index;
                          final double xOffset = sin(offsetIndex * 100) * 96;
                          final lessonStatus =
                              HiveUtility.isLessonCompleted(index)
                              ? LessonStatus.completed
                              : HiveUtility.isLessonCompleted(index - 1)
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
                            ),
                          );

                          final tmpButton = Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Center(
                              child: Transform.translate(
                                offset: Offset(xOffset, 0),
                                child: lessonButton,
                              ),
                            ),
                          );

                          if (index == LessonData.consonantLessons.length) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  child: Text(
                                    "Vowels",
                                    style: theme.textTheme.titleLarge,
                                  ),
                                ),
                                tmpButton,
                              ],
                            );
                          } else if (index == 0) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  child: Text(
                                    "Consonants",
                                    style: theme.textTheme.titleLarge,
                                  ),
                                ),
                                tmpButton,
                              ],
                            );
                          } else {
                            return tmpButton;
                          }
                        },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
