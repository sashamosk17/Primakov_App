/// User Service
/// API service for user-related operations

import 'package:dio/dio.dart';
import '../../config/api_config.dart';
import '../../models/api_models.dart';

class Teacher {
  final String id;
  final String firstName;
  final String lastName;
  final String fullName;

  Teacher({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      fullName: json['fullName'] as String,
    );
  }
}

class UserService {
  late final Dio _dio;

  UserService() {
    _dio = ApiConfig.createDio();
  }

  Future<List<Teacher>> getTeachers() async {
    try {
      final response = await _dio.get('/users/teachers');

      if (response.data['status'] == 'success') {
        final data = response.data['data'] as List;
        return data.map((e) => Teacher.fromJson(e as Map<String, dynamic>)).toList();
      }

      throw Exception('Failed to fetch teachers');
    } on DioException catch (e) {
      throw Exception('User service error: ${e.message}');
    }
  }

  // НОВЫЙ: GET /api/users/me
  Future<User> getCurrentUser() async {
    try {
      final response = await _dio.get('/users/me');
      final responseData = response.data as Map<String, dynamic>;

      if (responseData['status'] == 'error') {
        throw Exception(responseData['error']?['message'] ?? 'Failed to load profile');
      }

      final data = responseData['data'] as Map<String, dynamic>;
      return User.fromJson(data);
    } on DioException catch (e) {
      throw Exception('Failed to load profile: ${e.message}');
    }
  }

  // НОВЫЙ: PUT /api/users/me
  Future<User> updateProfile({String? firstName, String? lastName}) async {
    try {
      final response = await _dio.put(
        '/users/me',
        data: {
          if (firstName != null) 'firstName': firstName,
          if (lastName != null) 'lastName': lastName,
        },
      );

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['status'] == 'error') {
        throw Exception(responseData['error']?['message'] ?? 'Failed to update profile');
      }

      final data = responseData['data'] as Map<String, dynamic>;
      return User.fromJson(data);
    } on DioException catch (e) {
      throw Exception('Failed to update profile: ${e.message}');
    }
  }

  // НОВЫЙ: PUT /api/users/me/password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.put(
        '/users/me/password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['status'] == 'error') {
        throw Exception(responseData['error']?['message'] ?? 'Failed to change password');
      }
    } on DioException catch (e) {
      throw Exception('Failed to change password: ${e.message}');
    }
  }
}
