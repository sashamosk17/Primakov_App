import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/canteen_provider.dart';
import '../models/api_models.dart';
import '../config/app_spacing.dart';

class CanteenMenuScreen extends ConsumerStatefulWidget {
  const CanteenMenuScreen({super.key});

  @override
  ConsumerState<CanteenMenuScreen> createState() => _CanteenMenuScreenState();
}

class _CanteenMenuScreenState extends ConsumerState<CanteenMenuScreen> {
  String _selectedMealType = 'LUNCH';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(canteenProvider.notifier).fetchTodayMenu());
  }

  @override
  Widget build(BuildContext context) {
    final canteenState = ref.watch(canteenProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackgroundPrimary : AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackgroundSecondary : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Меню столовой',
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Meal Type Tabs
          Container(
            color: isDark ? AppColors.darkBackgroundSecondary : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMealTypeChip('BREAKFAST', 'Завтрак', Icons.wb_sunny_outlined),
                _buildMealTypeChip('LUNCH', 'Обед', Icons.restaurant),
                _buildMealTypeChip('DINNER', 'Ужин', Icons.nightlight_outlined),
                _buildMealTypeChip('SNACK', 'Перекус', Icons.coffee),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: canteenState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : canteenState.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: isDark ? AppColors.darkIconGray : Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Ошибка загрузки меню',
                              style: TextStyle(
                                fontSize: 16,
                                color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => ref.read(canteenProvider.notifier).fetchTodayMenu(),
                              child: const Text('Повторить'),
                            ),
                          ],
                        ),
                      )
                    : _buildMenuList(canteenState.todayMenu),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTypeChip(String type, String label, IconData icon) {
    final isSelected = _selectedMealType == type;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTap: () => setState(() => _selectedMealType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.darkPrimaryRed : AppColors.primaryRed)
                : (isDark ? AppColors.darkLightGray : AppColors.lightGray),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuList(CanteenMenu? menu) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (menu == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 64,
              color: isDark ? AppColors.darkIconGray : Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Меню не найдено',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    final filteredItems = menu.items.where((item) => item.category == _selectedMealType).toList();

    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.no_meals,
              size: 64,
              color: isDark ? AppColors.darkIconGray : Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Нет блюд в этой категории',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return _buildMenuItem(item);
      },
    );
  }

  Widget _buildMenuItem(CanteenMenuItem item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackgroundSecondary : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: AppColors.darkBorderPrimary) : null,
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkLightGray : AppColors.lightGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: item.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.restaurant,
                          size: 32,
                          color: isDark ? AppColors.darkIconGray : AppColors.iconGray,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.restaurant,
                      size: 32,
                      color: isDark ? AppColors.darkIconGray : AppColors.iconGray,
                    ),
            ),
            const SizedBox(width: 12),
            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: TextStyle(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (item.price != null)
                        Text(
                          '${item.price!.toStringAsFixed(0)} ₽',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkPrimaryRed : AppColors.primaryRed,
                          ),
                        ),
                    ],
                  ),
                  if (item.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.description!,
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildNutritionBadge('${item.calories} ккал', Icons.local_fire_department),
                      if (item.weight != null) ...[
                        const SizedBox(width: 8),
                        _buildNutritionBadge('${item.weight} г', Icons.scale),
                      ],
                      if (item.isVegetarian) ...[
                        const SizedBox(width: 8),
                        _buildIconBadge(Icons.eco, Colors.green),
                      ],
                      if (item.isVegan) ...[
                        const SizedBox(width: 8),
                        _buildIconBadge(Icons.spa, Colors.lightGreen),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionBadge(String text, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkLightGray : AppColors.lightGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconBadge(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 14, color: color),
    );
  }
}
