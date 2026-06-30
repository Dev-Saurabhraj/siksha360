import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'blocs/payment/payment_bloc.dart';
import 'data/mock_fee_data.dart';
import 'models/fee_summary.dart';
import 'models/payment_method.dart';
import 'models/payment_receipt.dart';
import 'screens/home_screen.dart';
import 'screens/payment_details_screen.dart';
import 'screens/payment_success_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const home = 'home';
  static const payment = 'payment';
  static const success = 'success';
}

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: AppRoutes.home,
      builder: (context, state) => const HomeScreen(fee: mockPendingFee),
    ),
    GoRoute(
      path: '/payment',
      name: AppRoutes.payment,
      builder: (context, state) {
        final fee = state.extra is FeeSummary
            ? state.extra! as FeeSummary
            : mockPendingFee;

        return BlocProvider(
          create: (_) => PaymentBloc(fee: fee),
          child: PaymentDetailsScreen(fee: fee),
        );
      },
    ),
    GoRoute(
      path: '/success',
      name: AppRoutes.success,
      pageBuilder: (context, state) {
        final receipt = state.extra is PaymentReceipt
            ? state.extra! as PaymentReceipt
            : PaymentReceipt(
                fee: mockPendingFee,
                method: PaymentMethod.creditCard,
                transactionId: 'TXN123456789',
              );

        return CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 520),
          reverseTransitionDuration: const Duration(milliseconds: 320),
          child: PaymentSuccessScreen(receipt: receipt),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );

            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.08),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        );
      },
    ),
  ],
);
