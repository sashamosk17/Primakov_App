/// Deadline Screen
/// Converted from React Native DeadlineScreen.tsx

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/api_models.dart';
import '../../providers/deadline_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/deadline_card.dart';

class DeadlineScreen extends ConsumerStatefulWidget {
  const DeadlineScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DeadlineScreen> createState() => _DeadlineScreenState();
}

class _DeadlineScreenState extends ConsumerState<DeadlineScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDeadlines();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDeadlines() async {
    final userId = ref.read(userIdProvider);
    if (userId != null) {
      await ref.read(deadlineProvider.notifier).fetchDeadlines(userId);
    }
  }

  Future<void> _completeDeadline(String deadlineId) async {
    await ref
        .read(deadlineProvider.notifier)
        .completeDeadline(deadlineId);
  }

  @override
  Widget build(BuildContext context) {
    final pendingDeadlines = ref.watch(pendingDeadlinesProvider);
    final completedDeadlines = ref.watch(completedDeadlinesProvider);
    final isLoading = ref.watch(deadlineLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Дедлайны'),
        backgroundColor: const Color(0xFF1976D2),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Активные'),
            Tab(text: 'Выполненные'),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // Active Deadlines
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pendingDeadlines.length,
                  itemBuilder: (context, index) {
                    final deadline = pendingDeadlines[index];
                    return DeadlineCard(
                      deadline: deadline,
                      onComplete: () => _completeDeadline(deadline.id),
                    );
                  },
                ),
                // Completed Deadlines
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: completedDeadlines.length,
                  itemBuilder: (context, index) {
                    final deadline = completedDeadlines[index];
                    return DeadlineCard(
                      deadline: deadline,
                      onComplete: null,
                    );
                  },
                ),
              ],
            ),
    );
  }
}
