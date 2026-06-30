import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/fee_summary.dart';
import '../models/payment_method.dart';
import '../models/payment_receipt.dart';
import '../utils/colors.dart';
import '../utils/icons.dart';
import '../widgets/app_brand_bar.dart';
import '../widgets/grid_background.dart';
import '../widgets/primary_action_button.dart';
import 'payment_details_screen.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({
    super.key,
    this.fee,
    this.method,
    this.transactionId,
    this.receipt,
  }) : assert(fee != null || receipt != null, 'Provide fee or receipt');

  final FeeSummary? fee;
  final PaymentMethod? method;
  final String? transactionId;
  final PaymentReceipt? receipt;

  FeeSummary get resolvedFee => receipt?.fee ?? fee!;
  PaymentMethod get resolvedMethod => receipt?.method ?? method!;
  String get resolvedTransactionId => receipt?.transactionId ?? transactionId!;

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _checkScale;
  late final Animation<double> _checkTurn;
  late final Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _checkScale =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 0.2,
              end: 1.18,
            ).chain(CurveTween(curve: Curves.easeOutBack)),
            weight: 70,
          ),
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 1.18,
              end: 1,
            ).chain(CurveTween(curve: Curves.easeOutCubic)),
            weight: 30,
          ),
        ]).animate(
          CurvedAnimation(parent: _controller, curve: const Interval(0, 0.78)),
        );

    _checkTurn = Tween<double>(begin: -0.06, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.62, curve: Curves.easeOutBack),
      ),
    );

    _contentFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.32, 1, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fee = widget.resolvedFee;
    final method = widget.resolvedMethod;
    final transactionId = widget.resolvedTransactionId;

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
                    color: AppColors.paper,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadowMedium,
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ScaleTransition(
                        scale: _checkScale,
                        child: RotationTransition(
                          turns: _checkTurn,
                          child: Container(
                            width: 82,
                            height: 82,
                            decoration: const BoxDecoration(
                              color: AppColors.accentGreenLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              AppIcons.check,
                              color: AppColors.accentGreen,
                              size: 58,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      FadeTransition(
                        opacity: _contentFade,
                        child: Column(
                          children: [
                            const Text(
                              'Payment Successful!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.ink,
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${fee.receiverName} has received your mock payment.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.textSoft,
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
                              icon: AppIcons.home,
                              onPressed: () {
                                context.go('/');
                              },
                            ),
                          ],
                        ),
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
        color: AppColors.paperAlt,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textLight,
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
                color: AppColors.ink,
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
