import 'package:flutter/material.dart';

import '../models/fee_summary.dart';
import '../widgets/app_brand_bar.dart';
import '../widgets/grid_background.dart';
import '../widgets/primary_action_button.dart';
import 'payment_success_screen.dart';

enum PaymentMethod {
  creditCard('Card', Icons.credit_card),
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
  String _selectedUpiApp = 'Google Pay';
  String _selectedBank = 'HDFC Bank';
  String? _validationMessage;

  int get _platformFee => 0;
  int get _taxes => 0;
  int get _totalPayable => widget.fee.amount + _platformFee + _taxes;

  String _formatAmount(int value) => '₹${_formatIndianCurrency(value)}';

  void _selectMethod(PaymentMethod method) {
    setState(() {
      _selectedMethod = method;
      _validationMessage = null;
    });
  }

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
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderCard(fee: fee),
                    const SizedBox(height: 14),
                    _BillBreakdownCard(
                      fee: fee,
                      platformFee: _platformFee,
                      taxes: _taxes,
                      totalPayable: _totalPayable,
                      formatAmount: _formatAmount,
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: _panelDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Choose payment option',
                                  style: TextStyle(
                                    color: Color(0xFF17181C),
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
                              for (final method in PaymentMethod.values) ...[
                                Expanded(
                                  child: _PaymentOptionButton(
                                    method: method,
                                    selected: _selectedMethod == method,
                                    onTap: () => _selectMethod(method),
                                  ),
                                ),
                                if (method != PaymentMethod.values.last)
                                  const SizedBox(width: 8),
                              ],
                            ],
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            child: _selectedMethod == null
                                ? const _MethodHint()
                                : Padding(
                                    key: ValueKey(_selectedMethod),
                                    padding: const EdgeInsets.only(top: 16),
                                    child: _PaymentMethodDetails(
                                      method: _selectedMethod!,
                                      selectedUpiApp: _selectedUpiApp,
                                      selectedBank: _selectedBank,
                                      onUpiChanged: (value) {
                                        setState(() => _selectedUpiApp = value);
                                      },
                                      onBankChanged: (value) {
                                        setState(() => _selectedBank = value);
                                      },
                                    ),
                                  ),
                          ),
                          if (_validationMessage != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              _validationMessage!,
                              style: const TextStyle(
                                color: Color(0xFFB3261E),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                          const SizedBox(height: 18),
                          PrimaryActionButton(
                            label: 'Pay ${_formatAmount(_totalPayable)}',
                            icon: Icons.lock_outline,
                            onPressed: _proceedToPay,
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
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.fee});

  final FeeSummary fee;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF17181C),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
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
              color: Color(0xFFBEC6D2),
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            fee.receiverName,
            style: const TextStyle(
              color: Colors.white,
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
              _HeaderChip(icon: Icons.person_outline, label: fee.childName),
              _HeaderChip(icon: Icons.school_outlined, label: fee.className),
              _HeaderChip(icon: Icons.event_note_outlined, label: fee.dueLabel),
            ],
          ),
        ],
      ),
    );
  }
}

class _BillBreakdownCard extends StatelessWidget {
  const _BillBreakdownCard({
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
      decoration: _panelDecoration(),
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
                  color: const Color(0xFFFFF3DD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: Color(0xFF94620D),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Bill breakdown',
                  style: TextStyle(
                    color: Color(0xFF17181C),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _BillLine(label: 'Student', value: fee.childName),
          _BillLine(label: 'Receiver', value: fee.receiverName),
          _BillLine(label: 'Fee category', value: fee.dueLabel),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFE8E9E6)),
          ),
          _BillLine(label: 'Tuition amount', value: formatAmount(fee.amount)),
          _BillLine(label: 'Platform fee', value: formatAmount(platformFee)),
          _BillLine(label: 'Taxes', value: formatAmount(taxes)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Total payable',
                    style: TextStyle(
                      color: Color(0xFF214C87),
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  formatAmount(totalPayable),
                  style: const TextStyle(
                    color: Color(0xFF17181C),
                    fontSize: 22,
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
      decoration: _softPanelDecoration(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter card details',
            style: TextStyle(
              color: Color(0xFF17181C),
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 12),
          _PaymentTextField(
            label: 'Card number',
            hint: '1234 5678 9012 3456',
            icon: Icons.credit_card,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _PaymentTextField(
                  label: 'Expiry',
                  hint: 'MM / YY',
                  icon: Icons.calendar_today_outlined,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _PaymentTextField(
                  label: 'CVV',
                  hint: '***',
                  icon: Icons.lock_outline,
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
            icon: Icons.person_outline,
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
      decoration: _softPanelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF17181C),
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF6B707A),
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
            color: selected ? const Color(0xFF17181C) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? const Color(0xFF17181C)
                  : const Color(0xFFE0E2DE),
            ),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x1D000000),
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
                color: selected ? Colors.white : const Color(0xFF4B4F58),
                size: 23,
              ),
              const SizedBox(height: 7),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  method.label,
                  maxLines: 1,
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF17181C),
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
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E2DE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E2DE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF335E9B), width: 1.4),
        ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              ),
            ),
          ),
        ],
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
          color: selected ? const Color(0xFFE9F6EF) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? const Color(0xFF2F8D62) : const Color(0xFFE0E2DE),
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected
                  ? const Color(0xFF2F8D62)
                  : const Color(0xFF9AA0AA),
              size: 18,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF17181C),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
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
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFDDE4EE), size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFF4F6F8),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
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
        color: const Color(0xFFE9F6EF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_outline, size: 15, color: Color(0xFF2F8D62)),
          SizedBox(width: 5),
          Text(
            'secured',
            style: TextStyle(
              color: Color(0xFF2F8D62),
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
      decoration: _softPanelDecoration(),
      child: const Row(
        children: [
          Icon(Icons.touch_app_outlined, color: Color(0xFF6B707A), size: 21),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Select a payment option to view the required details.',
              style: TextStyle(
                color: Color(0xFF5E636D),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _panelDecoration() {
  return BoxDecoration(
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
  );
}

BoxDecoration _softPanelDecoration() {
  return BoxDecoration(
    color: const Color(0xFFF7F7F5),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: const Color(0xFFE8E9E6)),
  );
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
