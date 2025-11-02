import 'package:flutter/material.dart';
import 'package:read_lao/pages/lessons_page.dart' show HomePage;
import 'package:read_lao/pages/practice_page.dart';
import 'package:read_lao/pages/settings_page.dart';

class DefaultPage extends StatefulWidget {
  const DefaultPage({super.key});

  @override
  State<DefaultPage> createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home_rounded),
            icon: Icon(Icons.home_outlined),
            label: "Lessons",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.edit_rounded),
            icon: Icon(Icons.edit_outlined),
            label: "Practice",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings_rounded),
            icon: Icon(Icons.settings_outlined),
            label: "Settings",
          ),
        ],
      ),
      body: <Widget>[const HomePage(), const PracticePage(), const SettingsPage()][currentPageIndex],
    );
  }
}
