/// Auth State Management
/// Converted from Redux authSlice.ts using Riverpod/Provider

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/api_models.dart';
import '../services/api/auth_service.dart';

/// Auth State
class AuthState {
  final String? userId;
  final String? token;
  final UserRole? userRole;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.userId,
    this.token,
    this.userRole,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    String? userId,
    String? token,
    UserRole? userRole,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      userId: userId ?? this.userId,
      token: token ?? this.token,
      userRole: userRole ?? this.userRole,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  bool get isAuthenticated => token != null && userId != null;
}

/// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.login(email, password);
      _authService.setToken(response.token);
      state = state.copyWith(
        userId: response.user.id,
        token: response.token,
        userRole: response.user.role,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> register(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.register(email, password);
      _authService.setToken(response.token);
      state = state.copyWith(
        userId: response.user.id,
        token: response.token,
        userRole: response.user.role,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  void logout() {
    _authService.clearToken();
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
