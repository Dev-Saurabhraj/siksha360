import 'package:flutter/material.dart';

import 'data/mock_fee_data.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const Siksha360App());
}

class Siksha360App extends StatelessWidget {
  const Siksha360App({super.key});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF17181C);
    const paper = Color(0xFFFAFAF8);

    return MaterialApp(
      title: 'Siksha360',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: paper,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ink,
          brightness: Brightness.light,
          primary: ink,
          surface: Colors.white,
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: ink,
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: ink,
            foregroundColor: Colors.white,
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
      home: const HomeScreen(fee: mockPendingFee),
    );
  }
}
