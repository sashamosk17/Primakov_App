import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config/app_colors.dart';
import '../config/app_typography.dart';

class GlassmorphicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final Widget? trailing;

  const GlassmorphicAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.trailing,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          color: AppColors.glassBackground,
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                // Back Button
                if (onBackPressed != null)
                  InkWell(
                    onTap: onBackPressed,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/icons/back_arrow.svg',
                        width: 14,
                        height: 14,
                      ),
                    ),
                  ),
                if (onBackPressed != null) const SizedBox(width: 12),
                // Title
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.heading1,
                  ),
                ),
                // Trailing Widget
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
