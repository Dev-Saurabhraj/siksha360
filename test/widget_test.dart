import 'package:flutter_test/flutter_test.dart';
import 'package:siksha360/main.dart';

void main() {
  testWidgets('fee payment flow validates, completes, and returns home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const Siksha360App());

    expect(find.text('Siksha360'), findsNothing);
    expect(find.text('Aarav Sharma'), findsOneWidget);
    expect(find.text('Pending Fee'), findsOneWidget);
    expect(find.text('₹12,500'), findsOneWidget);

    await tester.ensureVisible(find.text('Pay Now'));
    await tester.tap(find.text('Pay Now'));
    await tester.pumpAndSettle();

    expect(find.text('Payment Details'), findsOneWidget);
    expect(find.text('Receiver'), findsOneWidget);
    expect(find.text('Bright Future School'), findsOneWidget);

    await tester.ensureVisible(find.text('Proceed to Pay'));
    await tester.tap(find.text('Proceed to Pay'));
    await tester.pump();

    expect(
      find.text('Please select a payment method to continue.'),
      findsOneWidget,
    );

    await tester.ensureVisible(find.text('Credit Card'));
    await tester.tap(find.text('Credit Card'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Proceed to Pay'));
    await tester.tap(find.text('Proceed to Pay'));
    await tester.pumpAndSettle();

    expect(find.text('Payment Successful!'), findsOneWidget);
    expect(find.text('Payment Method'), findsOneWidget);
    expect(find.text('Credit Card'), findsOneWidget);
    expect(find.text('TXN123456789'), findsOneWidget);

    await tester.ensureVisible(find.text('Back to Home'));
    await tester.tap(find.text('Back to Home'));
    await tester.pumpAndSettle();

    expect(find.text('Aarav Sharma'), findsOneWidget);
    expect(find.text('Pay Now'), findsOneWidget);
  });
}
