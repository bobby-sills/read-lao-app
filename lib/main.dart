// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:learn_lao_app/exercises/learn_vowel_exercise.dart';
import 'package:learn_lao_app/exercises/select_sound_exercise.dart';
import 'package:learn_lao_app/pages/default_page.dart';
import 'package:learn_lao_app/pages/lesson_wrapper.dart';
import 'package:learn_lao_app/testing.dart';
import 'package:learn_lao_app/utilities/hive_utility.dart';
import 'package:learn_lao_app/utilities/provider/theme_provider.dart';

void main() async {
  await Hive.initFlutter();
  await HiveUtility.initializeBoxes();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
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
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
          home: DefaultPage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
