# CLAUDE.md — Engineering Standards

You are a senior software engineer. Follow these rules strictly and without exception.

---

## TDD: Test-Driven Development (Mandatory)

**Always follow the Red-Green-Refactor cycle:**

1. **Red** — Write a failing test first. No production code before a test exists.
2. **Green** — Write the minimum code to make the test pass. Nothing more.
3. **Refactor** — Clean up code while keeping all tests green.

### Rules
- Never write production code without a corresponding test written first.
- Each test must test exactly one behavior.
- Test names must clearly describe the scenario: `should_[expected]_when_[condition]`
- All edge cases and failure paths must have tests.
- Do not mock what you own; do not test implementation details.
- Aim for 100% coverage of business logic. Infrastructure code may be excluded.

### Test Structure (AAA)
```
Arrange  → set up inputs and dependencies
Act      → call the unit under test
Assert   → verify the outcome
```

---

## SOLID Principles (Non-Negotiable)

### S — Single Responsibility Principle
- Every class/module does **one thing only**.
- If you can describe a class with "and", split it.

### O — Open/Closed Principle
- Code is **open for extension, closed for modification**.
- Use abstractions (interfaces, abstract classes) to add behavior without changing existing code.

### L — Liskov Substitution Principle
- Subclasses must be **fully substitutable** for their base types.
- Never override a method to throw `NotImplementedException` or to do nothing.

### I — Interface Segregation Principle
- Prefer **small, focused interfaces** over large, general ones.
- Clients must not depend on methods they don't use.

### D — Dependency Inversion Principle
- Depend on **abstractions, not concretions**.
- Inject dependencies; never instantiate dependencies inside a class.

---

## Code Quality Standards

### General
- Functions: max 20 lines. If longer, extract.
- Parameters: max 3. If more are needed, use a parameter object.
- Nesting: max 2 levels. Use early returns (guard clauses).
- No magic numbers or strings — use named constants.
- No commented-out code. Delete it; version control remembers.

### Naming
- Names must reveal intent: `calculateMonthlyInterest()` not `calc()`
- Booleans: `isValid`, `hasPermission`, `canRetry`
- Avoid abbreviations unless universally understood (e.g., `id`, `url`)

### Functions
- Do one thing only.
- No side effects unless the function name explicitly states it.
- Prefer pure functions.

### Error Handling
- Never swallow exceptions silently.
- Use domain-specific exceptions, not generic ones.
- Validate inputs at the boundary (fail fast).

---

## Development Workflow

When implementing any feature:

```
1. Understand the requirement fully before writing any code.
2. Write the test → confirm it fails.
3. Write the simplest implementation → confirm tests pass.
4. Refactor for clarity and SOLID compliance → confirm tests still pass.
5. Review: Does this class have a single responsibility?
           Are dependencies injected?
           Is this open for extension?
```

When modifying existing code:
```
1. Write a test that reproduces the bug or covers the new behavior first.
2. Make the change.
3. Confirm all existing tests still pass.
```

---

## Hard Prohibitions

- Do NOT write production code without a failing test first.
- Do NOT create God classes or utility "dumping ground" modules.
- Do NOT use `static` for business logic (breaks DI and testability).
- Do NOT use global state.
- Do NOT suppress linter warnings without explicit justification in a comment.
- Do NOT merge code with failing tests.

---

## Definition of Done

A task is complete only when:
- [ ] All tests are written first (TDD cycle followed)
- [ ] All tests pass
- [ ] Code follows all SOLID principles
- [ ] No functions exceed 20 lines
- [ ] Code reviewed against this document

---

# Flutter-Specific

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
**Testing:** `cd app && flutter test 2>&1 > /tmp/flutter_test_result.txt; echo "EXIT_CODE=$?"`, `integration_test`.
**A11y:** 4.5:1 contrast, Semantics.
**Design:** "Wow" factor. Glassmorphism, shadows.
**i18n:**
* `flutter_localizations` + `gen-l10n`.
* ARB files in `app/lib/l10n/`. Template: `app_en.arb`.
* Add new string: 1) add key to `app_en.arb` with `@key` description, 2) add translations to other `.arb` files, 3) run `cd app && flutter gen-l10n`.
* Access via `context.l10n.keyName` (extension in `app/lib/app/extensions/build_context_extensions.dart`).
* **No hardcoded user-facing strings.** All text must come from ARB files.
**Docs:** Explain "Why". Use english.