/// Home Screen - Main Dashboard
/// Redesigned with Bento Grid layout, Stories section, and modern UI

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/story_provider.dart';
import '../../providers/deadline_provider.dart';
import '../../providers/schedule_provider.dart';
import '../../models/api_models.dart';
import 'schedule_screen.dart';
import 'deadline_screen.dart';

// Mock data providers
final mockNewsListProvider = Provider<List<News>>((ref) {
  return [
    News(
      id: '1',
      title: 'Открытие новой лаборатории робототехники в следующую субботу',
      description: 'Приглашаем родителей на торжественную презентацию новых проектов учащихся...',
      imageUrl: null,
      createdAt: DateTime.now().toIso8601String(),
    ),
    News(
      id: '2',
      title: 'Весенний концерт состоится 25 апреля',
      description: 'Ученики представят музыкальные номера и театральные постановки. Начало в 18:00 в актовом зале.',
      imageUrl: null,
      createdAt: DateTime.now().toIso8601String(),
    ),
    News(
      id: '3',
      title: 'Экскурсия в музей космонавтики',
      description: 'Для учеников 8-10 классов организована экскурсия. Запись у классных руководителей до 20 апреля.',
      imageUrl: null,
      createdAt: DateTime.now().toIso8601String(),
    ),
  ];
});

final mockQuoteProvider = Provider<Quote>((ref) {
  return Quote(
    id: '1',
    text: 'Образование — это самое мощное оружие, которое вы можете использовать, чтобы изменить мир.',
    author: 'Нельсон Мандела',
  );
});

final mockCafeteriaProvider = Provider<CafeteriaInfo>((ref) {
  return CafeteriaInfo(
    balance: 1450.0,
    todayMenu: 'Паста Болоньезе',
  );
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final userId = ref.read(authProvider).userId;
    if (userId == null) return;

    // Load stories
    ref.read(storyProvider.notifier).fetchStories();

    // Load deadlines
    ref.read(deadlineProvider.notifier).fetchDeadlines(userId);

    // Load today's schedule
    final today = DateTime.now();
    final dateString = today.toIso8601String().split('T')[0];
    ref.read(scheduleProvider.notifier).fetchSchedule(userId, dateString);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    // TODO: Get actual user name from API
    final userName = 'Иванов Алексей';
    final userRole = 'Ученик';

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Top App Bar
            SliverToBoxAdapter(
              child: _buildTopAppBar(userName, userRole),
            ),

            // Stories Section
            SliverToBoxAdapter(
              child: _buildStoriesSection(),
            ),

            // Bento Grid Content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Row 1: Schedule (full width)
                    _buildScheduleCard(),
                    const SizedBox(height: 12),

                    // Row 2: Deadlines + Cafeteria
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildDeadlinesCard(),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildCafeteriaCard(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Row 3: News (full width)
                    _buildNewsCard(),
                    const SizedBox(height: 12),

                    // Quote Card
                    _buildQuoteCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar(String userName, String userRole) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF6C0C08),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(
              child: Text(
                'ИА',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name and Role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1C1D),
                  ),
                ),
                Text(
                  userRole,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF5F5E5E),
                  ),
                ),
              ],
            ),
          ),
          // Search Button
          IconButton(
            icon: const Icon(Icons.search, size: 28),
            color: const Color(0xFF1A1C1D),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesSection() {
    final stories = ref.watch(allStoriesProvider);
    final userId = ref.watch(authProvider).userId ?? '';

    // Mock stories if empty
    final displayStories = stories.isEmpty
        ? [
            Story(
              id: '1',
              title: 'События',
              description: 'Новые события',
              imageUrl: null,
              videoUrl: null,
              viewedBy: [],
            ),
            Story(
              id: '2',
              title: 'Приказы',
              description: 'Важные приказы',
              imageUrl: null,
              videoUrl: null,
              viewedBy: [],
            ),
            Story(
              id: '3',
              title: 'Меню',
              description: 'Меню столовой',
              imageUrl: null,
              videoUrl: null,
              viewedBy: ['viewed'],
            ),
            Story(
              id: '4',
              title: 'Оценки',
              description: 'Ваши оценки',
              imageUrl: null,
              videoUrl: null,
              viewedBy: ['viewed'],
            ),
            Story(
              id: '5',
              title: 'Разное',
              description: 'Разное',
              imageUrl: null,
              videoUrl: null,
              viewedBy: [],
            ),
          ]
        : stories;

    return Container(
      height: 110,
      margin: const EdgeInsets.only(top: 8, bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: displayStories.length,
        itemBuilder: (context, index) {
          final story = displayStories[index];
          final isViewed = story.viewedBy.contains(userId) || story.viewedBy.contains('viewed');
          return _buildStoryItem(story, isViewed);
        },
      ),
    );
  }

  Widget _buildStoryItem(Story story, bool isViewed) {
    return GestureDetector(
      onTap: () {
        ref.read(storyProvider.notifier).markAsViewed(story.id);
        // TODO: Open story viewer
      },
      child: Container(
        width: 72,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isViewed ? Colors.grey.shade300 : const Color(0xFF6C0C08),
                  width: 3,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isViewed ? Colors.grey.shade200 : const Color(0xFFFFEBEE),
                ),
                child: Icon(
                  _getStoryIcon(story.title),
                  color: isViewed ? Colors.grey.shade400 : const Color(0xFF6C0C08),
                  size: 28,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              story.title,
              style: TextStyle(
                fontSize: 11,
                color: isViewed ? Colors.grey.shade500 : const Color(0xFF1A1C1D),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStoryIcon(String title) {
    switch (title.toLowerCase()) {
      case 'события':
        return Icons.event;
      case 'приказы':
        return Icons.description;
      case 'меню':
        return Icons.restaurant_menu;
      case 'оценки':
        return Icons.grade;
      case 'разное':
        return Icons.more_horiz;
      default:
        return Icons.circle;
    }
  }

  Widget _buildScheduleCard() {
    final schedule = ref.watch(currentScheduleProvider);
    final isLoading = ref.watch(scheduleLoadingProvider);

    Lesson? nextLesson;
    if (schedule != null && schedule.lessons.isNotEmpty) {
      final now = DateTime.now();
      final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

      for (final lesson in schedule.lessons) {
        final lessonTime = _parseTime(lesson.startTime);
        if (lessonTime != null && _isAfter(lessonTime, currentTime)) {
          nextLesson = lesson;
          break;
        }
      }
      nextLesson ??= schedule.lessons.first;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF6C0C08),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Мое расписание',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1C1D),
                  ),
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
                  'Смотреть всё',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6C0C08),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            )
          else if (nextLesson != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Следующий урок: ${nextLesson.subject} • ${nextLesson.startTime}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1C1D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Кабинет: ${nextLesson.room}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF5F5E5E),
                    ),
                  ),
                ],
              ),
            )
          else
            const Text(
              'Сегодня нет уроков',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF5F5E5E),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDeadlinesCard() {
    final deadlines = ref.watch(allDeadlinesProvider);
    final activeDeadlines = deadlines.where((d) => d.status == DeadlineStatus.PENDING).toList();
    final progress = activeDeadlines.isEmpty ? 0.0 : 0.75;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const DeadlineScreen(),
          ),
        );
      },
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.alarm,
                    color: Color(0xFF6C0C08),
                    size: 20,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Дедлайны',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1C1D),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${activeDeadlines.length} активных задачи до пятницы',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5F5E5E),
                  ),
                ),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6C0C08)),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCafeteriaCard() {
    final cafeteria = ref.watch(mockCafeteriaProvider);

    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: Color(0xFFFF6F00),
                  size: 20,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Столовая',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1C1D),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Баланс: ${cafeteria.balance.toStringAsFixed(0)} ₽',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF5F5E5E),
                ),
              ),
            ],
          ),
          Text(
            'Обед: ${cafeteria.todayMenu}',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6C0C08),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard() {
    return const _NewsCarousel();
  }

  Widget _buildQuoteCard() {
    final quote = ref.watch(mockQuoteProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF6C0C08).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: const Color(0xFF6C0C08),
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.format_quote,
            color: const Color(0xFF6C0C08).withOpacity(0.5),
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            quote.text,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF6C0C08),
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '— ${quote.author}'.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              color: const Color(0xFF6C0C08).withOpacity(0.7),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
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

/// News Carousel Widget with vertical scrolling and page indicators
class _NewsCarousel extends ConsumerStatefulWidget {
  const _NewsCarousel();

  @override
  ConsumerState<_NewsCarousel> createState() => _NewsCarouselState();
}

class _NewsCarouselState extends ConsumerState<_NewsCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsList = ref.watch(mockNewsListProvider);

    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.newspaper,
                    color: Color(0xFF4CAF50),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Новости гимназии',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1C1D),
                  ),
                ),
              ],
            ),
          ),

          // News PageView
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: newsList.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final news = newsList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        news.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1C1D),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        news.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF5F5E5E),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Page Indicators
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                newsList.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? const Color(0xFF6C0C08)
                        : const Color(0xFFE2E2E4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
