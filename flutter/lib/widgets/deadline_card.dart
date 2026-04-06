/// Deadline Card Widget
/// Converted from React Native DeadlineCard component

import 'package:flutter/material.dart';
import '../models/api_models.dart';

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
      return const Color(0xFF4CAF50);
    }

    final now = DateTime.now();
    final dueDate = DateTime.parse(deadline.dueDate);
    final daysLeft = dueDate.difference(now).inDays;

    if (daysLeft > 5) return const Color(0xFF4CAF50);
    if (daysLeft > 2) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
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
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: statusColor,
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
          // Header: Title + Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  deadline.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  daysLeftText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Description
          Text(
            deadline.description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // Subject if available
          if (deadline.subject != null) ...[
            const SizedBox(height: 8),
            Text(
              '📚 ${deadline.subject}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF999999),
              ),
            ),
          ],
          // Footer: Date + Complete button
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '📅 До: ${_formatDate(deadline.dueDate)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                ),
              ),
              if (deadline.status != DeadlineStatus.COMPLETED &&
                  onComplete != null)
                ElevatedButton(
                  onPressed: onComplete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Выполнено',
                    style: TextStyle(
                      fontSize: 12,
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
