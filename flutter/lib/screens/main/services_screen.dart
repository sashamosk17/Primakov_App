/// Services Screen
/// Shows various school services and people search (mock)

import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../canteen_menu_screen.dart';
import '../rooms_list_screen.dart';
import '../create_request_screen.dart';
import '../announcements_screen.dart';
import '../teacher_ratings_screen.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scaffoldBg = isDark ? AppColors.darkBackgroundPrimary : AppColors.backgroundPrimary;
    final appBarBg = isDark ? AppColors.darkSurfaceContainerLow.withAlpha((0.9 * 255).round()) : const Color(0xCCF3F3F5);
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final surfaceColor = isDark ? AppColors.darkBackgroundSecondary : AppColors.backgroundSecondary;
    final primaryColor = isDark ? AppColors.darkPrimaryRed : AppColors.primaryRed;
    final borderColor = isDark ? AppColors.darkBorderSecondary : const Color(0xFFE8E8EA);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Сервисы',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Search Section - Compact
              Text(
                'Поиск людей',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _isSearching = value.isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Поиск учителей и учеников...',
                  hintStyle: TextStyle(color: textSecondary),
                  prefixIcon: Icon(Icons.search, color: textSecondary, size: 20),
                  suffixIcon: _isSearching
                      ? IconButton(
                          icon: Icon(Icons.clear, color: textSecondary, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _isSearching = false;
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: surfaceColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              
              // Compact search results or services
              const SizedBox(height: 16),
              if (_isSearching) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceContainer : const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isDark ? AppColors.darkOutlineVariant : const Color(0xFFFF6F00)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: isDark ? AppColors.darkOutlineVariant : const Color(0xFFFF6F00), size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'TODO: Подключить реальный API для поиска',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkOutlineVariant : const Color(0xFFFF6F00),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _mockPeople.take(2).length,
                    itemBuilder: (context, index) => _PersonCard(person: _mockPeople[index]),
                  ),
                ),
              ] else ...[
                // Services Grid - Compact
                Text(
                  'Все сервисы',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.9,
                    children: [
                      _ServiceCard(
                        icon: Icons.support_agent,
                        title: 'Заявки',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CreateRequestScreen(),
                            ),
                          );
                        },
                      ),
                      _ServiceCard(
                        icon: Icons.restaurant,
                        title: 'Столовая',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CanteenMenuScreen(),
                            ),
                          );
                        },
                      ),
                      _ServiceCard(
                        icon: Icons.schedule,
                        title: 'Расписание',
                        onTap: () => _showComingSoon(context),
                      ),
                      _ServiceCard(
                        icon: Icons.map,
                        title: 'Карта',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RoomsListScreen(),
                            ),
                          );
                        },
                      ),
                      _ServiceCard(
                        icon: Icons.announcement,
                        title: 'Объявления',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AnnouncementsScreen(),
                            ),
                          );
                        },
                      ),
                      _ServiceCard(
                        icon: Icons.star,
                        title: 'Рейтинги',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const TeacherRatingsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Этот сервис скоро появится')),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkBackgroundSecondary : AppColors.backgroundSecondary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final iconColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isDark ? Border.all(color: AppColors.darkBorderPrimary) : null,
            boxShadow: isDark ? null : const [
              BoxShadow(
                color: Color(0x05000000),
                blurRadius: 6,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceContainer : AppColors.storyBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isDark ? iconColor : AppColors.primaryRed,
                  size: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PersonCard extends StatelessWidget {
  final _MockPerson person;

  const _PersonCard({required this.person});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkBackgroundSecondary : AppColors.backgroundSecondary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: isDark ? Border.all(color: AppColors.darkBorderPrimary) : null,
        boxShadow: isDark ? null : const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: person.color.withAlpha((0.2 * 255).round()),
            child: Text(
              person.initials,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: person.color,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  person.role,
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Role Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: person.color.withAlpha((0.1 * 255).round()),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              person.badge,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: person.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Mock Data (TODO: Replace with real API)
class _MockPerson {
  final String name;
  final String role;
  final String badge;
  final String initials;
  final Color color;

  _MockPerson({
    required this.name,
    required this.role,
    required this.badge,
    required this.initials,
    required this.color,
  });
}

final List<_MockPerson> _mockPeople = [
  _MockPerson(
    name: 'Иванов Иван Иванович',
    role: 'Учитель математики',
    badge: 'УЧИТЕЛЬ',
    initials: 'ИИ',
    color: const Color(0xFF1976D2),
  ),
  _MockPerson(
    name: 'Петрова Мария Сергеевна',
    role: 'Учитель русского языка',
    badge: 'УЧИТЕЛЬ',
    initials: 'ПМ',
    color: const Color(0xFF1976D2),
  ),
  _MockPerson(
    name: 'Сидоров Алексей',
    role: 'Ученик 10А класса',
    badge: 'УЧЕНИК',
    initials: 'СА',
    color: const Color(0xFF4CAF50),
  ),
];



