import 'package:flutter/material.dart';

import '../models/fee_summary.dart';
import '../widgets/app_brand_bar.dart';
import '../widgets/grid_background.dart';
import '../widgets/primary_action_button.dart';
import 'payment_success_screen.dart';

enum PaymentMethod {
  creditCard('Credit Card', Icons.credit_card),
  upi('UPI', Icons.qr_code_2),
  netBanking('Net Banking', Icons.account_balance_outlined);

  const PaymentMethod(this.label, this.icon);

  final String label;
  final IconData icon;
}

class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({super.key, required this.fee});

  final FeeSummary fee;

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  PaymentMethod? _selectedMethod;
  String? _validationMessage;

  void _proceedToPay() {
    final selectedMethod = _selectedMethod;
    if (selectedMethod == null) {
      setState(() {
        _validationMessage = 'Please select a payment method to continue.';
      });
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PaymentSuccessScreen(
          fee: widget.fee,
          method: selectedMethod,
          transactionId: 'TXN123456789',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fee = widget.fee;

    return Scaffold(
      appBar: const AppBrandBar(showBackButton: true),
      body: GridBackground(
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE3E4E0)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Payment Details',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF17181C),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE9F6EF),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  size: 15,
                                  color: Color(0xFF2F8D62),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'secured',
                                  style: TextStyle(
                                    color: Color(0xFF2F8D62),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      _PaymentInfoRow(
                        label: 'Receiver',
                        value: fee.receiverName,
                        icon: Icons.apartment_outlined,
                      ),
                      _PaymentInfoRow(
                        label: 'Type',
                        value: fee.receiverType,
                        icon: Icons.badge_outlined,
                      ),
                      _PaymentInfoRow(
                        label: 'Amount',
                        value: fee.formattedAmount,
                        icon: Icons.currency_rupee,
                        isAmount: true,
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'Select Payment Method',
                        style: TextStyle(
                          color: Color(0xFF17181C),
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (final method in PaymentMethod.values) ...[
                        _PaymentMethodTile(
                          method: method,
                          selected: _selectedMethod == method,
                          onTap: () {
                            setState(() {
                              _selectedMethod = method;
                              _validationMessage = null;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                      if (_validationMessage != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          _validationMessage!,
                          style: const TextStyle(
                            color: Color(0xFFB3261E),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      PrimaryActionButton(
                        label: 'Proceed to Pay',
                        onPressed: _proceedToPay,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentInfoRow extends StatelessWidget {
  const _PaymentInfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.isAmount = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool isAmount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F3F1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF5E636D), size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF767B85),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    color: const Color(0xFF17181C),
                    fontSize: isAmount ? 24 : 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAF1FF) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? const Color(0xFF335E9B) : const Color(0xFFE0E2DE),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected
                  ? const Color(0xFF335E9B)
                  : const Color(0xFF9AA0AA),
            ),
            const SizedBox(width: 12),
            Icon(method.icon, color: const Color(0xFF17181C), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                method.label,
                style: const TextStyle(
                  color: Color(0xFF17181C),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
