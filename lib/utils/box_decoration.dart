import 'package:flutter/material.dart';

BoxDecoration panelDecoration() {
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


BoxDecoration softPanelDecoration() {
  return BoxDecoration(
    color: const Color(0xFFF7F7F5),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: const Color(0xFFE8E9E6)),
  );
}