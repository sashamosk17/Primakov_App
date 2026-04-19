/// Lesson Card Widget
/// Converted from React Native LessonCard component

import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../config/app_colors.dart';
import '../config/app_spacing.dart';
import '../config/app_typography.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;

  const LessonCard({Key? key, required this.lesson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 🔥 ЗАЩИТА ОТ NULL: используем значения по умолчанию
    final startTime = lesson.startTime.isNotEmpty ? lesson.startTime : '--:--';
    final endTime = lesson.endTime.isNotEmpty ? lesson.endTime : '--:--';
    final subject = lesson.subject.isNotEmpty ? lesson.subject : 'Без названия';
    final teacherId = lesson.teacherId.isNotEmpty ? lesson.teacherId : 'Не указан';
    final room = lesson.room.isNotEmpty ? lesson.room : '?';
    final floor = lesson.floor;

    return Container(
      padding: AppSpacing.paddingMD,
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: AppColors.primaryRed,
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
          // Time
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.backgroundTertiary,
              borderRadius: BorderRadius.circular(AppSpacing.xs),
            ),
            child: Text(
              '$startTime - $endTime',
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          // Subject
          Text(
            subject,
            style: AppTypography.heading3,
          ),
          SizedBox(height: AppSpacing.xs),
          // Teacher ID
          Text(
            '👨‍🏫 ID: $teacherId',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          // Location
          Text(
            '🚪 Каб. $room, этаж $floor',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          // Homework indicator
          if (lesson.hasHomework) ...[
            SizedBox(height: AppSpacing.sm),
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppSpacing.xs),
              ),
              child: Text(
                '📝 Домашнее задание',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}