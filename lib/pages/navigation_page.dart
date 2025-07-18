import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:learn_lao_app/components/lesson_view.dart';
import 'package:learn_lao_app/enums/section_type.dart';
import 'package:learn_lao_app/utilities/app_data.dart';
import 'package:learn_lao_app/utilities/hive_utility.dart';

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
    final lastLesson = _getLastCompleteLesson();

    // Calculate the position based on lesson index and section
    double targetPosition = 0;

    // Add height for sticky header
    const double headerHeight = 60;

    if (lastLesson.sectionType == SectionType.consonant) {
      // For consonant section, just calculate position from lesson index
      targetPosition =
          headerHeight +
          (lastLesson.index * 120); // 100 button height + 20 padding
    } else {
      // For vowel section, add all consonant lessons plus vowel header
      final consonantLessons = AppData.consonantLessons.length;
      targetPosition =
          headerHeight +
          (consonantLessons * 120) +
          headerHeight +
          (lastLesson.index * 120);
    }

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
    final lastLesson = _getLastCompleteLesson();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverStickyHeader(
              header: Container(
                height: 60,
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Consonants',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              sliver: LessonView(
                sectionType: SectionType.consonant,
                lastLesson: lastLesson,
              ),
            ),
            SliverStickyHeader(
              header: Container(
                height: 60,
                color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Vowels',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              sliver: LessonView(
                sectionType: SectionType.vowel,
                lastLesson: lastLesson,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ({SectionType sectionType, int index}) _getLastCompleteLesson() {
    final lastConsonant = HiveUtility.getLastLessonComplete(
      SectionType.consonant,
    );
    final lastVowel = HiveUtility.getLastLessonComplete(SectionType.vowel);

    // If the last consonant has been completed, then the last lesson
    // will be in the vowel section
    if (lastConsonant == AppData.consonantLessons.length - 1) {
      return (sectionType: SectionType.vowel, index: lastVowel);
    } else {
      return (sectionType: SectionType.consonant, index: lastConsonant);
    }
  }
}
