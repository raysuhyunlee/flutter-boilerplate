// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:flutter_boilerplate/app/app_reset_notifier.dart';
import 'package:flutter_boilerplate/app/ui/pages/settings/dev_tools_page.dart';
import 'package:flutter_boilerplate/domain/session/session_service.dart';
import 'package:flutter_boilerplate/l10n/app_localizations.dart';

void main() {
  late AppResetNotifier resetNotifier;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    final getIt = GetIt.instance;
    getIt.reset();
    getIt.registerSingleton<Logger>(Logger(output: ConsoleOutput()));
    getIt.registerSingleton<SessionService>(SessionService());
    resetNotifier = AppResetNotifier();
    getIt.registerSingleton<AppResetNotifier>(resetNotifier);
  });

  tearDown(() => GetIt.instance.reset());

  Widget buildTestApp() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const DevToolsPage(),
    );
  }

  group('DevToolsPage reset', () {
    testWidgets(
      'should_trigger_app_reset_notifier_when_reset_button_is_tapped',
      (tester) async {
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle();

        var notified = false;
        resetNotifier.addListener(() => notified = true);

        await tester.tap(find.text('Reset to First Install State'));
        await tester.pumpAndSettle();

        expect(notified, isTrue);
      },
    );

    testWidgets(
      'should_clear_shared_preferences_when_reset_button_is_tapped',
      (tester) async {
        SharedPreferences.setMockInitialValues({
          'first_launch': false,
          'session_count': 5,
        });

        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Reset to First Install State'));
        await tester.pumpAndSettle();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('first_launch'), isNull);
        expect(prefs.getInt('session_count'), isNull);
      },
    );

    testWidgets(
      'should_pop_all_routes_to_root_when_reset_completes',
      (tester) async {
        // Build an app with a home page that pushes to DevToolsPage,
        // simulating the real navigation stack.
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DevToolsPage(),
                    ),
                  ),
                  child: const Text('Open DevTools'),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Navigate to DevToolsPage
        await tester.tap(find.text('Open DevTools'));
        await tester.pumpAndSettle();

        // Tap reset
        await tester.tap(find.text('Reset to First Install State'));
        await tester.pumpAndSettle();

        // Should have popped back to root
        expect(find.text('Open DevTools'), findsOneWidget);
        expect(find.byType(DevToolsPage), findsNothing);
      },
    );
  });
}
