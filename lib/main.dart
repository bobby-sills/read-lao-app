import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:read_lao/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:read_lao/firebase_options.dart';
import 'package:read_lao/pages/default_page.dart';
import 'package:read_lao/utilities/hive_utility.dart';
import 'package:read_lao/utilities/notification_utility.dart';
import 'package:read_lao/utilities/provider/theme_provider.dart';
import 'package:read_lao/utilities/provider/lesson_provider.dart';
import 'package:read_lao/utilities/provider/debug_provider.dart';
import 'package:read_lao/utilities/provider/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await HiveUtility.initializeBoxes();
  try {
    await NotificationUtility.initialize();
  } catch (_) {
    // Non-critical — don't crash startup if notifications fail to initialize
  }

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
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, child) {
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
          locale: localeProvider.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
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
