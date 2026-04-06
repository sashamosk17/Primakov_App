/// Lesson Card Widget
/// Converted from React Native LessonCard component

import 'package:flutter/material.dart';
import '../models/api_models.dart';

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
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: const Color(0xFF1976D2),
            width: 4,
          ),
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$startTime - $endTime',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF666666),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Subject
          Text(
            subject,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // Teacher ID
          Text(
            '👨‍🏫 ID: $teacherId',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),
          // Location
          Text(
            '🚪 Каб. $room, этаж $floor',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF999999),
            ),
          ),
          // Homework indicator
          if (lesson.hasHomework) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '📝 Домашнее задание',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFF0AD4E),
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