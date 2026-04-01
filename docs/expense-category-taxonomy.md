# Default expense taxonomy (rationale)

Built-in template id: `argent_professional_v2` (see `lib/data/local/category_seed.dart`).

## Principles

- **Fixed expenses** are recurring contractual or household staples (rent, utilities, groceries baseline, phone). Education that belongs under learning lives under **Formation** instead of Fixed.
- **Subscriptions & digital** is split out so streaming, music, cloud, and software are visible separately from rent and utilities—similar to how **Mint** and **YNAB** treat subscriptions as their own group or tag.
- **Delivery & convenience** covers variable-but-frequent spend: meal delivery, quick-commerce, couriers, laundry—not “fixed” bills but often monthly-significant (comparable to **Monzo** “Eating out” vs “Groceries” plus merchant-based insights).
- **Pets** is separate from **Health** (human) to avoid mixing vet and personal medical spend.
- **Transport → Rideshare & taxi** groups Uber, Cabify, DiDi, and street taxis in one subcategory; fuel, public transit, parking, and maintenance stay distinct for reporting.

## References (product patterns, not code)

- [Mint (Intuit) category help](https://help.mint.com/) — classic split: bills vs discretionary; subscriptions often surfaced separately in modern apps.
- [YNAB](https://www.ynab.com/) — envelope-style; common community pattern: “Subscriptions”, “Dining”, “Groceries” as distinct categories.
- [Monzo](https://monzo.com/) — merchant and category trends; frequent small delivery/restaurant spend as its own signal.

Existing installs keep their current taxonomy until a **database reset** or future migration; seed runs only on empty category tables.
