import 'package:flutter/material.dart';

class AppBrandBar extends StatelessWidget implements PreferredSizeWidget {
  const AppBrandBar({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 20,
      title: Row(
        children: [
          if (showBackButton) ...[
            IconButton(
              tooltip: 'Back',
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 4),
          ],
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF17181C),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              's',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 10),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                color: Color(0xFF17181C),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              children: [
                TextSpan(text: 'Siksha'),
                TextSpan(
                  text: '360',
                  style: TextStyle(
                    color: Color(0xFF7C7F87),
                    fontWeight: FontWeight.w600,
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
