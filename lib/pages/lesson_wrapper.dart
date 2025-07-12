import 'package:flutter/material.dart';
import 'package:learn_lao_app/enums/section_type.dart';
import 'package:learn_lao_app/exercises/review_message.dart';
import 'package:learn_lao_app/pages/empty_lesson.dart';
import 'package:learn_lao_app/pages/lesson_complete.dart';
import 'package:learn_lao_app/utilities/hive_utility.dart';
import 'package:learn_lao_app/utilities/provider/lesson_provider.dart';
import 'package:provider/provider.dart';

class LessonWrapper extends StatefulWidget {
  final List<Widget> exercises;
  final int lessonIndex;

  // If null is passed into the exercises parameter, meaning that there is no lesson for that index,
  //    the default value will be an empty list, which will display the EmptyLesson widget.
  /// If null is passed into the exercises parameter, meaning that there is no lesson for that index,
  const LessonWrapper({
    super.key,
    required List<Widget>? exercises,
    required this.lessonIndex,
  }) : exercises = exercises ?? const [];

  @override
  State<LessonWrapper> createState() => _LessonWrapperState();
}

class _LessonWrapperState extends State<LessonWrapper>
    with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  // Index to track the current exercise

  int _exerciseIndex = 0;
  final List<Widget> _mistakes = [];
  final Set<int> _mistakesIndicies = {};

  @override
  void initState() {
    super.initState();

    // Initialize animation controller with 500ms duration
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Create a Tween animation from current to target value
    _animation = Tween<double>(begin: _progress, end: _progress).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Add listener to update progress value during animation
    _animation.addListener(() {
      setState(() {
        _progress = _animation.value;
      });
    });
  }

  void _incrementProgress() {
    // incrementValue: how much to increment the progress bar each time
    double incrementValue = _combinedExercises.isNotEmpty
        ? 1 / _combinedExercises.length
        : 0;
    double targetProgress = (_progress + incrementValue);

    // Update animation with new start and end values
    _animation = Tween<double>(begin: _progress, end: targetProgress).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Reset and start animation
    _animationController.reset();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _nextExerciseCallback() {
    _incrementProgress();

    if (_exerciseIndex == _combinedExercises.length - 1) {
      // Use BuildContext from the current widget's build method
      if (mounted) {
        HiveUtility.setLessonCompleted(
          widget.lessonIndex,
          true,
          SectionType.consonant,
        );
        // Check if widget is still mounted
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LessonComplete(lessonNum: widget.lessonIndex);
            },
          ),
        );
      }
      return;
    }

    // Dismiss the bottom sheet if it is visible
    if (context.read<LessonProvider>().isBottomSheetVisible) {
      Navigator.of(context).pop();
    }

    setState(() => _exerciseIndex++);
  }

  List<Widget> get _combinedExercises => [...widget.exercises, ..._mistakes];

  void _markExerciseAsMistakeCallback() {
    // If there haven't been any mistakes yet, add the "time for mistakes!" screen
    setState(() {
      if (_mistakes.isEmpty) {
        _mistakes.add(ReviewMessage());
      }
      // Make sure the same exercise doesn't get added twice, even if the user gets it wrong
      if (!_mistakesIndicies.contains(_exerciseIndex)) {
        _mistakes.add(_combinedExercises[_exerciseIndex]);
        _mistakesIndicies.add(_exerciseIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.exercises.isEmpty) {
      return const EmptyLesson();
    }

    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(
          onPressed: () {
            if (_progress > 0) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('End Lesson'),
                    content: const Text(
                      'Are you sure you want to end your current progress on this lesson?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigates all the way back to the first screen
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        child: const Text('End Lesson'),
                      ),
                    ],
                  );
                },
              );
            } else {
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          },
        ),
        title: LinearProgressIndicator(
          value: _progress,
          minHeight: 10,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Consumer<LessonProvider>(
              builder: (context, lessonProvider, child) {
                lessonProvider.nextExercise = _nextExerciseCallback;
                lessonProvider.markExerciseAsMistake =
                    _markExerciseAsMistakeCallback;
                return _combinedExercises[_exerciseIndex];
              },
            ),
          ],
        ),
      ),
    );
  }
}
