import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config/app_typography.dart';

class PriorityToggle extends StatelessWidget {
  final bool isHighPriority;
  final ValueChanged<bool> onChanged;

  const PriorityToggle({
    super.key,
    required this.isHighPriority,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Label with Icon
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/priority_icon.svg',
                width: 4,
                height: 18,
              ),
              const SizedBox(width: 12),
              const Text(
                'Высокий приоритет',
                style: AppTypography.bodyMedium,
              ),
            ],
          ),
          // Toggle Switch
          GestureDetector(
            onTap: () => onChanged(!isHighPriority),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 24,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isHighPriority
                    ? AppColors.primaryRed
                    : AppColors.borderSecondary,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Align(
                alignment:
                    isHighPriority ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundSecondary,
                    shape: BoxShape.circle,
                    boxShadow: AppColors.toggleShadow,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

