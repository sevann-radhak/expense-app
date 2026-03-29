import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/data/local/drift_payment_instrument_repository.dart';
import 'package:expense_app/domain/domain.dart';

void main() {
  late AppDatabase db;
  late DriftPaymentInstrumentRepository repo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.customSelect('SELECT 1').getSingle();
    repo = DriftPaymentInstrumentRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('create update delete and watch order by label', () async {
    final a = PaymentInstrument(
      id: 'pi_a',
      label: 'Alpha Card',
      bankName: 'Bank A',
      billingCycleDay: 5,
    );
    final b = PaymentInstrument(
      id: 'pi_b',
      label: 'Beta Card',
    );
    await repo.create(a);
    await repo.create(b);

    final first = await repo.watchPaymentInstruments().first;
    expect(first.map((e) => e.id).toList(), ['pi_a', 'pi_b']);

    await repo.update(
      a.copyWith(label: 'Zebra Card', clearBankName: true),
    );
    final after = await repo.watchPaymentInstruments().first;
    expect(after.map((e) => e.id).toList(), ['pi_b', 'pi_a']);
    expect(after.last.bankName, isNull);

    await repo.deleteById('pi_b');
    expect(await repo.watchPaymentInstruments().first, hasLength(1));
  });

  test('create rejects empty label', () async {
    expect(
      () => repo.create(
        const PaymentInstrument(id: 'x', label: '   '),
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('create rejects invalid billing day', () async {
    expect(
      () => repo.create(
        const PaymentInstrument(
          id: 'x',
          label: 'L',
          billingCycleDay: 32,
        ),
      ),
      throwsA(isA<ArgumentError>()),
    );
  });
}
