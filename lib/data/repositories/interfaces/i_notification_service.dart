// Interface for Notification Service
enum PersonalNotificationType {
  invite,
  request,
  notification,
  order,
  appointment,
}

class PersonalNotification {
  final String id;
  final String title;
  final String subtitle;
  final PersonalNotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic>? data;

  const PersonalNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.data,
  });
}

abstract class IPersonalNotificationService {
  /// Get all notifications
  Future<List<PersonalNotification>> getAllNotifications();

  /// Get notifications by type
  Future<List<PersonalNotification>> getNotificationsByType(
    PersonalNotificationType type,
  );

  /// Mark notification as read
  Future<void> markAsRead(String notificationId);

  /// Mark all notifications as read
  Future<void> markAllAsRead();

  /// Delete notification
  Future<void> deleteNotification(String notificationId);

  /// Get unread notifications count
  Future<int> getUnreadCount();
}
