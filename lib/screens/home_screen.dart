import 'package:flutter/material.dart';

import '../models/fee_summary.dart';
import '../widgets/app_brand_bar.dart';
import '../widgets/grid_background.dart';
import '../widgets/info_chip.dart';
import '../widgets/primary_action_button.dart';
import 'payment_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.fee});

  final FeeSummary fee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBrandBar(),
      body: GridBackground(
        child: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 34, 20, 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PARENT QUICK PAY',
                          style: TextStyle(
                            color: Color(0xFF777C86),
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.8,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'A calmer way to clear school fees.',
                          style: TextStyle(
                            color: Color(0xFF17181C),
                            fontSize: 40,
                            height: 1.05,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'See what is pending, choose how to pay, and finish in a few quiet taps.',
                          style: TextStyle(
                            color: Color(0xFF4B4F58),
                            fontSize: 17,
                            height: 1.45,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 30),
                        _FeeCard(fee: fee),
                        const SizedBox(height: 18),
                        const Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            InfoChip(
                              icon: Icons.verified_user_outlined,
                              label: 'Mock secure flow',
                            ),
                            InfoChip(
                              icon: Icons.receipt_long_outlined,
                              label: 'Instant receipt',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FeeCard extends StatelessWidget {
  const _FeeCard({required this.fee});

  final FeeSummary fee;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.school_outlined,
                  color: Color(0xFF325F9D),
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fee.childName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF17181C),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${fee.className} · ${fee.receiverName}',
                      style: const TextStyle(
                        color: Color(0xFF6B707A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Container(height: 1, color: const Color(0xFFE9EAE6)),
          const SizedBox(height: 20),
          const Text(
            'Pending Fee',
            style: TextStyle(
              color: Color(0xFF777C86),
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            fee.formattedAmount,
            style: const TextStyle(
              color: Color(0xFF17181C),
              fontSize: 38,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            fee.dueLabel,
            style: const TextStyle(
              color: Color(0xFF6B707A),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          PrimaryActionButton(
            label: 'Pay Now',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => PaymentDetailsScreen(fee: fee),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
