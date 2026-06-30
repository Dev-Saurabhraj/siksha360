import 'package:flutter/material.dart';

import '../utils/colors.dart';

class GridBackground extends StatelessWidget {
  const GridBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: AppColors.paper, child: child);
  }
}
