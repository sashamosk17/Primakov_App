/// Deadline Screen - Material Design 3
/// Redesigned based on stitch/_2 design

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/deadline_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/api_models.dart';
import 'add_deadline_screen.dart';

class DeadlineScreen extends ConsumerStatefulWidget {
  const DeadlineScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DeadlineScreen> createState() => _DeadlineScreenState();
}

class _DeadlineScreenState extends ConsumerState<DeadlineScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDeadlines();
    });
  }

  Future<void> _loadDeadlines() async {
    final userId = ref.read(userIdProvider);
    if (userId != null) {
      await ref.read(deadlineProvider.notifier).fetchDeadlines(userId);
    }
  }

  Future<void> _toggleDeadline(String deadlineId) async {
    await ref.read(deadlineProvider.notifier).completeDeadline(deadlineId);
  }

  @override
  Widget build(BuildContext context) {
    final pendingDeadlines = ref.watch(pendingDeadlinesProvider);
    final isLoading = ref.watch(deadlineLoadingProvider);

    // Группировка дедлайнов по неделям
    final thisWeek = <Deadline>[];
    final nextWeek = <Deadline>[];
    final now = DateTime.now();
    final endOfThisWeek = now.add(Duration(days: 7 - now.weekday));

    for (final deadline in pendingDeadlines) {
      final dueDate = DateTime.parse(deadline.dueDate);
      if (dueDate.isBefore(endOfThisWeek) || dueDate.isAtSameMomentAs(endOfThisWeek)) {
        thisWeek.add(deadline);
      } else {
        nextWeek.add(deadline);
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      body: CustomScrollView(
        slivers: [
          // Top App Bar
          SliverAppBar(
            floating: true,
            backgroundColor: const Color(0xCCF3F3F5),
            elevation: 0,
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E2E4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Color(0xFF6C0C08),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Дедлайны',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1C1D),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Color(0xFF5F5E5E)),
                onPressed: () {},
              ),
            ],
          ),

          // Content
          if (isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Текущая неделя
                  if (thisWeek.isNotEmpty) ...[
                    const _SectionHeader(
                      label: 'ПРЕДСТОЯЩИЕ',
                      title: 'Текущая неделя',
                    ),
                    const SizedBox(height: 24),
                    ...thisWeek.map((deadline) => _DeadlineCard(
                          deadline: deadline,
                          onToggle: () => _toggleDeadline(deadline.id),
                        )),
                  ],

                  // Совет дня (после первых дедлайнов)
                  if (thisWeek.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const _TipCard(),
                    const SizedBox(height: 32),
                  ],

                  // Следующая неделя
                  if (nextWeek.isNotEmpty) ...[
                    const _SectionHeader(
                      label: 'СЛЕДУЮЩАЯ НЕДЕЛЯ',
                      title: 'Позже',
                    ),
                    const SizedBox(height: 24),
                    ...nextWeek.map((deadline) => _DeadlineCard(
                          deadline: deadline,
                          onToggle: () => _toggleDeadline(deadline.id),
                        )),
                  ],

                  // Пустое состояние
                  if (thisWeek.isEmpty && nextWeek.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(48),
                        child: Text(
                          'Нет активных дедлайнов',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF5F5E5E),
                          ),
                        ),
                      ),
                    ),
                ]),
              ),
            ),
        ],
      ),

      // FAB
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6C0C08), Color(0xFF8C251C)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0x4D6C0C08), // 0.3 opacity
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddDeadlineScreen(),
                ),
              );
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}

// Section Header Widget
class _SectionHeader extends StatelessWidget {
  final String label;
  final String title;

  const _SectionHeader({
    required this.label,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5F5E5E),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1C1D),
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

// Deadline Card Widget
class _DeadlineCard extends StatelessWidget {
  final Deadline deadline;
  final VoidCallback onToggle;

  const _DeadlineCard({
    required this.deadline,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final dueDate = DateTime.parse(deadline.dueDate);
    final dateFormat = DateFormat('d MMM', 'ru');
    final timeFormat = DateFormat('HH:mm');
    final isCompleted = deadline.status == DeadlineStatus.COMPLETED;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0x08000000), // 0.03 opacity
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: GestureDetector(
              onTap: onToggle,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCompleted
                        ? const Color(0xFF6C0C08)
                        : const Color(0xFFDEC0BB),
                    width: 2,
                  ),
                  color: isCompleted
                      ? const Color(0xFF6C0C08)
                      : Colors.transparent,
                ),
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 20),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            deadline.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1C1D),
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            deadline.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF57423E),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Date Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFDAD5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        dateFormat.format(dueDate),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C0C08),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Meta info
                Row(
                  children: [
                    if (deadline.subject != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8E8EA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          deadline.subject!.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5F5E5E),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Color(0xFFDEC0BB),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    const Icon(
                      Icons.schedule,
                      size: 14,
                      color: Color(0x995F5E5E), // 0.6 opacity
                    ),
                    const SizedBox(width: 4),
                    Text(
                      timeFormat.format(dueDate),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xCC5F5E5E), // 0.8 opacity
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Tip Card Widget
class _TipCard extends StatelessWidget {
  const _TipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF8C251C),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0x336C0C08), // 0.2 opacity
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Совет дня',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFB4A9),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Разбивайте сложные задачи на этапы по 25 минут для лучшей концентрации.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xE6FFFFFF), // 0.9 opacity
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
