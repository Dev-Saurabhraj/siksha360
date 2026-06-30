import 'package:flutter/material.dart';

import 'colors.dart';

BoxDecoration panelDecoration() {
  return BoxDecoration(
    color: AppColors.paper,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: AppColors.border),
    boxShadow: const [
      BoxShadow(color: AppColors.shadow, blurRadius: 18, offset: Offset(0, 8)),
    ],
  );
}

BoxDecoration softPanelDecoration() {
  return BoxDecoration(
    color: AppColors.paperAlt,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: AppColors.borderSoft),
  );
}
