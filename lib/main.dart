import 'package:flutter/material.dart';

import 'app_router.dart';
import 'utils/colors.dart';

void main() {
  runApp(const Siksha360App());
}

class Siksha360App extends StatelessWidget {
  const Siksha360App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Siksha360',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.paper,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.ink,
          brightness: Brightness.light,
          primary: AppColors.ink,
          surface: AppColors.paper,
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.paper,
          foregroundColor: AppColors.ink,
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.ink,
            foregroundColor: AppColors.paper,
            elevation: 0,
            minimumSize: const Size.fromHeight(54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
