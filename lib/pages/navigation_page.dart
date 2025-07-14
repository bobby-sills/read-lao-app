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
  BuildContext? contextToScrollTo;

  void _setScrollContextCallback(BuildContext inputContext) {
    contextToScrollTo = inputContext;
    // Schedule the scroll to happen after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (contextToScrollTo != null) {
        Scrollable.ensureVisible(contextToScrollTo!);
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lastLesson = _getLastCompleteLesson();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
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
                setScrollContextCallback: _setScrollContextCallback,
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
                setScrollContextCallback: _setScrollContextCallback,
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
