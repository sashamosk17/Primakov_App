/// Today Schedule Widget for Home Screen
/// Shows today's schedule with next lesson highlighted

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/api_models.dart';
import '../providers/schedule_provider.dart';
import '../providers/auth_provider.dart';
import '../screens/main/schedule_screen.dart';

class TodayScheduleWidget extends ConsumerStatefulWidget {
  const TodayScheduleWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<TodayScheduleWidget> createState() => _TodayScheduleWidgetState();
}

class _TodayScheduleWidgetState extends ConsumerState<TodayScheduleWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTodaySchedule();
    });
  }

  Future<void> _loadTodaySchedule() async {
    final userId = ref.read(authProvider).userId;
    if (userId == null) return;

    final today = DateTime.now();
    final dateString = today.toIso8601String().split('T')[0];
    await ref.read(scheduleProvider.notifier).fetchSchedule(userId, dateString);
  }

  @override
  Widget build(BuildContext context) {
    final schedule = ref.watch(currentScheduleProvider);
    final isLoading = ref.watch(scheduleLoadingProvider);

    if (isLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (schedule == null || schedule.lessons.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0x08000000),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Сегодня нет уроков',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF5F5E5E),
            ),
          ),
        ),
      );
    }

    // Find next lesson
    final now = DateTime.now();
    final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

    int? nextLessonIndex;
    for (int i = 0; i < schedule.lessons.length; i++) {
      final lesson = schedule.lessons[i];
      final lessonTime = _parseTime(lesson.startTime);
      if (lessonTime != null && _isAfter(lessonTime, currentTime)) {
        nextLessonIndex = i;
        break;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Расписание на сегодня',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1C1D),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ScheduleScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Полное расписание',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6C0C08),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Lessons List (show max 3)
          ...schedule.lessons.take(3).toList().asMap().entries.map((entry) {
            final index = entry.key;
            final lesson = entry.value;
            final isNext = nextLessonIndex == index;
            return _LessonCompactCard(
              lesson: lesson,
              isNext: isNext,
            );
          }),
          if (schedule.lessons.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Center(
                child: Text(
                  'Еще ${schedule.lessons.length - 3} уроков',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5F5E5E),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  TimeOfDay? _parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  bool _isAfter(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour > time2.hour) return true;
    if (time1.hour == time2.hour && time1.minute > time2.minute) return true;
    return false;
  }
}

class _LessonCompactCard extends StatelessWidget {
  final Lesson lesson;
  final bool isNext;

  const _LessonCompactCard({
    required this.lesson,
    this.isNext = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNext ? const Color(0xFFFFEBEE) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isNext
            ? Border.all(color: const Color(0xFF6C0C08), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: const Color(0x08000000),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lesson.startTime,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isNext ? const Color(0xFF6C0C08) : const Color(0xFF1A1C1D),
                ),
              ),
              Text(
                lesson.endTime,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF5F5E5E),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Divider
          Container(
            width: 2,
            height: 40,
            color: isNext ? const Color(0xFF6C0C08) : const Color(0xFFE8E8EA),
          ),
          const SizedBox(width: 16),
          // Subject and Room
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.subject,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isNext ? const Color(0xFF6C0C08) : const Color(0xFF1A1C1D),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.room,
                      size: 14,
                      color: Color(0xFF5F5E5E),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Кабинет ${lesson.room}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5F5E5E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Next indicator
          if (isNext)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF6C0C08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Следующий',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
