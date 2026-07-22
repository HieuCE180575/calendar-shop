import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/notification_model.dart';

class NotificationRemoteDataSource {
  final ApiClient apiClient;

  NotificationRemoteDataSource(this.apiClient);

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.notifications);
      final data = response.data;
      final list = data is Map && data['value'] is List ? data['value'] as List : data as List;
      return list.map((e) => NotificationModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await apiClient.dio.put('${ApiConstants.notifications}/$id/read');
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await apiClient.dio.put('${ApiConstants.notifications}/read-all');
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<void> registerFcmToken(String token) async {
    try {
      await apiClient.dio.post('${ApiConstants.notifications}/register-token', data: {
        'fcmToken': token,
      });
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<void> triggerHolidayReminders() async {
    try {
      await apiClient.dio.post('${ApiConstants.notifications}/trigger-holiday');
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }
}
