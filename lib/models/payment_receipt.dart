import 'fee_summary.dart';
import 'payment_method.dart';

class PaymentReceipt {
  const PaymentReceipt({
    required this.fee,
    required this.method,
    required this.transactionId,
  });

  final FeeSummary fee;
  final PaymentMethod method;
  final String transactionId;
}
