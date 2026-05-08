/// Authentication Service
/// Converted from AuthService.ts

import 'package:dio/dio.dart';
import '../../models/api_models.dart';
import '../../config/api_config.dart';

class AuthService {
  late final Dio _dio;

  AuthService() {
    _dio = ApiConfig.createDio();
  }

  Future<AuthResponse> login(String email, String password) async {
    try {
      print('Attempting login with email: $email');
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      print('Login response status: ${response.statusCode}');
      print('Login response data: ${response.data}');

      // Parse the response directly
      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['status'] == 'error') {
        throw Exception(responseData['error']?['message'] ?? 'Login failed');
      }

      // Get the data section which contains { user: {...}, token: "..." }
      final data = responseData['data'] as Map<String, dynamic>;
      final authResponse = AuthResponse.fromJson(data);
      
      return authResponse;
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Error response: ${e.response?.data}');
      throw Exception('Login error: ${e.message}');
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  Future<AuthResponse> register(String email, String password) async {
    try {
      print('Attempting register with email: $email');
      final response = await _dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
        },
      );

      print('Register response status: ${response.statusCode}');
      print('Register response data: ${response.data}');

      // Parse the response directly
      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['status'] == 'error') {
        throw Exception(responseData['error']?['message'] ?? 'Registration failed');
      }

      // Get the data section which contains { user: {...}, token: "..." }
      final data = responseData['data'] as Map<String, dynamic>;
      final authResponse = AuthResponse.fromJson(data);
      
      return authResponse;
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Error response: ${e.response?.data}');
      throw Exception('Registration error: ${e.message}');
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> logout() async {
    // Logout is handled by state management in Flutter
  }
}
