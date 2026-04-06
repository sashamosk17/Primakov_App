/// API Configuration
/// Converted from axiosInstance.ts

import 'package:dio/dio.dart';

class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );

  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    );

    // Request interceptor: Add JWT token to headers
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Token will be added from providers/state
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          // Handle 401 and logout
          if (error.response?.statusCode == 401) {
            // Handle logout in providers
          }
          return handler.next(error);
        },
      ),
    );

    return dio;
  }
}
