import 'package:drift/drift.dart';

import 'package:expense_app/data/local/app_database.dart';

/// Demo card profiles (Naranja, Galicia). **Not** applied on app install or DB reset;
/// call [populateExamplePaymentInstruments] from [populateExampleDemoData] only.
abstract final class PaymentInstrumentSeeder {
  static const String kNaranjaId = 'pi_seed_naranja';
  static const String kGaliciaId = 'pi_seed_galicia';

  /// Removes prior demo rows and inserts fresh Naranja + Galicia (idempotent for demo).
  static Future<void> populateExamplePaymentInstruments(AppDatabase db) async {
    await db.transaction(() async {
      await (db.delete(db.paymentInstruments)
            ..where((t) => t.id.isIn([kNaranjaId, kGaliciaId])))
          .go();
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
    });
    await db.backfillPaymentInstrumentDefaultsIfNeeded();
  }
}
