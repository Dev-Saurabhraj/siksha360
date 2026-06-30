import 'package:siksha360/models/payment_method.dart';

sealed class PaymentEvent {
  const PaymentEvent();
}

class PaymentMethodSelected extends PaymentEvent {
  const PaymentMethodSelected(this.method);

  final PaymentMethod method;
}

class PaymentUpiAppSelected extends PaymentEvent {
  const PaymentUpiAppSelected(this.upiApp);

  final String upiApp;
}

class PaymentBankSelected extends PaymentEvent {
  const PaymentBankSelected(this.bank);

  final String bank;
}

class PaymentSubmitted extends PaymentEvent {
  const PaymentSubmitted();
}

class PaymentNavigationHandled extends PaymentEvent {
  const PaymentNavigationHandled();
}
