/// UI State Management
/// Converted from Redux uiSlice.ts

import 'package:flutter_riverpod/flutter_riverpod.dart';

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

/// UI Notifier
class UINotifier extends StateNotifier<UIState> {
  UINotifier() : super(const UIState());

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
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
