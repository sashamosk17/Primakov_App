/// Unified Profile Screen - Combines profile info and settings
/// Material Design 3 aesthetic with iOS-style grouped lists

import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../providers/auth_provider.dart';
import '../../providers/ui_provider.dart';

import '../../models/api_models.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _ProfileScreenContent();
  }
}

class _ProfileScreenContent extends ConsumerStatefulWidget {
  const _ProfileScreenContent({Key? key}) : super(key: key);

  @override
  ConsumerState<_ProfileScreenContent> createState() => _ProfileScreenContentState();
}

class _ProfileScreenContentState extends ConsumerState<_ProfileScreenContent> {
  // Settings state
  
  bool _twoFactorEnabled = true;
  String _appVersion = '2.4.0';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = packageInfo.version;
      });
    } catch (e) {
      // Keep default version
    }
  }

  Widget _buildNotificationButton(BuildContext context, WidgetRef ref) {
    final notificationSettings = ref.watch(notificationSettingsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return IconButton(
      icon: Icon(
        notificationSettings.pushEnabled 
            ? Icons.notifications_active 
            : Icons.notifications_outlined,
      ),
      color: notificationSettings.pushEnabled
          ? (isDark ? AppColors.darkPrimaryRed : AppColors.primaryRed)
          : (isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B)),
      onPressed: () {
        _showNotificationQuickSettings(context, ref, notificationSettings);
      },
    );
  }

 void _showNotificationQuickSettings(BuildContext context, WidgetRef ref, NotificationSettings notificationSettings) {
  final theme = Theme.of(context);
  
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withAlpha((0.3 * 255).round()),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          Icon(
                            Icons.notifications,
                            color: theme.colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Быстрые настройки уведомлений',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Main toggle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SwitchListTile(
                        value: notificationSettings.pushEnabled,
                        onChanged: (value) async {
                          Navigator.of(context).pop();
                          await ref.read(uiProvider.notifier).togglePushNotifications();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  value ? 'Уведомления включены' : 'Уведомления выключены',
                                ),
                              ),
                            );
                          }
                        },
                        title: Text(
                          'Push-уведомления',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        subtitle: Text(
                          'Получать уведомления о дедлайнах и расписании',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                          ),
                        ),
                        activeColor: theme.colorScheme.primary,
                      ),
                    ),
                    
                    // Detailed settings (only if push is enabled)
                    if (notificationSettings.pushEnabled) ...[
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SwitchListTile(
                          value: notificationSettings.deadlineNotifications,
                          onChanged: (value) async {
                            await ref.read(uiProvider.notifier).toggleDeadlineNotifications();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    value ? 'Уведомления о дедлайнах включены' : 'Уведомления о дедлайнах выключены',
                                  ),
                                ),
                              );
                            }
                          },
                          title: const Text('Дедлайны'),
                          subtitle: const Text('Напоминания о приближающихся дедлайнах'),
                          activeColor: theme.colorScheme.primary,
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SwitchListTile(
                          value: notificationSettings.scheduleNotifications,
                          onChanged: (value) async {
                            await ref.read(uiProvider.notifier).toggleScheduleNotifications();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    value ? 'Уведомления о расписании включены' : 'Уведомления о расписании выключены',
                                  ),
                                ),
                              );
                            }
                          },
                          title: const Text('Расписание'),
                          subtitle: const Text('Изменения в расписании занятий'),
                          activeColor: theme.colorScheme.primary,
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SwitchListTile(
                          value: notificationSettings.announcementNotifications,
                          onChanged: (value) async {
                            await ref.read(uiProvider.notifier).toggleAnnouncementNotifications();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    value ? 'Объявления включены' : 'Объявления выключены',
                                  ),
                                ),
                              );
                            }
                          },
                          title: const Text('Объявления'),
                          subtitle: const Text('Важные объявления и новости'),
                          activeColor: theme.colorScheme.primary,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                    ],
                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final currentUser = ref.watch(currentUserProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);
    final userRole = authState.userRole ?? UserRole.STUDENT;

    // Real user data from API
    final userName = currentUser?.fullName ?? 'Загрузка...';
    final userClass = userRole == UserRole.STUDENT ? '11 «А» класс' : 'Преподаватель';

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scaffoldBg = isDark ? AppColors.darkBackgroundPrimary : AppColors.backgroundPrimary;
    final appBarBg = isDark
        ? AppColors.darkBackgroundPrimary.withAlpha((0.8 * 255).round())
        : AppColors.backgroundPrimary.withAlpha((0.8 * 255).round());

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: appBarBg,
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? AppColors.darkSurfaceContainerHigh : const Color(0xFFE8E8EA),
                border: Border.all(
                  color: AppColors.borderPrimary.withAlpha((0.2 * 255).round()),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.person,
                size: 18,
                color: isDark ? AppColors.darkPrimary : const Color(0xFF8C251C),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'PrimakovApp',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkPrimary : const Color(0xFF8C251C),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          _buildNotificationButton(context, ref),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          children: [
            // Hero Profile Section
            const SizedBox(height: 32),
            _ProfileHeader(
              userName: userName,
              userRole: userRole,
              userClass: userClass,
            ),

            // Stats Grid (only for students)
            if (userRole == UserRole.STUDENT) ...[
              const SizedBox(height: 40),
              const Row(
                children: [
                  Expanded(
                    child: _StatsCard(
                      label: 'Средний балл',
                      value: '4.85',
                      isPrimary: true,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _StatsCard(
                      label: 'Посещаемость',
                      value: '98%',
                      isPrimary: false,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 40),

            // Security Group
            _SettingsGroup(
              children: [
                Divider(height: 1, indent: 66, color: isDark ? AppColors.darkBorderSecondary : const Color(0xFFEEEEF0)),
                _SettingToggleRow(
                  icon: Icons.verified_user,
                  title: 'Двухфакторная аутентификация',
                  subtitle: 'Дополнительная защита аккаунта',
                  value: _twoFactorEnabled,
                  onChanged: (value) {
                    setState(() => _twoFactorEnabled = value);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(value
                          ? '2FA включена'
                          : '2FA выключена'),
                      ),
                    );
                  },
                ),
                Divider(height: 1, indent: 66, color: isDark ? AppColors.darkBorderSecondary : const Color(0xFFEEEEF0)),
                _SettingsRow(
                  icon: Icons.devices,
                  title: 'Активные сессии',
                  subtitle: '2 устройства в сети',
                  onTap: _showActiveSessionsSheet,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Profile Management Group
            _SettingsGroup(
              children: [
                _SettingNavigationRow(
                  icon: Icons.edit,
                  title: 'Редактировать профиль',
                  subtitle: 'Изменить имя и фамилию',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
                Divider(height: 1, indent: 66, color: isDark ? AppColors.darkBorderSecondary : const Color(0xFFEEEEF0)),
                _SettingNavigationRow(
                  icon: Icons.lock_outline,
                  title: 'Сменить пароль',
                  subtitle: 'Обновить пароль доступа',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            

            // Appearance Group
            _SettingsGroup(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withAlpha((0.08 * 255).round()),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.palette,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Оформление',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _ThemeCard(
                              icon: Icons.light_mode,
                              label: 'Светлая',
                              isSelected: !isDarkMode,
                              onTap: () {
                                ref.read(uiProvider.notifier).setDarkMode(false);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _ThemeCard(
                              icon: Icons.dark_mode,
                              label: 'Темная',
                              isSelected: isDarkMode,
                              onTap: () {
                                ref.read(uiProvider.notifier).setDarkMode(true);
                              },
                              isDark: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Support Group
            _SettingsGroup(
              children: [
                _SettingsRow(
                  icon: Icons.help_outline,
                  title: 'Помощь и поддержка',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Раздел помощи скоро появится')),
                    );
                  },
                ),
                Divider(height: 1, indent: 66, color: isDark ? AppColors.darkBorderSecondary : const Color(0xFFEEEEF0)),
                _SettingsRow(
                  icon: Icons.description,
                  title: 'Документы',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Документы скоро появятся')),
                    );
                  },
                ),
                Divider(height: 1, indent: 66, color: isDark ? AppColors.darkBorderSecondary : const Color(0xFFEEEEF0)),
                _SettingsRow(
                  icon: Icons.info,
                  title: 'О приложении',
                  onTap: () => _showAboutDialog(context),
                ),
              ],
            ),

            const SizedBox(height: 48),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _showLogoutDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBA1A1A),
                  foregroundColor: AppColors.backgroundSecondary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: const Color(0xFFBA1A1A).withAlpha((0.05 * 255).round()),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 12),
                    Text(
                      'Выйти из профиля',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 48),

            // Footer
            Text(
              'ВЕРСИЯ $_appVersion'
              '\nhttps://primakov.school/',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface.withAlpha((0.4 * 255).round()),
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showPasswordChangeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Изменить пароль'),
        content: const Text('Функция смены пароля скоро появится'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showActiveSessionsSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Активные сессии',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _SessionTile(
              device: 'iPhone 13 Pro',
              location: 'Москва, Россия',
              isCurrentDevice: true,
            ),
            SizedBox(height: 12),
            _SessionTile(
              device: 'MacBook Pro',
              location: 'Москва, Россия',
              isCurrentDevice: false,
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('О приложении'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PrimakovApp v$_appVersion'),
            const SizedBox(height: 8),
            const Text('Academic Curator System'),
            const SizedBox(height: 16),
            const Text(
              'Приложение для управления учебным процессом в Гимназии Примакова',
              style: TextStyle(fontSize: 13, color: Color(0xFF5F5E5E)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showLicensePage(
                context: context,
                applicationName: 'PrimakovApp',
                applicationVersion: _appVersion,
              );
            },
            child: const Text('Лицензии'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выход из аккаунта'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Отмена',
              style: TextStyle(color: Color(0xFF5F5E5E)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout();
            },
            child: const Text(
              'Выйти',
              style: TextStyle(color: Color(0xFFBA1A1A)),
            ),
          ),
        ],
      ),
    );
  }
}

// Profile Header Widget
class _ProfileHeader extends StatelessWidget {
  final String userName;
  final UserRole userRole;
  final String userClass;

  const _ProfileHeader({
    required this.userName,
    required this.userRole,
    required this.userClass,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkBackgroundSecondary : AppColors.backgroundSecondary;
    final primaryColor = theme.colorScheme.primary;

    return Column(
      children: [
        // Avatar with edit button
        Stack(
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: surfaceColor,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withAlpha((0.1 * 255).round()),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: surfaceColor,
                  width: 4,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Icon(
                  Icons.person,
                  size: 64,
                  color: primaryColor,
                ),
              ),
            ),
            Positioned(
              bottom: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.2 * 255).round()),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.edit,
                  size: 16,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Name
        Text(
          userName,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        // Role badge
        Text(
          _getRoleBadge(userRole, userClass),
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withAlpha((0.6 * 255).round()),
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  String _getRoleBadge(UserRole role, String className) {
    switch (role) {
      case UserRole.STUDENT:
        return 'СТУДЕНТ • $className';
      case UserRole.TEACHER:
        return 'УЧИТЕЛЬ';
      case UserRole.ADMIN:
        return 'АДМИНИСТРАТОР';
    }
  }
}

// Stats Card Widget
class _StatsCard extends StatelessWidget {
  final String label;
  final String value;
  final bool isPrimary;

  const _StatsCard({
    required this.label,
    required this.value,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkBackgroundSecondary : AppColors.backgroundSecondary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderPrimary.withAlpha((0.1 * 255).round()),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.02 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withAlpha((0.6 * 255).round()),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isPrimary ? theme.colorScheme.primary : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

// Settings Group Widget
class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkBackgroundSecondary : AppColors.backgroundSecondary;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: surfaceColor,
          child: Column(children: children),
        ),
      ),
    );
  }
}

// Settings Row Widget
class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;

  const _SettingsRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkBackgroundSecondary : AppColors.backgroundSecondary;
    final effectiveIconColor = iconColor ?? theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: surfaceColor,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: effectiveIconColor.withAlpha((0.08 * 255).round()),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: effectiveIconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? AppColors.darkOutline : AppColors.borderPrimary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// Setting Toggle Row Widget
class _SettingToggleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? iconColor;

  const _SettingToggleRow({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkBackgroundSecondary : AppColors.backgroundSecondary;
    final effectiveIconColor = iconColor ?? theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      color: surfaceColor,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: effectiveIconColor.withAlpha((0.08 * 255).round()),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: effectiveIconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _SettingNavigationRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? iconColor;

  const _SettingNavigationRow({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkBackgroundSecondary : AppColors.backgroundSecondary;
    final effectiveIconColor = iconColor ?? theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: surfaceColor,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: effectiveIconColor.withAlpha((0.08 * 255).round()),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: effectiveIconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurface.withAlpha((0.4 * 255).round()),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// Theme Card Widget
class _ThemeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _ThemeCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentDark = theme.brightness == Brightness.dark;
    // Card background: for the dark-mode preview card use a dark-tinted bg; for light card use white
    final cardBg = isDark
        ? (currentDark ? AppColors.darkSurfaceContainerHigh : const Color(0xFFF3F3F5))
        : (currentDark ? AppColors.darkSurfaceContainer : Colors.white);
    final iconBg = isDark
        ? (currentDark ? AppColors.darkSurfaceContainerLowest : const Color(0xFF1A1C1D))
        : (currentDark ? AppColors.darkSurfaceContainerLow : const Color(0xFFF9F9FB));
    final iconColor = isDark
        ? (currentDark ? AppColors.darkOnSurface : const Color(0xFFF3F3F5))
        : (currentDark ? AppColors.darkOnSurface : const Color(0xFF1A1C1D));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary.withAlpha((0.4 * 255).round())
                : AppColors.borderPrimary.withAlpha((0.15 * 255).round()),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.05 * 255).round()),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Session Tile Widget
class _SessionTile extends StatelessWidget {
  final String device;
  final String location;
  final bool isCurrentDevice;

  const _SessionTile({
    required this.device,
    required this.location,
    required this.isCurrentDevice,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackgroundPrimary : AppColors.backgroundPrimary;
    final innerBg = isDark ? AppColors.darkBackgroundSecondary : AppColors.backgroundSecondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: innerBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.phone_iphone,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      device,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    if (isCurrentDevice) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Текущее',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurface.withAlpha((0.6 * 255).round()),
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


