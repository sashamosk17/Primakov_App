import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config/app_typography.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final String placeholder;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.placeholder,
    this.value,
    required this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.darkSurfaceContainerHigh : AppColors.backgroundSecondary;
    final borderColor = isDark ? AppColors.darkBorderPrimary : AppColors.borderPrimary;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final hintColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label.toUpperCase(),
          style: AppTypography.labelLarge.copyWith(
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        // Dropdown
        Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            border: Border(
              bottom: BorderSide(
                color: borderColor,
                width: 2,
              ),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              hint: Text(
                placeholder,
                style: AppTypography.bodyLarge.copyWith(
                  color: hintColor,
                ),
              ),
              isExpanded: true,
              icon: SvgPicture.asset(
                'assets/icons/dropdown_chevron.svg',
                width: 12,
                height: 7.4,
                colorFilter: ColorFilter.mode(
                  textColor,
                  BlendMode.srcIn,
                ),
              ),
              items: items,
              onChanged: onChanged,
              style: AppTypography.bodyLarge.copyWith(
                color: textColor,
              ),
              dropdownColor: bgColor,
            ),
          ),
        ),
      ],
    );
  }
}

