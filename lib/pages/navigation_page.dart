import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:learn_lao_app/components/lesson_view.dart';
import 'package:learn_lao_app/enums/section_type.dart';
import 'package:learn_lao_app/utilities/hive_utility.dart';

enum LessonStatus { notStarted, nextUp, completed }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int lessonButtonSize = 100;

  @override
  Widget build(BuildContext context) {
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
              sliver: const LessonView(sectionType: SectionType.consonant),
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
              sliver: const LessonView(sectionType: SectionType.vowel),
            ),
          ],
        ),
      ),
    );
  }
}
