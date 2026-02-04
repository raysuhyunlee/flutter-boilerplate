# Flutter AI Rules
**Role:** Expert Dev. Premium, beautiful code.
**Tools:** `dart_format`, `dart_fix`, `analyze_files`.
**Code:**
* **SOLID**.
* **TDD:** Write test first.
* **Layers:** Pres/Domain/Data.
* **Naming:** PascalTypes, camelMembers, snake_files.
* **Async:** `async/await`, try-catch.
* **Log:** `logger` package via DI. Crashlytics integration (`CrashlyticsLogOutput`).
* **Null:** Sound safety. No `!`.
* **Exception:** Global try-catch, log errors to firebase crashlytics
**Perf:**
* `const` everywhere.
* `ListView.builder`.
* `compute()` for heavy tasks.
**Testing:** `flutter test`, `integration_test`.
**A11y:** 4.5:1 contrast, Semantics.
**Design:** "Wow" factor. Glassmorphism, shadows.
**i18n:**
* `flutter_localizations` + `gen-l10n`.
* ARB files in `lib/l10n/`. Template: `app_en.arb`.
* Add new string: 1) add key to `app_en.arb` with `@key` description, 2) add translations to other `.arb` files, 3) run `flutter gen-l10n`.
* Access via `context.l10n.keyName` (extension in `lib/app/extensions/build_context_extensions.dart`).
* **No hardcoded user-facing strings.** All text must come from ARB files.
**Docs:** Explain "Why". Use english.