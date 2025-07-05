// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learn_lao_app/exercises/learn_vowel_exercise.dart';
import 'package:learn_lao_app/exercises/select_sound_exercise.dart';
import 'package:learn_lao_app/pages/default_page.dart';
import 'package:learn_lao_app/pages/lesson_wrapper.dart';
import 'package:learn_lao_app/testing.dart';
import 'package:learn_lao_app/utilities/hive_utility.dart';

void main() async {
  await Hive.initFlutter();
  await HiveUtility.initializeBoxes();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: DefaultPage(), // LearnVowelExercise(letter: 'ບ'),
      debugShowCheckedModeBanner: false,
    );
  }
}
