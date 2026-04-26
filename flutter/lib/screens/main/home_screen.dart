/// Home Screen - Main Dashboard
/// Redesigned with Bento Grid layout, Stories section, and modern UI

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/story_provider.dart';
import '../../providers/deadline_provider.dart';
import '../../providers/schedule_provider.dart';
import '../../models/api_models.dart';
import '../../config/app_colors.dart';
import '../../config/app_spacing.dart';
import '../../config/app_typography.dart';
import 'schedule_screen.dart';
import 'deadline_screen.dart';
import 'story_viewer_screen.dart';
import '../canteen_menu_screen.dart';

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
    News(
      id: '4',
      title: 'Спортивные соревнования между классами',
      description: 'Приглашаем всех на межклассные соревнования по баскетболу и волейболу. Начало 22 апреля в 15:00.',
      imageUrl: null,
      createdAt: DateTime.now().toIso8601String(),
    ),
    News(
      id: '5',
      title: 'День открытых дверей для будущих первоклассников',
      description: 'Родители будущих учеников могут познакомиться с гимназией и педагогами. Регистрация на сайте.',
      imageUrl: null,
      createdAt: DateTime.now().toIso8601String(),
    ),
    News(
      id: '6',
      title: 'Научная конференция "Молодые исследователи"',
      description: 'Ученики 9-11 классов представят свои научные проекты. Лучшие работы будут отправлены на городской конкурс.',
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
    const userName = 'Иванов Алексей';
    const userRole = 'Ученик';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              padding: AppSpacing.paddingMD,
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Row 1: Schedule (full width)
                    _buildScheduleCard(),
                    const SizedBox(height: AppSpacing.md),

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
                    const SizedBox(height: AppSpacing.md),

                    // Row 3: News (full width)
                    _buildNewsCard(),
                    const SizedBox(height: AppSpacing.md),

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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg - 4, vertical: AppSpacing.md),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                'ИА',
                style: AppTypography.heading2.copyWith(
                  color: Theme.of(context).colorScheme.surface,
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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  userRole,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Search Button
          IconButton(
            icon: const Icon(Icons.search, size: 28),
            color: Theme.of(context).colorScheme.onSurface,
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
        final stories = ref.read(allStoriesProvider);
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

        final initialIndex = displayStories.indexWhere((s) => s.id == story.id);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => StoryViewerScreen(
              stories: displayStories,
              initialIndex: initialIndex >= 0 ? initialIndex : 0,
            ),
          ),
        );
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
                  color: isViewed ? Colors.grey.shade300 : AppColors.primaryRed,
                  width: 3,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isViewed ? Colors.grey.shade200 : AppColors.storyBackground,
                ),
                child: Icon(
                  _getStoryIcon(story.title),
                  color: isViewed ? Colors.grey.shade400 : AppColors.primaryRed,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              story.title,
              style: TextStyle(
                fontSize: 11,
                color: isViewed ? Colors.grey.shade500 : AppColors.textPrimary,
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
        color: Theme.of(context).colorScheme.surface,
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
                  color: AppColors.storyBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: AppColors.primaryRed,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Мое расписание',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
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
                    color: AppColors.primaryRed,
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
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Следующий урок: ${nextLesson.subject} • ${nextLesson.startTime}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Кабинет: ${nextLesson.room}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
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
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDeadlinesCard() {
    final deadlines = ref.watch(allDeadlinesProvider);
    final activeDeadlines = deadlines.where((d) => d.status == DeadlineStatus.PENDING).toList();
    final completedDeadlines = deadlines.where((d) => d.status == DeadlineStatus.COMPLETED).toList();
    final progress = deadlines.isEmpty ? 0.0 : completedDeadlines.length / deadlines.length;

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
          color: Theme.of(context).colorScheme.surface,
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
                    color: AppColors.storyBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.alarm,
                    color: AppColors.primaryRed,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Дедлайны',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${activeDeadlines.length} активных задачи до пятницы',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
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

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CanteenMenuScreen(),
          ),
        );
      },
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
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
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.restaurant_menu,
                    color: AppColors.iconGray,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Столовая',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Баланс: ${cafeteria.balance.toStringAsFixed(0)} ₽',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            Text(
              'Обед: ${cafeteria.todayMenu}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.primaryRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
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
        color: AppColors.primaryRed.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          left: BorderSide(
            color: AppColors.primaryRed,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.format_quote,
            color: AppColors.primaryRed.withOpacity(0.5),
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            quote.text,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.primaryRed,
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
              color: AppColors.primaryRed.withOpacity(0.7),
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
  final Map<int, double> _newsHeights = {};
  final GlobalKey _headerKey = GlobalKey();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  double _calculateNewsHeight(News news) {
    // Calculate approximate height based on text length
    final titleLines = (news.title.length / 30).ceil().clamp(1, 2);
    final descLines = (news.description.length / 40).ceil().clamp(1, 2);

    final titleHeight = titleLines * 20.0; // fontSize 15 * lineHeight
    final descHeight = descLines * 18.0; // fontSize 13 * lineHeight 1.4

    return titleHeight + descHeight + 6 + 32; // +6 for spacing, +32 for padding
  }

  @override
  Widget build(BuildContext context) {
    final newsList = ref.watch(mockNewsListProvider);

    // Pre-calculate heights for all news items
    for (int i = 0; i < newsList.length; i++) {
      _newsHeights[i] = _calculateNewsHeight(newsList[i]);
    }

    final currentNewsHeight = _newsHeights[_currentPage] ?? 100.0;
    const headerHeight = 60.0; // Approximate header height

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: headerHeight + currentNewsHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
            key: _headerKey,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.campaign,
                    color: AppColors.iconGray,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Новости гимназии',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // News PageView with side indicators
          Expanded(
            child: Row(
              children: [
                // PageView
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
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              news.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              news.description,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
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
                // Page Indicators on the right side (only 3 dots)
                Padding(
                  padding: const EdgeInsets.only(right: 16, left: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) {
                        int dotIndex;
                        bool isActive;

                        if (_currentPage == 0) {
                          // First page: show dots 0, 1, 2
                          dotIndex = index;
                          isActive = index == 0;
                        } else if (_currentPage == newsList.length - 1) {
                          // Last page: show dots n-3, n-2, n-1
                          dotIndex = newsList.length - 3 + index;
                          isActive = index == 2;
                        } else {
                          // Middle pages: show prev, current, next
                          dotIndex = _currentPage - 1 + index;
                          isActive = index == 1;
                        }

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          width: 8,
                          height: isActive ? 24 : 8,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primaryRed
                                : AppColors.mediumGray,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



