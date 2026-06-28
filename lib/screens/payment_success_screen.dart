import 'package:flutter/material.dart';

import '../models/fee_summary.dart';
import '../widgets/app_brand_bar.dart';
import '../widgets/grid_background.dart';
import '../widgets/primary_action_button.dart';
import 'payment_details_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({
    super.key,
    required this.fee,
    required this.method,
    required this.transactionId,
  });

  final FeeSummary fee;
  final PaymentMethod method;
  final String transactionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBrandBar(),
      body: GridBackground(
        child: SafeArea(
          top: false,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE3E4E0)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 82,
                        height: 82,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE9F6EF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Color(0xFF2F8D62),
                          size: 58,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Payment Successful!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF17181C),
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${fee.receiverName} has received your mock payment.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF60656F),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _ReceiptLine(
                        label: 'Amount Paid',
                        value: fee.formattedAmount,
                      ),
                      _ReceiptLine(
                        label: 'Payment Method',
                        value: method.label,
                      ),
                      _ReceiptLine(
                        label: 'Transaction ID',
                        value: transactionId,
                      ),
                      const SizedBox(height: 24),
                      PrimaryActionButton(
                        label: 'Back to Home',
                        icon: Icons.home_outlined,
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        },
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

class _ReceiptLine extends StatelessWidget {
  const _ReceiptLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF777C86),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF17181C),
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
