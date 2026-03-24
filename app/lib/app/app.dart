// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_boilerplate/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

// Project imports:
import 'package:flutter_boilerplate/app/extensions/build_context_extensions.dart';
import 'package:flutter_boilerplate/app/resources/theme.dart';
import 'package:flutter_boilerplate/app/ui/pages/onboarding/onboarding_page.dart';
import 'package:flutter_boilerplate/app/ui/pages/settings/settings_page.dart';
import 'package:flutter_boilerplate/domain/session/session_service.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final _sessionService = GetIt.instance<SessionService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _sessionService.recordColdStart();
    _sessionService.saveInstallDateIfNeeded();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _sessionService.recordResumeIfNeeded();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const _EntryPoint(),
    );
  }
}

/// Checks first launch and shows onboarding or home page accordingly.
class _EntryPoint extends StatefulWidget {
  const _EntryPoint();

  @override
  State<_EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<_EntryPoint> {
  final _sessionService = GetIt.instance<SessionService>();
  bool? _isFirstLaunch;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final isFirst = await _sessionService.isFirstLaunch();
    if (mounted) setState(() => _isFirstLaunch = isFirst);
  }

  void _onOnboardingComplete() {
    _sessionService.markAlreadyLaunched();
    setState(() => _isFirstLaunch = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstLaunch == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_isFirstLaunch == true) {
      return OnboardingPage(
        steps: _buildOnboardingSteps(context),
        onComplete: _onOnboardingComplete,
      );
    }

    return const _HomePage();
  }

  /// Define your onboarding steps here.
  List<OnboardingStep> _buildOnboardingSteps(BuildContext context) {
    return [
      OnboardingStep(
        visual: const SizedBox(
          height: 300,
          child: Center(
            child: Icon(Icons.waving_hand_rounded, size: 80,
                color: Color(0xFFFBBF24)),
          ),
        ),
        title: context.l10n.onboardingStep1Title,
        description: context.l10n.onboardingStep1Description,
      ),
    ];
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _openSettingsPage(context),
          ),
        ],
      ),
      body: Center(
        child: Text(context.l10n.helloBoilerplate),
      ),
    );
  }

  void _openSettingsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }
}
