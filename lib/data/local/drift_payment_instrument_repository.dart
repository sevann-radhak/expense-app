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
    void checkDay(int? d, String name) {
      if (d != null && (d < 1 || d > 31)) {
        throw ArgumentError.value(d, name, 'must be 1–31 or null');
      }
    }

    checkDay(p.billingCycleDay, 'billingCycleDay');
    checkDay(p.statementClosingDay, 'statementClosingDay');
    checkDay(p.paymentDueDay, 'paymentDueDay');
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
      isActive: r.isActive,
      isDefault: r.isDefault,
      statementClosingDay: r.statementClosingDay,
      paymentDueDay: r.paymentDueDay,
      nominalAprPercent: r.nominalAprPercent,
      creditLimit: r.creditLimit,
      displaySuffix: r.displaySuffix,
    );
  }

  PaymentInstrumentRow _toRow(PaymentInstrument p) {
    return PaymentInstrumentRow(
      id: p.id,
      label: p.label.trim(),
      bankName: _trimOrNull(p.bankName),
      billingCycleDay: p.billingCycleDay,
      annualFeeAmount: p.annualFeeAmount,
      monthlyFeeAmount: p.monthlyFeeAmount,
      feeDescription: p.feeDescription?.trim() ?? '',
      isActive: p.isActive,
      isDefault: p.isDefault,
      statementClosingDay: p.statementClosingDay,
      paymentDueDay: p.paymentDueDay,
      nominalAprPercent: p.nominalAprPercent,
      creditLimit: p.creditLimit,
      displaySuffix: _trimOrNull(p.displaySuffix),
    );
  }

  Future<void> _normalizeDefaultFlags() async {
    final rows = await (_db.select(_db.paymentInstruments)
          ..orderBy([(t) => OrderingTerm.asc(t.label)]))
        .get();
    if (rows.isEmpty) {
      return;
    }
    final active = rows.where((r) => r.isActive).toList();
    if (active.isEmpty) {
      for (final r in rows) {
        if (r.isDefault) {
          await (_db.update(_db.paymentInstruments)..where((t) => t.id.equals(r.id)))
              .write(const PaymentInstrumentsCompanion(isDefault: Value(false)));
        }
      }
      return;
    }
    final defaults = active.where((r) => r.isDefault).toList();
    final PaymentInstrumentRow keep;
    if (defaults.length == 1) {
      keep = defaults.single;
    } else if (defaults.isEmpty) {
      keep = active.first;
    } else {
      keep = defaults.first;
    }
    for (final r in rows) {
      final shouldDefault = r.id == keep.id && r.isActive;
      if (r.isDefault != shouldDefault) {
        await (_db.update(_db.paymentInstruments)..where((t) => t.id.equals(r.id)))
            .write(PaymentInstrumentsCompanion(isDefault: Value(shouldDefault)));
      }
    }
  }

  Future<void> _clearOtherDefaults(String exceptId) async {
    final rows = await _db.select(_db.paymentInstruments).get();
    for (final r in rows) {
      if (r.id != exceptId && r.isDefault) {
        await (_db.update(_db.paymentInstruments)..where((t) => t.id.equals(r.id)))
            .write(const PaymentInstrumentsCompanion(isDefault: Value(false)));
      }
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
    final count = await _db.select(_db.paymentInstruments).get();
    var next = instrument;
    if (count.isEmpty) {
      next = next.copyWith(isDefault: true, isActive: true);
    } else if (next.isDefault) {
      await _clearOtherDefaults(next.id);
    }
    await _db.into(_db.paymentInstruments).insert(
          PaymentInstrumentsCompanion.insert(
            id: next.id,
            label: next.label.trim(),
            bankName: Value(_trimOrNull(next.bankName)),
            billingCycleDay: Value(next.billingCycleDay),
            annualFeeAmount: Value(next.annualFeeAmount),
            monthlyFeeAmount: Value(next.monthlyFeeAmount),
            feeDescription: Value(next.feeDescription?.trim() ?? ''),
            isActive: Value(next.isActive),
            isDefault: Value(next.isDefault),
            statementClosingDay: Value(next.statementClosingDay),
            paymentDueDay: Value(next.paymentDueDay),
            nominalAprPercent: Value(next.nominalAprPercent),
            creditLimit: Value(next.creditLimit),
            displaySuffix: Value(_trimOrNull(next.displaySuffix)),
          ),
        );
    await _normalizeDefaultFlags();
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
    if (instrument.isDefault) {
      await _clearOtherDefaults(instrument.id);
    }
    await _db.update(_db.paymentInstruments).replace(_toRow(instrument));
    await _normalizeDefaultFlags();
  }

  @override
  Future<void> deleteById(String id) async {
    await (_db.delete(_db.paymentInstruments)..where((t) => t.id.equals(id))).go();
    await _normalizeDefaultFlags();
  }
}
