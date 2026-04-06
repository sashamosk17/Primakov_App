/// Schedule Screen
/// Converted from React Native ScheduleScreen.tsx
import 'dart:async'; 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/api_models.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/story_provider.dart';
import '../../widgets/story_card.dart';
import '../../widgets/lesson_card.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  int _selectedDayIndex = 0;
  final List<String> _daysOfWeek = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    // Загружаем stories
    await ref.read(storyProvider.notifier).fetchStories();
    
    // Загружаем расписание
    await _loadScheduleForDay(_selectedDayIndex);
  }

  Future<void> _loadScheduleForDay(int dayIndex) async {
    // Используем userId из authProvider
    final userId = ref.read(authProvider).userId;
    if (userId == null) {
      print('❌ User not authenticated');
      return;
    }

    // Вычисляем дату для выбранного дня
    final today = DateTime.now();
    final currentWeekday = today.weekday; // 1=пн, 6=сб, 7=вс
    final targetDate = today.add(Duration(days: dayIndex - (currentWeekday - 1)));
    
    final dateString = targetDate.toIso8601String().split('T')[0];
    
    print('📅 Loading schedule for userId: $userId, date: $dateString');
    
    await ref.read(scheduleProvider.notifier).fetchSchedule(
      userId,
      dateString,
    );
  }

  void _openStoryViewer(List<Story> stories, int initialIndex) {
    Navigator.push(
      context,
      FullScreenDialogRoute(
        builder: (context) => StoryViewerScreen(
          stories: stories,
          initialIndex: initialIndex,
          onStoryViewed: (storyId) {
            // Отмечаем историю как просмотренную
            ref.read(storyProvider.notifier).markAsViewed(storyId);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stories = ref.watch(allStoriesProvider);
    final isLoading = ref.watch(storyLoadingProvider);
    final schedule = ref.watch(currentScheduleProvider);
    final scheduleLoading = ref.watch(scheduleLoadingProvider);
    final scheduleError = ref.watch(scheduleErrorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание'),
        backgroundColor: const Color(0xFF1976D2),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // TODO: Open calendar picker
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stories Section
              if (!isLoading && stories.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Объявления',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: stories.length,
                          itemBuilder: (context, index) {
                            final story = stories[index];
                            return StoryCard(
                              story: story,
                              onTap: () {
                                print('📖 Story tapped: ${story.title}');
                                _openStoryViewer(stories, index);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              // Loading stories state
              if (isLoading && stories.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: SizedBox(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
              
              // Days of week
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      _daysOfWeek.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(
                            _daysOfWeek[index],
                            style: TextStyle(
                              color: index == _selectedDayIndex
                                  ? Colors.white
                                  : const Color(0xFF333333),
                            ),
                          ),
                          selected: index == _selectedDayIndex,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedDayIndex = index;
                              });
                              _loadScheduleForDay(index);
                            }
                          },
                          backgroundColor: Colors.transparent,
                          selectedColor: const Color(0xFF1976D2),
                          side: BorderSide(
                            color: index == _selectedDayIndex
                                ? const Color(0xFF1976D2)
                                : const Color(0xFFDDDDDD),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Lessons Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Уроки на сегодня',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Error state
                    if (scheduleError != null)
                      Center(
                        child: Column(
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: Colors.red),
                            const SizedBox(height: 8),
                            Text('Ошибка: $scheduleError'),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => _loadScheduleForDay(_selectedDayIndex),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1976D2),
                              ),
                              child: const Text('Повторить'),
                            ),
                          ],
                        ),
                      )
                    // Loading state
                    else if (scheduleLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    // Schedule loaded
                    else if (schedule != null && schedule.lessons.isNotEmpty)
                      Column(
                        children: schedule.lessons.map((lesson) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: LessonCard(lesson: lesson),
                          );
                        }).toList(),
                      )
                    // Empty state
                    else
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text('Нет уроков на этот день'),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Экран просмотра историй (полноэкранный)
class StoryViewerScreen extends StatefulWidget {
  final List<Story> stories;
  final int initialIndex;
  final Function(String) onStoryViewed;

  const StoryViewerScreen({
    Key? key,
    required this.stories,
    required this.initialIndex,
    required this.onStoryViewed,
  }) : super(key: key);

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;
  bool _isPaused = false;
  Timer? _timer;
  
  // Прогресс для каждой истории
  late List<double> _progressValues;
  late List<Timer?> _storyTimers;
  late List<bool> _isCompleted;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    
    _progressValues = List.filled(widget.stories.length, 0.0);
    _storyTimers = List.filled(widget.stories.length, null);
    _isCompleted = List.filled(widget.stories.length, false);
    
    // Запускаем таймер для текущей истории
    _startTimerForCurrentStory();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _stopAllTimers();
    super.dispose();
  }

  void _stopAllTimers() {
    for (var timer in _storyTimers) {
      timer?.cancel();
    }
  }

  void _startTimerForCurrentStory() {
    // Останавливаем текущий таймер если есть
    _storyTimers[_currentIndex]?.cancel();
    
    if (_isCompleted[_currentIndex]) return;
    
    final duration = const Duration(seconds: 10);
    final interval = const Duration(milliseconds: 50);
    
    _storyTimers[_currentIndex] = Timer.periodic(interval, (timer) {
      if (!_isPaused && mounted) {
        setState(() {
          if (_progressValues[_currentIndex] < 1.0) {
            _progressValues[_currentIndex] += 50 / duration.inMilliseconds;
            if (_progressValues[_currentIndex] >= 1.0) {
              _progressValues[_currentIndex] = 1.0;
              _isCompleted[_currentIndex] = true;
              timer.cancel();
              _goToNextStory();
            }
          }
        });
      }
    });
  }

  void _goToNextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      // Отмечаем текущую как просмотренную
      widget.onStoryViewed(widget.stories[_currentIndex].id);
      
      // Переходим к следующей
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Последняя история - закрываем
      widget.onStoryViewed(widget.stories[_currentIndex].id);
      Navigator.pop(context);
    }
  }

  void _goToPreviousStory() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    // Отмечаем предыдущую историю как просмотренную
    if (_currentIndex != index && !_isCompleted[_currentIndex]) {
      widget.onStoryViewed(widget.stories[_currentIndex].id);
      _isCompleted[_currentIndex] = true;
    }
    
    setState(() {
      _currentIndex = index;
      _isPaused = false;
    });
    
    // Запускаем таймер для новой истории
    _startTimerForCurrentStory();
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _togglePause,
        onLongPress: () {
          setState(() {
            _isPaused = true;
          });
        },
        onLongPressUp: () {
          setState(() {
            _isPaused = false;
          });
        },
        child: Stack(
          children: [
            // PageView для листания историй
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: widget.stories.length,
              itemBuilder: (context, index) {
                final story = widget.stories[index];
                return Stack(
                  children: [
                    // Контент истории
                    Center(
                      child: story.imageUrl != null && story.imageUrl!.isNotEmpty
                          ? InteractiveViewer(
                              minScale: 0.8,
                              maxScale: 3.0,
                              child: Image.network(
                                story.imageUrl!,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[900],
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.broken_image,
                                            size: 64,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            story.title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            story.description,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Container(
                              color: Colors.grey[900],
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.photo,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      story.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      story.description,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    
                    // Затемнение при паузе
                    if (_isPaused)
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: Icon(
                            Icons.pause_circle_filled,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            
            // Прогресс бары сверху
            Positioned(
              top: 40,
              left: 16,
              right: 16,
              child: Row(
                children: List.generate(
                  widget.stories.length,
                  (index) => Expanded(
                    child: Container(
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Stack(
                        children: [
                          if (_progressValues[index] > 0)
                            Container(
                              width: MediaQuery.of(context).size.width * 
                                  (1 / widget.stories.length) * _progressValues[index],
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Кнопки навигации (левый/правый тап)
            Positioned.fill(
              child: Row(
                children: [
                  // Левая область для переключения назад
                  Expanded(
                    child: GestureDetector(
                      onTap: _goToPreviousStory,
                      behavior: HitTestBehavior.translucent,
                    ),
                  ),
                  // Правая область для переключения вперед
                  Expanded(
                    child: GestureDetector(
                      onTap: _goToNextStory,
                      behavior: HitTestBehavior.translucent,
                    ),
                  ),
                ],
              ),
            ),
            
            // Кнопка закрытия
            Positioned(
              top: 40,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            
            // Текст истории
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.stories[_currentIndex].title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.stories[_currentIndex].description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Диалог для полноэкранного режима
class FullScreenDialogRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;

  FullScreenDialogRoute({required this.builder});

  @override
  Color get barrierColor => Colors.black;

  @override
  String get barrierLabel => 'Full Screen Dialog';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;
}