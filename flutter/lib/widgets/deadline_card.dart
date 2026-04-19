/// Deadline Card Widget
/// Converted from React Native DeadlineCard component

import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../config/app_colors.dart';
import '../config/app_spacing.dart';
import '../config/app_typography.dart';

class DeadlineCard extends StatelessWidget {
  final Deadline deadline;
  final VoidCallback? onComplete;

  const DeadlineCard({
    Key? key,
    required this.deadline,
    this.onComplete,
  }) : super(key: key);

  Color _getStatusColor() {
    if (deadline.status == DeadlineStatus.COMPLETED) {
      return AppColors.success;
    }

    final now = DateTime.now();
    final dueDate = DateTime.parse(deadline.dueDate);
    final daysLeft = dueDate.difference(now).inDays;

    if (daysLeft > 5) return AppColors.success;
    if (daysLeft > 2) return AppColors.warning;
    return AppColors.error;
  }

  String _getDaysLeftText() {
    if (deadline.status == DeadlineStatus.COMPLETED) {
      return '✓';
    }

    final now = DateTime.now();
    final dueDate = DateTime.parse(deadline.dueDate);
    final daysLeft = dueDate.difference(now).inDays;

    return '${daysLeft}д';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final daysLeftText = _getDaysLeftText();

    return Container(
      padding: AppSpacing.paddingMD,
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: statusColor,
            width: 4,
          ),
        ),
        color: AppColors.backgroundSecondary,
        borderRadius: AppSpacing.borderRadiusSM,
        boxShadow: AppColors.toggleShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title + Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  deadline.title,
                  style: AppTypography.heading3,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                ),
                child: Text(
                  daysLeftText,
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          // Description
          Text(
            deadline.description,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // Subject if available
          if (deadline.subject != null) ...[
            SizedBox(height: AppSpacing.sm),
            Text(
              '📚 ${deadline.subject}',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
          // Footer: Date + Complete button
          SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '📅 До: ${_formatDate(deadline.dueDate)}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              if (deadline.status != DeadlineStatus.COMPLETED &&
                  onComplete != null)
                ElevatedButton(
                  onPressed: onComplete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Выполнено',
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return '${date.day}.${date.month}.${date.year}';
  }
}
