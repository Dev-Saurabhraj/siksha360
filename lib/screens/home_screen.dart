import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/fee_summary.dart';
import '../utils/colors.dart';
import '../utils/icons.dart';
import '../widgets/app_brand_bar.dart';
import '../widgets/grid_background.dart';
import '../widgets/info_chip.dart';
import '../widgets/primary_action_button.dart';

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
                            color: AppColors.textLight,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.8,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'A calmer way to clear school fees.',
                          style: TextStyle(
                            color: AppColors.ink,
                            fontSize: 40,
                            height: 1.05,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'See what is pending, choose how to pay, and finish in a few quiet taps.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
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
                              icon: AppIcons.verify,
                              label: 'Mock secure flow',
                            ),
                            InfoChip(
                              icon: AppIcons.receipt,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.accentBlueLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  AppIcons.school,
                  color: AppColors.accentBlue,
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
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${fee.className} · ${fee.receiverName}',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Container(height: 1, color: AppColors.borderSoft),
          const SizedBox(height: 20),
          const Text(
            'Pending Fee',
            style: TextStyle(
              color: AppColors.textLight,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            fee.formattedAmount,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 38,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            fee.dueLabel,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          PrimaryActionButton(
            label: 'Pay Now',
            onPressed: () {
              context.push('/payment', extra: fee);
            },
          ),
        ],
      ),
    );
  }
}
