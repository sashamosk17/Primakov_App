/// Unified Profile Screen - Combines profile info and settings
/// Material Design 3 aesthetic with iOS-style grouped lists

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../providers/auth_provider.dart';
import '../../providers/ui_provider.dart';
import '../../models/api_models.dart';

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
  bool _pushNotificationsEnabled = true;
  bool _gradesNotificationsEnabled = true;
  bool _emailNotificationsEnabled = false;
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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);
    final userRole = authState.userRole ?? UserRole.STUDENT;

    // Mock user data (TODO: Get from API)
    const userName = 'Александр Примаков';
    const userClass = '11 «А» класс';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8E8EA),
                border: Border.all(
                  color: const Color(0xFFDEC0BB).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.person,
                size: 18,
                color: Color(0xFF8C251C),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'PrimakovApp',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8C251C),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: const Color(0xFF64748B),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Уведомления скоро появятся')),
              );
            },
          ),
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
                _SettingsRow(
                  icon: Icons.lock_reset,
                  title: 'Изменить пароль',
                  subtitle: 'Последнее изменение: 3 месяца назад',
                  onTap: _showPasswordChangeDialog,
                ),
                const Divider(height: 1, indent: 66, color: Color(0xFFEEEEF0)),
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
                const Divider(height: 1, indent: 66, color: Color(0xFFEEEEF0)),
                _SettingsRow(
                  icon: Icons.devices,
                  title: 'Активные сессии',
                  subtitle: '2 устройства в сети',
                  onTap: _showActiveSessionsSheet,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Notifications Group
            _SettingsGroup(
              children: [
                _SettingToggleRow(
                  icon: Icons.notifications_active,
                  title: 'Push-уведомления',
                  subtitle: 'Об изменениях в расписании',
                  value: _pushNotificationsEnabled,
                  onChanged: (value) {
                    setState(() => _pushNotificationsEnabled = value);
                  },
                  iconColor: const Color(0xFF5F5E5E),
                ),
                const Divider(height: 1, indent: 66, color: Color(0xFFEEEEF0)),
                _SettingToggleRow(
                  icon: Icons.grade,
                  title: 'Новые оценки',
                  subtitle: 'Мгновенный отчет об успеваемости',
                  value: _gradesNotificationsEnabled,
                  onChanged: (value) {
                    setState(() => _gradesNotificationsEnabled = value);
                  },
                  iconColor: const Color(0xFF5F5E5E),
                ),
                const Divider(height: 1, indent: 66, color: Color(0xFFEEEEF0)),
                _SettingToggleRow(
                  icon: Icons.alternate_email,
                  title: 'Email-рассылка',
                  subtitle: 'Важные новости школы',
                  value: _emailNotificationsEnabled,
                  onChanged: (value) {
                    setState(() => _emailNotificationsEnabled = value);
                  },
                  iconColor: const Color(0xFF5F5E5E),
                ),
              ],
            ),

            const SizedBox(height: 24),

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
                              color: const Color(0xFF6C0C08).withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.palette,
                              color: Color(0xFF6C0C08),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Оформление',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1C1D),
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
                  iconColor: const Color(0xFF5F5E5E),
                ),
                const Divider(height: 1, indent: 66, color: Color(0xFFEEEEF0)),
                _SettingsRow(
                  icon: Icons.description,
                  title: 'Документы',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Документы скоро появятся')),
                    );
                  },
                  iconColor: const Color(0xFF5F5E5E),
                ),
                const Divider(height: 1, indent: 66, color: Color(0xFFEEEEF0)),
                _SettingsRow(
                  icon: Icons.info,
                  title: 'О приложении',
                  onTap: () => _showAboutDialog(context),
                  iconColor: const Color(0xFF5F5E5E),
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
                  foregroundColor: Theme.of(context).colorScheme.surface,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: const Color(0xFFBA1A1A).withOpacity(0.05),
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
              'ВЕРСИЯ $_appVersion (PRIMAKOV-CURATOR)',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5F5E5E).withOpacity(0.6),
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
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C0C08).withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface,
                  width: 4,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: const Icon(
                  Icons.person,
                  size: 64,
                  color: Color(0xFF8C251C),
                ),
              ),
            ),
            Positioned(
              bottom: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C0C08),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.edit,
                  size: 16,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Name
        Text(
          userName,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1C1D),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        // Role badge
        Text(
          _getRoleBadge(userRole, userClass),
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5F5E5E),
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFDEC0BB).withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5F5E5E),
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
              color: isPrimary ? const Color(0xFF6C0C08) : const Color(0xFF1A1C1D),
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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: Theme.of(context).colorScheme.surface,
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
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).colorScheme.surface,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (iconColor ?? const Color(0xFF6C0C08)).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor ?? const Color(0xFF6C0C08),
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1C1D),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5F5E5E),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFFDEC0BB),
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
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (iconColor ?? const Color(0xFF6C0C08)).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor ?? const Color(0xFF6C0C08),
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1C1D),
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF5F5E5E),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: const Color(0xFF6C0C08),
          ),
        ],
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFFF3F3F5) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
              ? const Color(0xFF6C0C08).withOpacity(0.2)
              : const Color(0xFFDEC0BB).withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1C1D) : const Color(0xFFF9F9FB),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: isDark ? const Color(0xFFF3F3F5) : const Color(0xFF1A1C1D),
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1C1D),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.phone_iphone,
              color: Color(0xFF6C0C08),
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
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
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
                        child: Text(
                          'Текущее',
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.surface,
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
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5F5E5E),
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


