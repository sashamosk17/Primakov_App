/// UI State Management
/// Converted from Redux uiSlice.ts

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// UI State
class UIState {
  final bool isDarkMode;
  final String selectedTab;
  final bool isLoading;

  const UIState({
    this.isDarkMode = false,
    this.selectedTab = 'schedule',
    this.isLoading = false,
  });

  UIState copyWith({
    bool? isDarkMode,
    String? selectedTab,
    bool? isLoading,
  }) {
    return UIState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// UI Notifier with persistence
class UINotifier extends StateNotifier<UIState> {
  UINotifier() : super(const UIState()) {
    _loadPreferences();
  }

  static const String _darkModeKey = 'isDarkMode';

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool(_darkModeKey) ?? false;
    state = state.copyWith(isDarkMode: isDarkMode);
  }

  Future<void> toggleDarkMode() async {
    final newValue = !state.isDarkMode;
    state = state.copyWith(isDarkMode: newValue);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, newValue);
  }

  Future<void> setDarkMode(bool isDarkMode) async {
    state = state.copyWith(isDarkMode: isDarkMode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, isDarkMode);
  }

  void setSelectedTab(String tab) {
    state = state.copyWith(selectedTab: tab);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }
}

/// UI State Provider
final uiProvider = StateNotifierProvider<UINotifier, UIState>((ref) {
  return UINotifier();
});

/// UI selectors
final isDarkModeProvider = Provider<bool>((ref) =>
    ref.watch(uiProvider).isDarkMode);

final selectedTabProvider = Provider<String>((ref) =>
    ref.watch(uiProvider).selectedTab);

final uiLoadingProvider = Provider<bool>((ref) =>
    ref.watch(uiProvider).isLoading);
