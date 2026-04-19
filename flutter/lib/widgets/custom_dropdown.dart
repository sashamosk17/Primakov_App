import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config/app_colors.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label.toUpperCase(),
          style: AppTypography.labelLarge,
        ),
        const SizedBox(height: 8),
        // Dropdown
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundTertiary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            border: const Border(
              bottom: BorderSide(
                color: AppColors.borderPrimary,
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
                style: AppTypography.bodyLarge,
              ),
              isExpanded: true,
              icon: SvgPicture.asset(
                'assets/icons/dropdown_chevron.svg',
                width: 12,
                height: 7.4,
              ),
              items: items,
              onChanged: onChanged,
              style: AppTypography.bodyLarge,
              dropdownColor: AppColors.backgroundSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
