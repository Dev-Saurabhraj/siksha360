import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/icons.dart';

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
              icon: const Icon(AppIcons.back),
            ),
            const SizedBox(width: 4),
          ],
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.ink,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              's',
              style: TextStyle(
                color: AppColors.paper,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 10),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              children: [
                TextSpan(text: 'Siksha'),
                TextSpan(
                  text: '360',
                  style: TextStyle(
                    color: AppColors.textSubtle,
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
