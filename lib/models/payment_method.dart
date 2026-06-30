import 'package:flutter/material.dart';

enum PaymentMethod {
  creditCard('Credit Card', Icons.credit_card),
  upi('UPI', Icons.qr_code_2),
  netBanking('Net Banking', Icons.account_balance_outlined);

  const PaymentMethod(this.label, this.icon);

  final String label;
  final IconData icon;
}
