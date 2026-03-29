import 'package:drift/drift.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/domain/domain.dart';

class DriftPaymentInstrumentRepository implements PaymentInstrumentRepository {
  DriftPaymentInstrumentRepository(this._db);

  final AppDatabase _db;

  static String? _trimOrNull(String? s) {
    if (s == null) {
      return null;
    }
    final t = s.trim();
    return t.isEmpty ? null : t;
  }

  static void _validate(PaymentInstrument p) {
    if (p.label.trim().isEmpty) {
      throw ArgumentError('label must not be empty');
    }
    final d = p.billingCycleDay;
    if (d != null && (d < 1 || d > 31)) {
      throw ArgumentError.value(d, 'billingCycleDay', 'must be 1–31 or null');
    }
  }

  @override
  Stream<List<PaymentInstrument>> watchPaymentInstruments() {
    return (_db.select(_db.paymentInstruments)
          ..orderBy([(t) => OrderingTerm.asc(t.label)]))
        .watch()
        .map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<void> create(PaymentInstrument instrument) async {
    _validate(instrument);
    await _db.into(_db.paymentInstruments).insert(
          PaymentInstrumentsCompanion.insert(
            id: instrument.id,
            label: instrument.label.trim(),
            bankName: Value(_trimOrNull(instrument.bankName)),
            billingCycleDay: Value(instrument.billingCycleDay),
            annualFeeAmount: Value(instrument.annualFeeAmount),
            monthlyFeeAmount: Value(instrument.monthlyFeeAmount),
            feeDescription: Value(instrument.feeDescription?.trim() ?? ''),
          ),
        );
  }

  @override
  Future<void> update(PaymentInstrument instrument) async {
    _validate(instrument);
    final existing = await (_db.select(_db.paymentInstruments)
          ..where((t) => t.id.equals(instrument.id)))
        .getSingleOrNull();
    if (existing == null) {
      throw StateError('Payment instrument not found: ${instrument.id}');
    }
    await _db.update(_db.paymentInstruments).replace(
          PaymentInstrumentRow(
            id: instrument.id,
            label: instrument.label.trim(),
            bankName: _trimOrNull(instrument.bankName),
            billingCycleDay: instrument.billingCycleDay,
            annualFeeAmount: instrument.annualFeeAmount,
            monthlyFeeAmount: instrument.monthlyFeeAmount,
            feeDescription: instrument.feeDescription?.trim() ?? '',
          ),
        );
  }

  @override
  Future<void> deleteById(String id) async {
    await (_db.delete(_db.paymentInstruments)..where((t) => t.id.equals(id))).go();
  }

  PaymentInstrument _toDomain(PaymentInstrumentRow r) {
    return PaymentInstrument(
      id: r.id,
      label: r.label,
      bankName: r.bankName,
      billingCycleDay: r.billingCycleDay,
      annualFeeAmount: r.annualFeeAmount,
      monthlyFeeAmount: r.monthlyFeeAmount,
      feeDescription: r.feeDescription.isEmpty ? null : r.feeDescription,
    );
  }
}
