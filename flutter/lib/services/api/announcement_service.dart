import 'package:dio/dio.dart';
import '../../models/api_models.dart';
import '../../config/api_config.dart';

class AnnouncementService {
  late final Dio _dio;

  AnnouncementService() {
    _dio = ApiConfig.createDio();
  }

  Future<List<Announcement>> getAnnouncements() async {
    try {
      print('🔄 Getting announcements from: ${_dio.options.baseUrl}/announcements');

      final response = await _dio.get('/announcements');

      print('✅ Response received!');
      print('📊 Status code: ${response.statusCode}');
      print('📦 Response data type: ${response.data?.runtimeType}');
      print('📏 Response data length: ${response.data?.toString().length ?? 0}');

      if (response.data == null) {
        print('⚠️ Response data is null');
        return [];
      }

      final responseData = response.data as Map<String, dynamic>;
      print('📊 Response status field: ${responseData['status']}');

      if (responseData['status'] == 'error') {
        final errorMsg = responseData['error']?['message'] ?? 'Server error';
        print('❌ Server returned error: $errorMsg');
        throw Exception(errorMsg);
      }

      final dataField = responseData['data'];
      if (dataField == null) {
        print('⚠️ Data field is null');
        return [];
      }

      print('📋 Data field type: ${dataField.runtimeType}');
      print('📋 Data field length: ${dataField is List ? dataField.length : 'not a list'}');

      if (dataField is List) {
        print('🔄 Parsing ${dataField.length} announcements...');
        final announcements = <Announcement>[];

        for (int i = 0; i < dataField.length; i++) {
          try {
            final item = dataField[i] as Map<String, dynamic>;
            print('  Parsing announcement $i: ${item['title']}');
            final announcement = Announcement.fromJson(item);
            announcements.add(announcement);
          } catch (parseError) {
            print('❌ Error parsing announcement $i: $parseError');
            print('📄 Problematic data: ${dataField[i]}');
          }
        }

        print('✅ Successfully loaded ${announcements.length} announcements');
        return announcements;
      } else {
        print('⚠️ Data field is not a list: ${dataField.runtimeType}');
        return [];
      }

    } on DioException catch (e) {
      print('❌ DioException caught!');
      print('❌ Type: ${e.type}');
      print('❌ Message: ${e.message}');
      print('❌ Response: ${e.response?.data}');
      print('❌ Status code: ${e.response?.statusCode}');
      throw Exception('Announcements service error: ${e.message}');
    } catch (e, stackTrace) {
      print('❌ Unexpected error: $e');
      print('❌ Stack trace: $stackTrace');
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Announcement> getAnnouncementByCategory(String category) async {
    try {
      print('🔄 Getting announcement by category: $category');
      
      final response = await _dio.get('/announcements/category/$category');

      print('✅ Category response status: ${response.statusCode}');
      print('📦 Category response data: ${response.data}');

      if (response.data == null) {
        throw Exception('Response data is null');
      }

      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['status'] == 'error') {
        throw Exception(responseData['error']?['message'] ?? 'Server error');
      }

      final dataField = responseData['data'];
      if (dataField == null) {
        throw Exception('Data field is null');
      }

      return Announcement.fromJson(dataField as Map<String, dynamic>);
      
    } on DioException catch (e) {
      print('❌ Category error: ${e.message}');
      throw Exception('Get announcement by category error: ${e.message}');
    }
  }
}