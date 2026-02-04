// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutter_boilerplate/app/resources/theme.dart';
import 'package:flutter_boilerplate/app/ui/pages/settings/settings_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _openSettingsPage,
            ),
          ],
        ),
        body: const Center(
          child: Text('Hello, Boilerplate!'),
        ),
      ),
    );
  }

  void _openSettingsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }
}
