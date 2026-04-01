---
description: Code style, i18n, testing, comments, lint, money and dates
globs: "**/*.dart,**/test/**/*,**/pubspec.yaml"
alwaysApply: false
---

# Implementation Standards

## Language

- **Code, identifiers, commits, technical docs:** English.
- **User-visible strings:** only in ARB / `intl` files; **no** hardcoded UI copy in widgets.
- Prepare **ICU placeholders** for dynamic values (amounts, dates).

## Style

- Run `dart format` and `flutter analyze` clean in CI.
- Follow **effective Dart**; prefer `final`, `const`, named constructors.
- **Avoid** redundant comments; document **non-obvious** invariants (e.g. money scale, timezone policy) once in domain or README.

## Money

- Centralize formatting: **currency symbol** from user settings + `intl` NumberFormat.
- No floating-point accumulation for totals; use integer minor units or a small `Money` value type.

## Dates

- **`occurredOn` is date-only (decided):** no time component in product semantics. Implement with a **date-only** type or `YYYY-MM-DD` + parsing; if `DateTime` is used internally, normalize and **never** show or edit clock time in UI.

## State and UI separation

- Widgets **subscribe** to state; business logic lives in **notifiers** / **blocs** / use cases — not in `build()`.

## Testing

- **Unit tests:** domain + use cases (required for non-trivial rules).
- **Widget tests:** primary flows (add expense, month list).
- **Golden tests:** optional for key screens later.

## Dependencies

- Minimize packages; prefer maintained, widely used libs. Pin versions in `pubspec.yaml` for reproducibility.

## Secrets

- No API keys in repo; use `--dart-define` or env for future FX providers.
