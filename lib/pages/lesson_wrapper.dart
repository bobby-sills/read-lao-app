import 'package:flutter/material.dart';
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
    double incrementValue = widget.exercises.isNotEmpty
        ? 1 / widget.exercises.length
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

    if (_exerciseIndex == widget.exercises.length - 1) {
      // Use BuildContext from the current widget's build method
      if (mounted) {
        HiveUtility.setLessonCompleted(widget.lessonIndex, true);
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
    if (Provider.of<LessonProvider>(
      context,
      listen: false,
    ).isBottomSheetVisible) {
      Navigator.of(context).pop();
    }

    setState(() => _exerciseIndex++);
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
                          Navigator.of(context).pop(); // Close the dialog
                          Navigator.of(context).pop(); // Exit the lesson
                          // Exit the lesson again if the context still isn't cleared
                          Navigator.of(context).pop();
                        },
                        child: const Text('End Lesson'),
                      ),
                    ],
                  );
                },
              );
            } else {
              Navigator.of(context).pop(); // Exit the lesson directly
            }
          },
        ),
        title: LinearProgressIndicator(
          value: _progress,
          minHeight: 10,
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [Text('$_exerciseIndex  ')],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Consumer<LessonProvider>(
              builder: (context, lessonProvider, child) {
                lessonProvider.setNextExerciseCallback(_nextExerciseCallback);
                return widget.exercises[_exerciseIndex];
              },
            ),
          ],
        ),
      ),
    );
  }
}
