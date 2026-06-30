import 'package:flutter/material.dart';
import 'package:siksha360/models/fee_summary.dart';
import 'package:siksha360/utils/colors.dart';
import 'package:siksha360/utils/icons.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard({required this.fee});

  final FeeSummary fee;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PAYMENT DESK',
            style: TextStyle(
              color: AppColors.textCardMuted,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Receiver',
            style: TextStyle(
              color: AppColors.textCardMuted,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            fee.receiverName,
            style: const TextStyle(
              color: AppColors.paper,
              fontSize: 27,
              height: 1.08,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeaderChip(icon: AppIcons.person, label: fee.childName),
              _HeaderChip(icon: AppIcons.school, label: fee.className),
              _HeaderChip(icon: AppIcons.payment, label: fee.dueLabel),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.paper.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.paper.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.textCardSoft, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textCardLight,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
