/// Auth State Management
/// Converted from Redux authSlice.ts using Riverpod/Provider

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/api_models.dart';
import '../services/api/auth_service.dart';
import '../config/api_config.dart';

/// Auth State — добавляем currentUser
class AuthState {
  final String? userId;
  final String? token;
  final UserRole? userRole;
  final User? currentUser;   // ← НОВОЕ ПОЛЕ
  final bool isLoading;
  final String? error;

  const AuthState({
    this.userId,
    this.token,
    this.userRole,
    this.currentUser,          // ← добавить в конструктор
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    String? userId,
    String? token,
    UserRole? userRole,
    User? currentUser,         // ← добавить в copyWith
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      userId: userId ?? this.userId,
      token: token ?? this.token,
      userRole: userRole ?? this.userRole,
      currentUser: currentUser ?? this.currentUser,  // ← добавить
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  bool get isAuthenticated => token != null && userId != null;
  bool get isAdmin => userRole == UserRole.ADMIN;
  String? get role => userRole?.name;
}

/// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await _authService.login(email, password);
      // Set token in global Dio instance
      ApiConfig.setToken(response.token);
      state = state.copyWith(
        userId: response.user.id,
        token: response.token,
        userRole: response.user.role,
        currentUser: response.user,   // ← ДОБАВИТЬ
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> register(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await _authService.register(email, password);
      // Set token in global Dio instance
      ApiConfig.setToken(response.token);
      state = state.copyWith(
        userId: response.user.id,
        token: response.token,
        userRole: response.user.role,
        currentUser: response.user,   // ← ДОБАВИТЬ
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Вызывается из ProfileNotifier после успешного updateProfile
  void updateCurrentUser(User updatedUser) {
    state = state.copyWith(currentUser: updatedUser);
  }

  void logout() {
    // Clear token from global Dio instance
    ApiConfig.clearToken();
    state = const AuthState();
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }
}

/// Auth Service Provider
final authServiceProvider = Provider((ref) => AuthService());

/// Auth State Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

/// Auth selectors
final userIdProvider = Provider<String?>((ref) => ref.watch(authProvider).userId);
final tokenProvider = Provider<String?>((ref) => ref.watch(authProvider).token);
final userRoleProvider = Provider<UserRole?>((ref) => ref.watch(authProvider).userRole);
final isAuthenticatedProvider = Provider<bool>((ref) =>
    ref.watch(authProvider).isAuthenticated);
final authLoadingProvider = Provider<bool>((ref) =>
    ref.watch(authProvider).isLoading);
final authErrorProvider = Provider<String?>((ref) =>
    ref.watch(authProvider).error);

// Добавляем селектор для удобного доступа к currentUser
final currentUserProvider = Provider<User?>((ref) =>
    ref.watch(authProvider).currentUser);
