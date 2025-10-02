// Personal Notification Service Implementation (Mock)
import 'package:myapp/data/repositories/interfaces/i_notification_service.dart';
import 'package:myapp/data/mock/notifications_mock.dart';

class PersonalNotificationService implements IPersonalNotificationService {
  // TODO: Replace with actual API calls when backend is ready
  // Currently using mock data

  @override
  Future<List<PersonalNotification>> getAllNotifications() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/notifications');
    // return response.data.map((json) => PersonalNotification.fromJson(json)).toList();

    return mockNotifications;
  }

  @override
  Future<List<PersonalNotification>> getNotificationsByType(
    PersonalNotificationType type,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/notifications?type=$type');
    // return response.data.map((json) => PersonalNotification.fromJson(json)).toList();

    return mockNotifications
        .where((notification) => notification.type == type)
        .toList();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // TODO: Replace with actual API call
    // Example: await httpClient.patch('/api/notifications/$notificationId/read');

    final index = mockNotifications.indexWhere(
      (notification) => notification.id == notificationId,
    );
    if (index != -1) {
      mockNotifications[index] = PersonalNotification(
        id: mockNotifications[index].id,
        title: mockNotifications[index].title,
        subtitle: mockNotifications[index].subtitle,
        type: mockNotifications[index].type,
        timestamp: mockNotifications[index].timestamp,
        isRead: true,
        data: mockNotifications[index].data,
      );
    }
  }

  @override
  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Replace with actual API call
    // Example: await httpClient.patch('/api/notifications/mark-all-read');

    for (int i = 0; i < mockNotifications.length; i++) {
      if (!mockNotifications[i].isRead) {
        mockNotifications[i] = PersonalNotification(
          id: mockNotifications[i].id,
          title: mockNotifications[i].title,
          subtitle: mockNotifications[i].subtitle,
          type: mockNotifications[i].type,
          timestamp: mockNotifications[i].timestamp,
          isRead: true,
          data: mockNotifications[i].data,
        );
      }
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // TODO: Replace with actual API call
    // Example: await httpClient.delete('/api/notifications/$notificationId');

    mockNotifications.removeWhere(
      (notification) => notification.id == notificationId,
    );
  }

  @override
  Future<int> getUnreadCount() async {
    await Future.delayed(const Duration(milliseconds: 100));

    // TODO: Replace with actual API call
    // Example: final response = await httpClient.get('/api/notifications/unread-count');
    // return response.data['count'];

    return mockNotifications
        .where((notification) => !notification.isRead)
        .length;
  }
}
