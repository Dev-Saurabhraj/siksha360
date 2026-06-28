class FeeSummary {
  const FeeSummary({
    required this.childName,
    required this.className,
    required this.receiverName,
    required this.receiverType,
    required this.amount,
    required this.dueLabel,
  });

  final String childName;
  final String className;
  final String receiverName;
  final String receiverType;
  final int amount;
  final String dueLabel;

  String get formattedAmount => '₹${_formatIndianCurrency(amount)}';
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
