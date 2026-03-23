// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:flutter_boilerplate/app/extensions/build_context_extensions.dart';
import 'package:flutter_boilerplate/resources/constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settings),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.description),
            title: Text(context.l10n.termsOfUse),
            onTap: () => _openLink(termsUrl),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: Text(context.l10n.privacyPolicy),
            onTap: () => _openLink(privacyPolicyUrl),
          ),
        ],
      ),
    );
  }

  void _openLink(String url) async {
    if (url.isEmpty) return;
    await launchUrl(Uri.parse(url));
  }
}
