import 'package:flutter/material.dart';

import '../utils/icons.dart';

enum PaymentMethod {
  creditCard('Credit Card', AppIcons.card),
  upi('UPI', AppIcons.qr),
  netBanking('Net Banking', AppIcons.bank);

  const PaymentMethod(this.label, this.icon);

  final String label;
  final IconData icon;
}
