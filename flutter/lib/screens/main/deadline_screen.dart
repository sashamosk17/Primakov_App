/// Deadline Screen - Material Design 3
import '../../config/app_typography.dart';
import '../../config/app_spacing.dart';
import '../../config/app_colors.dart';
/// Redesigned based on stitch/_2 design

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:confetti/confetti.dart';
import '../../providers/deadline_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/api_models.dart';
import 'add_deadline_screen.dart';

class DeadlineScreen extends ConsumerStatefulWidget {
  const DeadlineScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DeadlineScreen> createState() => _DeadlineScreenState();
}

class _DeadlineScreenState extends ConsumerState<DeadlineScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _confettiController = ConfettiController(duration: const Duration(milliseconds: 800));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDeadlines();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _loadDeadlines() async {
    final userId = ref.read(userIdProvider);
    if (userId != null) {
      await ref.read(deadlineProvider.notifier).fetchDeadlines(userId);
    }
  }

  Future<void> _toggleDeadline(String deadlineId) async {
    final deadline = ref.read(allDeadlinesProvider).firstWhere((d) => d.id == deadlineId);
    final wasCompleted = deadline.status == DeadlineStatus.COMPLETED;

    await ref.read(deadlineProvider.notifier).completeDeadline(deadlineId);

    // Запускаем конфетти только один раз при завершении (не при отмене)
    if (!wasCompleted && mounted) {
      _confettiController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingDeadlines = ref.watch(pendingDeadlinesProvider);
    final completedDeadlines = ref.watch(completedDeadlinesProvider);
    final isLoading = ref.watch(deadlineLoadingProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              // Top App Bar
              SliverAppBar(
                floating: true,
                pinned: true,
                backgroundColor: const Color(0xCCF3F3F5),
                elevation: 0,
                title: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.mediumGray,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.school,
                        color: AppColors.primaryRed,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Дедлайны',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search, color: AppColors.textSecondary),
                    onPressed: () {},
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: Container(
                    color: const Color(0xCCF3F3F5),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.primaryRed,
                      indicatorWeight: 3,
                      labelColor: AppColors.primaryRed,
                      unselectedLabelColor: AppColors.textSecondary,
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      tabs: const [
                        Tab(text: 'Предстоящие'),
                        Tab(text: 'Выполненные'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      // Предстоящие дедлайны
                      _PendingDeadlinesTab(
                        deadlines: pendingDeadlines,
                        onToggle: _toggleDeadline,
                      ),
                      // Выполненные дедлайны
                      _CompletedDeadlinesTab(
                        deadlines: completedDeadlines,
                        onToggle: _toggleDeadline,
                      ),
                    ],
                  ),
          ),

          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3.14 / 2, // down
              emissionFrequency: 0.1,
              numberOfParticles: 15,
              maxBlastForce: 20,
              minBlastForce: 10,
              gravity: 0.5,
              shouldLoop: false,
              colors: [
                AppColors.primaryRed,
                AppColors.primaryRedLight,
                Colors.red.shade200,
                Colors.red.shade100,
              ],
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
            colors: [AppColors.primaryRed, AppColors.primaryRedLight],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0x4D6C0C08),
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

// Pending Deadlines Tab
class _PendingDeadlinesTab extends StatelessWidget {
  final List<Deadline> deadlines;
  final Function(String) onToggle;

  const _PendingDeadlinesTab({
    required this.deadlines,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    // Группировка дедлайнов по неделям
    final thisWeek = <Deadline>[];
    final nextWeek = <Deadline>[];
    final now = DateTime.now();
    final endOfThisWeek = now.add(Duration(days: 7 - now.weekday));

    for (final deadline in deadlines) {
      final dueDate = DateTime.parse(deadline.dueDate);
      if (dueDate.isBefore(endOfThisWeek) || dueDate.isAtSameMomentAs(endOfThisWeek)) {
        thisWeek.add(deadline);
      } else {
        nextWeek.add(deadline);
      }
    }

    if (thisWeek.isEmpty && nextWeek.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(48),
          child: Text(
            'Нет активных дедлайнов',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
      children: [
        // Текущая неделя
        if (thisWeek.isNotEmpty) ...[
          const _SectionHeader(
            label: 'ПРЕДСТОЯЩИЕ',
            title: 'Текущая неделя',
          ),
          const SizedBox(height: 24),
          ...thisWeek.map((deadline) => _AnimatedDeadlineCard(
                key: ValueKey(deadline.id),
                deadline: deadline,
                onToggle: () => onToggle(deadline.id),
              )),
        ],

        // Совет дня - показываем всегда если есть хоть какие-то дедлайны
        if (thisWeek.isNotEmpty || nextWeek.isNotEmpty) ...[
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
          ...nextWeek.map((deadline) => _AnimatedDeadlineCard(
                key: ValueKey(deadline.id),
                deadline: deadline,
                onToggle: () => onToggle(deadline.id),
              )),
        ],
      ],
    );
  }
}

// Animated wrapper for deadline card
class _AnimatedDeadlineCard extends StatefulWidget {
  final Deadline deadline;
  final VoidCallback onToggle;

  const _AnimatedDeadlineCard({
    Key? key,
    required this.deadline,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<_AnimatedDeadlineCard> createState() => _AnimatedDeadlineCardState();
}

class _AnimatedDeadlineCardState extends State<_AnimatedDeadlineCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleToggle() async {
    if (widget.deadline.status == DeadlineStatus.PENDING) {
      await _controller.forward();
    }
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: _DeadlineCard(
          deadline: widget.deadline,
          onToggle: _handleToggle,
        ),
      ),
    );
  }
}

// Completed Deadlines Tab
class _CompletedDeadlinesTab extends StatelessWidget {
  final List<Deadline> deadlines;
  final Function(String) onToggle;

  const _CompletedDeadlinesTab({
    required this.deadlines,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (deadlines.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(48),
          child: Text(
            'Нет выполненных дедлайнов',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
      children: [
        const _SectionHeader(
          label: 'ВЫПОЛНЕНО',
          title: 'Завершенные задачи',
        ),
        const SizedBox(height: 24),
        ...deadlines.map((deadline) => _DeadlineCard(
              deadline: deadline,
              onToggle: () => onToggle(deadline.id),
            )),
      ],
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
            color: AppColors.textSecondary,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
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
            color: const Color(0x08000000),
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
                        ? AppColors.primaryRed
                        : const Color(0xFFDEC0BB),
                    width: 2,
                  ),
                  color: isCompleted
                      ? AppColors.primaryRed
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
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            deadline.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xCC1A1C1D),
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
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        dateFormat.format(dueDate),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryRed,
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
                            color: AppColors.textSecondary,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppColors.borderPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    const Icon(
                      Icons.schedule,
                      size: 14,
                      color: Color(0x995F5E5E),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      timeFormat.format(dueDate),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xCC5F5E5E),
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

// Tip Card Widget - Enhanced design from stitch/_2
class _TipCard extends StatelessWidget {
  const _TipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryRedLight,
            AppColors.primaryRed,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0x336C0C08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative pattern overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(
                painter: _PatternPainter(),
              ),
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0x33FFFFFF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.lightbulb_outline,
                      color: Colors.red.shade200,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Совет дня',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade200,
                      fontFamily: 'Manrope',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Разбивайте сложные задачи на этапы по 25 минут для лучшей концентрации.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xE6FFFFFF),
                  height: 1.5,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom painter for decorative pattern
class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw diagonal lines pattern
    for (double i = -size.height; i < size.width; i += 20) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }

    // Draw dots pattern
    for (double x = 10; x < size.width; x += 30) {
      for (double y = 10; y < size.height; y += 30) {
        canvas.drawCircle(Offset(x, y), 2, paint..style = PaintingStyle.fill);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
