import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
// ignore: unused_import
import 'package:learn_lao_app/pages/default_page.dart';
import 'package:provider/provider.dart';
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
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: themeProvider.isDarkMode
                  ? Brightness.dark
                  : Brightness.light,
            ),
          ),
          home: DefaultPage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
