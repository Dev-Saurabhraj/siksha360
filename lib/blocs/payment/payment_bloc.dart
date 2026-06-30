import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siksha360/blocs/payment/payment_event.dart';
import 'package:siksha360/blocs/payment/payment_state.dart';
import '../../models/fee_summary.dart';
import '../../models/payment_receipt.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc({required FeeSummary fee}) : super(PaymentState(fee: fee)) {
    on<PaymentMethodSelected>(_onMethodSelected);
    on<PaymentUpiAppSelected>(_onUpiAppSelected);
    on<PaymentBankSelected>(_onBankSelected);
    on<PaymentSubmitted>(_onSubmitted);
    on<PaymentNavigationHandled>(_onNavigationHandled);
  }

  void _onMethodSelected(
    PaymentMethodSelected event,
    Emitter<PaymentState> emit,
  ) {
    emit(
      state.copyWith(
        selectedMethod: event.method,
        clearValidationMessage: true,
        status: PaymentStatus.idle,
        clearReceipt: true,
      ),
    );
  }

  void _onUpiAppSelected(
    PaymentUpiAppSelected event,
    Emitter<PaymentState> emit,
  ) {
    emit(state.copyWith(selectedUpiApp: event.upiApp));
  }

  void _onBankSelected(PaymentBankSelected event, Emitter<PaymentState> emit) {
    emit(state.copyWith(selectedBank: event.bank));
  }

  Future<void> _onSubmitted(
    PaymentSubmitted event,
    Emitter<PaymentState> emit,
  ) async {
    if (state.isProcessing) {
      return;
    }

    final selectedMethod = state.selectedMethod;
    if (selectedMethod == null) {
      emit(
        state.copyWith(
          validationMessage: 'Please select a payment method to continue.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: PaymentStatus.processing,
        clearValidationMessage: true,
        clearReceipt: true,
      ),
    );

    await Future<void>.delayed(const Duration(seconds: 2));

    emit(
      state.copyWith(
        status: PaymentStatus.success,
        receipt: PaymentReceipt(
          fee: state.fee,
          method: selectedMethod,
          transactionId: 'TXN123456789',
        ),
      ),
    );
  }

  void _onNavigationHandled(
    PaymentNavigationHandled event,
    Emitter<PaymentState> emit,
  ) {
    emit(state.copyWith(status: PaymentStatus.idle, clearReceipt: true));
  }
}
