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
**Docs:** Explain "Why". Use english.