import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:siksha360/blocs/payment/payment_bloc.dart';
import 'package:siksha360/blocs/payment/payment_event.dart';
import 'package:siksha360/blocs/payment/payment_state.dart';
import 'package:siksha360/utils/box_decoration.dart';
import 'package:siksha360/widgets/bill_breakdown_card.dart';
import 'package:siksha360/widgets/header_card.dart';
import 'package:siksha360/widgets/processing_overlay.dart';
import '../models/fee_summary.dart';
import '../models/payment_method.dart';
import '../models/payment_receipt.dart';
import '../utils/colors.dart';
import '../utils/icons.dart';
import '../widgets/app_brand_bar.dart';
import '../widgets/grid_background.dart';
import '../widgets/primary_action_button.dart';

class PaymentDetailsScreen extends StatelessWidget {
  const PaymentDetailsScreen({super.key, required this.fee});

  final FeeSummary fee;

  String _formatAmount(int value) => '₹${_formatIndianCurrency(value)}';

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state.status == PaymentStatus.success && state.receipt != null) {
          context.read<PaymentBloc>().add(const PaymentNavigationHandled());
          context.push('/success', extra: state.receipt!);
        }
      },
      child: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          final fee = state.fee;
          final selectedMethod = state.selectedMethod;
          final totalPayable = state.totalPayable;
          final validationMessage = state.validationMessage;
          final isProcessing = state.isProcessing;

          return Scaffold(
            appBar: const AppBrandBar(showBackButton: true),
            body: Stack(
              children: [
                GridBackground(
                  child: SafeArea(
                    top: false,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 680),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Payment Details',
                                style: TextStyle(
                                  color: AppColors.ink,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 12),
                              HeaderCard(fee: fee),
                              const SizedBox(height: 14),
                              BillBreakdownCard(
                                fee: fee,
                                platformFee: state.platformFee,
                                taxes: state.taxes,
                                totalPayable: totalPayable,
                                formatAmount: _formatAmount,
                              ),
                              const SizedBox(height: 14),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(18),
                                decoration: panelDecoration(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Text(
                                            'Choose payment option',
                                            style: TextStyle(
                                              color: AppColors.ink,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                        _SecureBadge(),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    Row(
                                      children: [
                                        for (final method
                                            in PaymentMethod.values) ...[
                                          Expanded(
                                            child: _PaymentOptionButton(
                                              method: method,
                                              selected:
                                                  selectedMethod == method,
                                              onTap: () => context
                                                  .read<PaymentBloc>()
                                                  .add(
                                                    PaymentMethodSelected(
                                                      method,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                          if (method !=
                                              PaymentMethod.values.last)
                                            const SizedBox(width: 8),
                                        ],
                                      ],
                                    ),
                                    AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                      child: selectedMethod == null
                                          ? const _MethodHint()
                                          : Padding(
                                              key: ValueKey(selectedMethod),
                                              padding: const EdgeInsets.only(
                                                top: 16,
                                              ),
                                              child: _PaymentMethodDetails(
                                                method: selectedMethod!,
                                                selectedUpiApp:
                                                    state.selectedUpiApp,
                                                selectedBank:
                                                    state.selectedBank,
                                                onUpiChanged: (value) {
                                                  context
                                                      .read<PaymentBloc>()
                                                      .add(
                                                        PaymentUpiAppSelected(
                                                          value,
                                                        ),
                                                      );
                                                },
                                                onBankChanged: (value) {
                                                  context
                                                      .read<PaymentBloc>()
                                                      .add(
                                                        PaymentBankSelected(
                                                          value,
                                                        ),
                                                      );
                                                },
                                              ),
                                            ),
                                    ),
                                    if (validationMessage != null) ...[
                                      const SizedBox(height: 12),
                                      Text(
                                        validationMessage,
                                        style: const TextStyle(
                                          color: AppColors.danger,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 18),
                                    PrimaryActionButton(
                                      label: isProcessing
                                          ? 'Processing...'
                                          : 'Proceed to Pay',
                                      icon: isProcessing
                                          ? AppIcons.processing
                                          : AppIcons.secure,
                                      onPressed: () {
                                        context.read<PaymentBloc>().add(
                                          const PaymentSubmitted(),
                                        );
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
                if (isProcessing) const ProcessingOverlay(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PaymentMethodDetails extends StatelessWidget {
  const _PaymentMethodDetails({
    required this.method,
    required this.selectedUpiApp,
    required this.selectedBank,
    required this.onUpiChanged,
    required this.onBankChanged,
  });

  final PaymentMethod method;
  final String selectedUpiApp;
  final String selectedBank;
  final ValueChanged<String> onUpiChanged;
  final ValueChanged<String> onBankChanged;

  @override
  Widget build(BuildContext context) {
    return switch (method) {
      PaymentMethod.creditCard => const _CardDetailsForm(),
      PaymentMethod.upi => _ChoicePanel(
        title: 'Pay with UPI app',
        subtitle: 'Select the app installed on your phone.',
        options: const ['Google Pay', 'PhonePe', 'Paytm', 'BHIM'],
        selectedOption: selectedUpiApp,
        onChanged: onUpiChanged,
      ),
      PaymentMethod.netBanking => _ChoicePanel(
        title: 'Select your bank',
        subtitle: 'You will be redirected to the bank login page.',
        options: const [
          'HDFC Bank',
          'State Bank of India',
          'ICICI Bank',
          'Axis Bank',
        ],
        selectedOption: selectedBank,
        onChanged: onBankChanged,
      ),
    };
  }
}

class _CardDetailsForm extends StatelessWidget {
  const _CardDetailsForm();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: softPanelDecoration(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter card details',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 12),
          _PaymentTextField(
            label: 'Card number',
            hint: '1234 5678 9012 3456',
            icon: AppIcons.card,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _PaymentTextField(
                  label: 'Expiry',
                  hint: 'MM / YY',
                  icon: AppIcons.calendar,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _PaymentTextField(
                  label: 'CVV',
                  hint: '***',
                  icon: AppIcons.secure,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          _PaymentTextField(
            label: 'Name on card',
            hint: 'Parent or guardian name',
            icon: AppIcons.person,
          ),
        ],
      ),
    );
  }
}

class _ChoicePanel extends StatelessWidget {
  const _ChoicePanel({
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final List<String> options;
  final String selectedOption;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: softPanelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final option in options)
                _SelectablePill(
                  label: option,
                  selected: selectedOption == option,
                  onTap: () => onChanged(option),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentOptionButton extends StatelessWidget {
  const _PaymentOptionButton({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: method.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 82,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.ink : AppColors.paper,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? AppColors.ink : AppColors.borderMuted,
            ),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: AppColors.shadowStrong,
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                method.icon,
                color: selected ? AppColors.paper : AppColors.textSecondary,
                size: 23,
              ),
              const SizedBox(height: 7),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  method.label,
                  maxLines: 1,
                  style: TextStyle(
                    color: selected ? AppColors.paper : AppColors.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentTextField extends StatelessWidget {
  const _PaymentTextField({
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 19),
        filled: true,
        fillColor: AppColors.paper,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderMuted),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderMuted),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.accentBlueBorder,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}

class _SelectablePill extends StatelessWidget {
  const _SelectablePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentGreenLight : AppColors.paper,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.accentGreen : AppColors.borderMuted,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? AppIcons.check : AppIcons.circle,
              color: selected ? AppColors.accentGreen : AppColors.neutral,
              size: 18,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.ink,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecureBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.accentGreenLight,
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AppIcons.secure, size: 15, color: AppColors.accentGreen),
          SizedBox(width: 5),
          Text(
            'secured',
            style: TextStyle(
              color: AppColors.accentGreen,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodHint extends StatelessWidget {
  const _MethodHint();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(14),
      decoration: softPanelDecoration(),
      child: const Row(
        children: [
          Icon(AppIcons.touch, color: AppColors.textMuted, size: 21),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Select a payment option to view the required details.',
              style: TextStyle(
                color: AppColors.textHint,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatIndianCurrency(int value) {
  final digits = value.toString();
  if (digits.length <= 3) {
    return digits;
  }

  final lastThree = digits.substring(digits.length - 3);
  var remaining = digits.substring(0, digits.length - 3);
  final pairs = <String>[];

  while (remaining.length > 2) {
    pairs.insert(0, remaining.substring(remaining.length - 2));
    remaining = remaining.substring(0, remaining.length - 2);
  }

  if (remaining.isNotEmpty) {
    pairs.insert(0, remaining);
  }

  return '${pairs.join(',')},$lastThree';
}
