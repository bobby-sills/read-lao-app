import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learn_lao_app/exercises/spelling_exercise/spelling_exercise.dart';
// ignore: unused_import
import 'package:learn_lao_app/pages/default_page.dart';
import 'package:learn_lao_app/pages/lesson_wrapper.dart';
import 'package:learn_lao_app/enums/section_type.dart';
import 'package:provider/provider.dart';
import 'package:learn_lao_app/utilities/hive_utility.dart';
import 'package:learn_lao_app/utilities/provider/theme_provider.dart';
import 'package:learn_lao_app/utilities/provider/lesson_provider.dart';

void main() async {
  await Hive.initFlutter();
  await HiveUtility.initializeBoxes();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LessonProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Learn Lao',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: themeProvider.isDarkMode
                  ? Brightness.dark
                  : Brightness.light,
            ),
          ),
          home: LessonWrapper(
            exercises: [SpellingExercise(word: 'ກຂຄງຈສ')],
            lessonIndex: 1,
            sectionType: SectionType.consonant,
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
