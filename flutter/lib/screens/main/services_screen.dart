/// Services Screen
/// Shows various school services and people search (mock)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              'Сервисы',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1C1D),
              ),
            ),
          ),

          // Search Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Поиск людей',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1C1D),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Search Field
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _isSearching = value.isNotEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Поиск учителей и учеников...',
                      hintStyle: const TextStyle(color: Color(0xFF999999)),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF5F5E5E)),
                      suffixIcon: _isSearching
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Color(0xFF5F5E5E)),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _isSearching = false;
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE8E8EA)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE8E8EA)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF6C0C08), width: 2),
                      ),
                    ),
                  ),
                  // Mock Search Results
                  if (_isSearching) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFF6F00)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.info_outline, color: Color(0xFFFF6F00)),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'TODO: Подключить реальный API для поиска',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFFFF6F00),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._mockPeople.map((person) => _PersonCard(person: person)),
                  ],
                ],
              ),
            ),
          ),

          // Services Grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Все сервисы',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1C1D),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      _ServiceCard(
                        icon: Icons.library_books,
                        title: 'Библиотека',
                        color: const Color(0xFF1976D2),
                        onTap: () => _showComingSoon(context),
                      ),
                      _ServiceCard(
                        icon: Icons.restaurant,
                        title: 'Столовая',
                        color: const Color(0xFF4CAF50),
                        onTap: () => _showComingSoon(context),
                      ),
                      _ServiceCard(
                        icon: Icons.schedule,
                        title: 'Расписание\nзвонков',
                        color: const Color(0xFFFF6F00),
                        onTap: () => _showComingSoon(context),
                      ),
                      _ServiceCard(
                        icon: Icons.map,
                        title: 'Карта школы',
                        color: const Color(0xFF9C27B0),
                        onTap: () => _showComingSoon(context),
                      ),
                      _ServiceCard(
                        icon: Icons.announcement,
                        title: 'Объявления',
                        color: const Color(0xFFE91E63),
                        onTap: () => _showComingSoon(context),
                      ),
                      _ServiceCard(
                        icon: Icons.star,
                        title: 'Рейтинги\nучителей',
                        color: const Color(0xFFFFB300),
                        onTap: () => _showComingSoon(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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
  final Color color;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.color,
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
          padding: const EdgeInsets.all(16),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1C1D),
                  height: 1.3,
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
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: person.color.withOpacity(0.2),
            child: Text(
              person.initials,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: person.color,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1C1D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  person.role,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5F5E5E),
                  ),
                ),
              ],
            ),
          ),
          // Role Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: person.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              person.badge,
              style: TextStyle(
                fontSize: 11,
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
