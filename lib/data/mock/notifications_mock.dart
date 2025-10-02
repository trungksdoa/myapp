// Mock data for notifications
import 'package:myapp/data/repositories/interfaces/i_notification_service.dart';

final mockNotifications = [
  PersonalNotification(
    id: 'notif_001',
    title: 'Hội thích thân lân',
    subtitle: 'Được gọi bởi ABCD • Tham gia để chơi',
    type: PersonalNotificationType.invite,
    timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    isRead: false,
    data: {'groupId': 'group_001', 'inviterId': 'user_002'},
  ),
  PersonalNotification(
    id: 'notif_002',
    title: 'Yêu chó',
    subtitle: 'Đã gửi yêu cầu tham gia nhóm',
    type: PersonalNotificationType.request,
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    isRead: false,
    data: {'groupId': 'group_002', 'userId': 'user_003'},
  ),
  PersonalNotification(
    id: 'notif_003',
    title: 'Đơn hàng #ORD001',
    subtitle: 'Đơn hàng trị giá 123.444đ đang được xử lý',
    type: PersonalNotificationType.order,
    timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    isRead: true,
    data: {'orderId': 'ORD001', 'amount': 123444, 'status': 'processing'},
  ),
  PersonalNotification(
    id: 'notif_004',
    title: 'Lịch hẹn sắp tới',
    subtitle: 'Cắt tia chó Bobby vào lúc 14:00 ngày mai',
    type: PersonalNotificationType.appointment,
    timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    isRead: false,
    data: {'appointmentId': 'apt_001', 'petName': 'Bobby'},
  ),
  PersonalNotification(
    id: 'notif_005',
    title: 'Chào mừng bạn!',
    subtitle: 'Cảm ơn bạn đã tham gia CareNest. Hãy khám phá các tính năng!',
    type: PersonalNotificationType.notification,
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    isRead: true,
  ),
  PersonalNotification(
    id: 'notif_006',
    title: 'Đơn hàng #ORD002',
    subtitle: 'Đơn hàng của bản đã được giao thành công!',
    type: PersonalNotificationType.order,
    timestamp: DateTime.now().subtract(const Duration(days: 2)),
    isRead: false,
    data: {'orderId': 'ORD002', 'status': 'delivered'},
  ),
];
