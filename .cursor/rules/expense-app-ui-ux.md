---
description: UI/UX — intuitive flows, charts, motion, accessibility, empty states
globs: "**/presentation/**/*,**/widgets/**/*,**/*_page.dart,**/*_screen.dart"
alwaysApply: false
---

# UI / UX Rules

## Principles

- **Intuitive first:** primary actions (add expense, pick month) reachable in ≤2 taps from home.
- **Readable reports:** large totals, clear labels, **accessible colors** (contrast WCAG AA where feasible).
- **Forgiving input:** validation messages explain how to fix; preserve form state on error.

## Visual design

- Use **Material 3** (or documented design system). Consistent spacing (8px grid), typography scale, rounded corners.
- **Charts:** pie/donut for category share; bar for monthly trend; tooltips with formatted money.
- **Motion:** subtle transitions (page, list insert); respect **reduced motion** OS setting.

## Imagery and branding

- Illustrations for empty states (no expenses, no categories); optional app icon assets in `assets/`; compress images.

## Navigation

- Clear information architecture: **Home / Month** → **Expense detail**; **Reports**; **Settings**; **Categories** management.
- **Web-first:** optimize for **pointer + keyboard** and responsive width; then adapt to **bottom nav** on narrow native mobile. Use side nav or top tabs where appropriate on desktop web.

## Accessibility

- Semantic labels for icons; screen reader strings for charts (summary text alternative).
- Tap targets ≥ 48dp; support text scaling.

## Localization

- All strings via ARB; RTL-ready layouts where possible (future).

## Performance

- Virtualize long expense lists; avoid rebuilding heavy charts on every keystroke (debounce).
