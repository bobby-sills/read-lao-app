import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:read_lao/pages/default_page.dart';
import 'package:read_lao/utilities/hive_utility.dart';
import 'package:read_lao/utilities/notification_utility.dart';
import 'package:read_lao/utilities/provider/theme_provider.dart';
import 'package:read_lao/utilities/provider/lesson_provider.dart';
import 'package:read_lao/utilities/provider/debug_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await HiveUtility.initializeBoxes();
  await NotificationUtility.initialize();
  if (HiveUtility.isFirstLaunch()) {
    final granted = await NotificationUtility.requestPermission();
    HiveUtility.setNotificationsEnabled(granted);
    HiveUtility.markFirstLaunchDone();
  }
  await NotificationUtility.scheduleReminder();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LessonProvider()),
        ChangeNotifierProvider(create: (context) => DebugProvider()),
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
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: themeProvider.isDarkMode
                ? Brightness.light
                : Brightness.dark,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: themeProvider.isDarkMode
                ? Brightness.light
                : Brightness.dark,
          ),
        );

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
          home: const DefaultPage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
