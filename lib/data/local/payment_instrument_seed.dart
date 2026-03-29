import 'package:drift/drift.dart';

import 'package:expense_app/data/local/app_database.dart';

/// Inserts two default card profiles when the book has no payment instruments.
abstract final class PaymentInstrumentSeeder {
  static const String kNaranjaId = 'pi_seed_naranja';
  static const String kGaliciaId = 'pi_seed_galicia';

  static Future<void> ensureSeedData(AppDatabase db) async {
    final existing = await (db.select(db.paymentInstruments)..limit(1)).get();
    if (existing.isNotEmpty) {
      return;
    }
    await db.batch((b) {
      b.insert(
        db.paymentInstruments,
        PaymentInstrumentsCompanion.insert(
          id: kNaranjaId,
          label: 'Naranja',
          bankName: const Value('Naranja X'),
          billingCycleDay: const Value(10),
          statementClosingDay: const Value(5),
          paymentDueDay: const Value(18),
          nominalAprPercent: const Value(78.5),
          creditLimit: const Value(1_500_000),
          displaySuffix: const Value('··'),
          feeDescription: const Value('Issuer fees vary; no PAN stored.'),
          isDefault: const Value(true),
        ),
      );
      b.insert(
        db.paymentInstruments,
        PaymentInstrumentsCompanion.insert(
          id: kGaliciaId,
          label: 'Galicia',
          bankName: const Value('Banco Galicia'),
          billingCycleDay: const Value(12),
          statementClosingDay: const Value(10),
          paymentDueDay: const Value(25),
          nominalAprPercent: const Value(55.0),
          creditLimit: const Value(3_000_000),
          displaySuffix: const Value('··'),
          feeDescription: const Value('Visa/Master profile; metadata only.'),
          isDefault: const Value(false),
        ),
      );
    });
  }
}
