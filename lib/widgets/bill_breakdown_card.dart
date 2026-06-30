import 'package:flutter/material.dart';
import 'package:siksha360/models/fee_summary.dart';
import 'package:siksha360/utils/box_decoration.dart';
import 'package:siksha360/utils/colors.dart';
import 'package:siksha360/utils/icons.dart';

import 'dashed_divider.dart';

class BillBreakdownCard extends StatelessWidget {
  const BillBreakdownCard({super.key,
    required this.fee,
    required this.platformFee,
    required this.taxes,
    required this.totalPayable,
    required this.formatAmount,
  });

  final FeeSummary fee;
  final int platformFee;
  final int taxes;
  final int totalPayable;
  final String Function(int value) formatAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.accentGoldLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  AppIcons.receipt,
                  color: AppColors.accentGold,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Bill breakdown',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _BillLine(label: 'Student', value: fee.childName),
          _BillLine(label: 'Receiver type', value: fee.receiverType),
          _BillLine(label: 'Fee category', value: fee.dueLabel),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CustomPaint(
              size: const Size(double.infinity, 2),
              painter: DashedPainter(),
            ),
          ),
          _BillLine(label: 'Tuition amount', value: formatAmount(fee.amount)),
          _BillLine(label: 'Platform fee', value: formatAmount(platformFee)),
          _BillLine(label: 'Taxes', value: formatAmount(taxes)),
          const SizedBox(height: 10),
          CustomPaint(
            size: const Size(double.infinity, 2),
            painter: DashedPainter(),
          ),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Total payable',
                  style: TextStyle(
                    color: AppColors.accentBlueDeep,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                formatAmount(totalPayable),
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BillLine extends StatelessWidget {
  const _BillLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final labelWidth = constraints.maxWidth < 360 ? 108.0 : 150.0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 9),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: labelWidth,
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  softWrap: true,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
