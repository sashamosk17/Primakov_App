/// Schedule Screen - Updated Design
/// Shows weekly schedule with lesson cards and navigation to lesson details

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/api_models.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/app_colors.dart';
import 'lesson_detail_screen.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  final List<DateTime> _weekDates = [];

  @override
  void initState() {
    super.initState();
    _generateWeekDates();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _generateWeekDates() {
    _weekDates.clear();
    final today = DateTime.now();
    final currentWeekday = today.weekday;
    final monday = today.subtract(Duration(days: currentWeekday - 1));

    for (int i = 0; i < 6; i++) {
      _weekDates.add(monday.add(Duration(days: i)));
    }
  }

  Future<void> _loadData() async {
    await _loadScheduleForDate(_selectedDate);
  }

  Future<void> _loadScheduleForDate(DateTime date) async {
    final userId = ref.read(authProvider).userId;
    if (userId == null) return;

    final dateString = date.toIso8601String().split('T')[0];
    await ref.read(scheduleProvider.notifier).fetchSchedule(userId, dateString);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2027),
      locale: const Locale('ru', 'RU'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6C0C08),
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadScheduleForDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final schedule = ref.watch(currentScheduleProvider);
    final scheduleLoading = ref.watch(scheduleLoadingProvider);
    final scheduleError = ref.watch(scheduleErrorProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            backgroundColor: const Color(0xCCF3F3F5),
            elevation: 0,
            title: const Text(
              'Расписание',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1C1D),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.calendar_today, color: Color(0xFF6C0C08)),
                onPressed: _pickDate,
              ),
            ],
          ),

          // Date Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('MMMM yyyy', 'ru').format(_selectedDate),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1C1D),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedDate = DateTime.now();
                      });
                      _loadScheduleForDate(DateTime.now());
                    },
                    child: const Text(
                      'Сегодня',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6C0C08),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Week Days Selector
          SliverToBoxAdapter(
            child: Container(
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _weekDates.length,
                itemBuilder: (context, index) {
                  final date = _weekDates[index];
                  final isSelected = date.day == _selectedDate.day &&
                      date.month == _selectedDate.month &&
                      date.year == _selectedDate.year;
                  final isToday = date.day == DateTime.now().day &&
                      date.month == DateTime.now().month &&
                      date.year == DateTime.now().year;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                      });
                      _loadScheduleForDate(date);
                    },
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF6C0C08)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: isToday && !isSelected
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EEE', 'ru').format(date).toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white70
                                  : const Color(0xFF5F5E5E),
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF1A1C1D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Content
          if (scheduleLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (scheduleError != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Color(0xFFD32F2F),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      scheduleError,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF5F5E5E),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C0C08),
                      ),
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            )
          else if (schedule == null || schedule.lessons.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Нет уроков на эту дату',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF5F5E5E),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final lesson = schedule.lessons[index];

                    // Add big break after 2nd lesson
                    if (index == 2) {
                      return Column(
                        children: [
                          _LessonCard(
                            lesson: lesson,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LessonDetailScreen(lesson: lesson),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          _BigBreakCard(),
                          const SizedBox(height: 16),
                        ],
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _LessonCard(
                        lesson: lesson,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LessonDetailScreen(lesson: lesson),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  childCount: schedule.lessons.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;

  const _LessonCard({
    required this.lesson,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
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
            children: [
              // Time
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.startTime,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1C1D),
                    ),
                  ),
                  Text(
                    lesson.endTime,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF5F5E5E),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Divider
              Container(
                width: 3,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C0C08),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              // Subject and Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.subject,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1C1D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.room,
                          size: 16,
                          color: Color(0xFF5F5E5E),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Кабинет ${lesson.room}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF5F5E5E),
                          ),
                        ),
                        if (lesson.hasHomework) ...[
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEBEE),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'ДЗ',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD32F2F),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFF5F5E5E),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BigBreakCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF6F00)),
      ),
      child: Row(
        children: const [
          Icon(Icons.free_breakfast, color: Color(0xFFFF6F00)),
          SizedBox(width: 12),
          Text(
            'Большая перемена',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFF6F00),
            ),
          ),
        ],
      ),
    );
  }
}
