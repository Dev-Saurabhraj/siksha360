import 'package:flutter/material.dart';

class GridBackground extends StatelessWidget {
  const GridBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: const Color(0xFFFAFAF8), child: child);
  }
}
