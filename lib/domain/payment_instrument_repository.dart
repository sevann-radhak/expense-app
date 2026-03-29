import 'package:expense_app/domain/payment_instrument.dart';

/// Persistence for card (payment instrument) **profiles** — metadata only.
abstract class PaymentInstrumentRepository {
  Stream<List<PaymentInstrument>> watchPaymentInstruments();

  Future<void> create(PaymentInstrument instrument);

  Future<void> update(PaymentInstrument instrument);

  Future<void> deleteById(String id);
}
