import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/data/local/payment_instrument_seed.dart';

void main() {
  test('populateExamplePaymentInstruments replaces demo rows and is idempotent',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() async => db.close());
    await db.customSelect('SELECT 1').getSingle();

    await db.into(db.paymentInstruments).insert(
          PaymentInstrumentsCompanion.insert(
            id: 'pi_other',
            label: 'Other card',
          ),
        );

    await PaymentInstrumentSeeder.populateExamplePaymentInstruments(db);
    final rows = await db.select(db.paymentInstruments).get();
    expect(rows.length, 3);
    final demo = rows.where((r) => r.id.startsWith('pi_seed_')).toList();
    expect(demo.length, 2);
    expect(
      rows.where((r) => r.id == PaymentInstrumentSeeder.kNaranjaId).single.isDefault,
      isTrue,
    );

    await PaymentInstrumentSeeder.populateExamplePaymentInstruments(db);
    final again = await db.select(db.paymentInstruments).get();
    expect(again.length, 3);
    expect(
      again.where((r) => r.id.startsWith('pi_seed_')).length,
      2,
    );
  });
}
