/// Upcoming Deadlines Widget for Home Screen
/// Shows 3-5 nearest deadlines with "View All" button

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/api_models.dart';
import '../providers/deadline_provider.dart';
import '../screens/main/deadline_screen.dart';

class UpcomingDeadlinesWidget extends ConsumerWidget {
  const UpcomingDeadlinesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingDeadlines = ref.watch(pendingDeadlinesProvider);
    final upcomingDeadlines = pendingDeadlines.take(5).toList();

    if (upcomingDeadlines.isEmpty) {
      return const SizedBox.shrink();
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
                'Ближайшие дедлайны',
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
                      builder: (context) => const DeadlineScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Смотреть все',
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
          // Deadlines List
          ...upcomingDeadlines.map((deadline) => _DeadlineCompactCard(
                deadline: deadline,
              )),
        ],
      ),
    );
  }
}

class _DeadlineCompactCard extends StatelessWidget {
  final Deadline deadline;

  const _DeadlineCompactCard({
    required this.deadline,
  });

  @override
  Widget build(BuildContext context) {
    final dueDate = DateTime.parse(deadline.dueDate);
    final dateFormat = DateFormat('d MMM', 'ru');
    final now = DateTime.now();
    final daysUntil = dueDate.difference(now).inDays;

    String urgencyText;
    Color urgencyColor;

    if (daysUntil == 0) {
      urgencyText = 'Сегодня';
      urgencyColor = const Color(0xFFD32F2F);
    } else if (daysUntil == 1) {
      urgencyText = 'Завтра';
      urgencyColor = const Color(0xFFFF6F00);
    } else if (daysUntil <= 3) {
      urgencyText = 'Через $daysUntil дня';
      urgencyColor = const Color(0xFFFF6F00);
    } else {
      urgencyText = dateFormat.format(dueDate);
      urgencyColor = const Color(0xFF5F5E5E);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Subject Badge
          if (deadline.subject != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8E8EA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                deadline.subject!.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5F5E5E),
                  letterSpacing: 1,
                ),
              ),
            ),
          const SizedBox(width: 12),
          // Title
          Expanded(
            child: Text(
              deadline.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1C1D),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          // Due Date
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: urgencyColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              urgencyText,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: urgencyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
