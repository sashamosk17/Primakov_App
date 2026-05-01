import 'package:dio/dio.dart';
import '../../models/api_models.dart';

class CanteenService {
  final Dio _dio;

  CanteenService(this._dio);

  Future<CanteenMenu?> getTodaysMenu() async {
    try {
      final response = await _dio.get('/canteen/menu/today');
      final apiResponse = ApiResponse<dynamic>.fromJson(
        response.data,
        (data) => data,
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        // Backend returns array, check if it's empty
        if (apiResponse.data is List && (apiResponse.data as List).isEmpty) {
          return null;
        }
        // If it's a list with items, take the first one
        if (apiResponse.data is List && (apiResponse.data as List).isNotEmpty) {
          return CanteenMenu.fromJson((apiResponse.data as List).first as Map<String, dynamic>);
        }
        // If it's a map, parse directly
        if (apiResponse.data is Map<String, dynamic>) {
          return CanteenMenu.fromJson(apiResponse.data as Map<String, dynamic>);
        }
      }
      return null;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['error']?['message'] ?? e.message);
    }
  }

  Future<List<CanteenMenu>> getTodaysMenuList() async {
    try {
      final response = await _dio.get('/canteen/menu/today');
      final apiResponse = ApiResponse<dynamic>.fromJson(
        response.data,
        (data) => data,
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        // Backend returns array of menus
        if (apiResponse.data is List) {
          return (apiResponse.data as List)
              .map((json) => CanteenMenu.fromJson(json as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } on DioException catch (e) {
      throw Exception(e.response?.data?['error']?['message'] ?? e.message);
    }
  }

  Future<List<CanteenMenu>> getMenuByDate(String date) async {
    try {
      final response = await _dio.get('/canteen/menu/$date');
      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (data) => data as List<dynamic>,
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return apiResponse.data!
            .map((json) => CanteenMenu.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      throw Exception(apiResponse.error?['message'] ?? 'Failed to load menu for date');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['error']?['message'] ?? e.message);
    }
  }

  Future<CanteenMenu> getMenuByDateAndMealType(String date, String mealType) async {
    try {
      final response = await _dio.get('/canteen/menu/$date/$mealType');
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return CanteenMenu.fromJson(apiResponse.data!);
      }
      throw Exception(apiResponse.error?['message'] ?? 'Failed to load menu');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['error']?['message'] ?? e.message);
    }
  }
}
