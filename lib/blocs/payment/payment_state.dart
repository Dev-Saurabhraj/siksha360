import 'package:siksha360/models/fee_summary.dart';
import 'package:siksha360/models/payment_method.dart';
import 'package:siksha360/models/payment_receipt.dart';

enum PaymentStatus { idle, processing, success }

class PaymentState {
  const PaymentState({
    required this.fee,
    this.selectedMethod,
    this.selectedUpiApp = 'Google Pay',
    this.selectedBank = 'HDFC Bank',
    this.validationMessage,
    this.status = PaymentStatus.idle,
    this.receipt,
  });

  final FeeSummary fee;
  final PaymentMethod? selectedMethod;
  final String selectedUpiApp;
  final String selectedBank;
  final String? validationMessage;
  final PaymentStatus status;
  final PaymentReceipt? receipt;

  int get platformFee => 0;
  int get taxes => 0;
  int get totalPayable => fee.amount + platformFee + taxes;
  bool get isProcessing => status == PaymentStatus.processing;

  PaymentState copyWith({
    PaymentMethod? selectedMethod,
    String? selectedUpiApp,
    String? selectedBank,
    String? validationMessage,
    bool clearValidationMessage = false,
    PaymentStatus? status,
    PaymentReceipt? receipt,
    bool clearReceipt = false,
  }) {
    return PaymentState(
      fee: fee,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      selectedUpiApp: selectedUpiApp ?? this.selectedUpiApp,
      selectedBank: selectedBank ?? this.selectedBank,
      validationMessage: clearValidationMessage
          ? null
          : validationMessage ?? this.validationMessage,
      status: status ?? this.status,
      receipt: clearReceipt ? null : receipt ?? this.receipt,
    );
  }
}
