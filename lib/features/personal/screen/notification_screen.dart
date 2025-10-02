import 'package:flutter/material.dart';
import 'package:myapp/shared/widgets/common/custom_card.dart';
import 'package:myapp/shared/widgets/common/notification.dart';
// Mock notifications used as fallback until real API is available
import 'package:myapp/data/mock/notifications_mock.dart';
import 'package:myapp/data/service_locator.dart';
import 'package:myapp/data/repositories/interfaces/i_notification_service.dart';

enum NotificationType { invite, request, notification }

class NotificationItem {
  final String title;
  final String subtitle;
  final NotificationType type;
  final DateTime timestamp;

  const NotificationItem({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.timestamp,
  });
}

// Format timestamps into friendly relative strings (reusable across widgets)
String formatTime(DateTime ts) {
  final diff = DateTime.now().difference(ts);
  if (diff.inMinutes < 1) return 'Vừa xong';
  if (diff.inHours < 1) return '${diff.inMinutes} phút trước';
  if (diff.inDays < 1) return '${diff.inHours} giờ trước';
  return '${diff.inDays} ngày trước';
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  late final TabController _tab = TabController(length: 3, vsync: this);
  final _notificationService = ServiceLocator().notificationService;

  List<PersonalNotification> _allNotifications = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      // Replace service call; keep fallback handling in catch
      final notifications = await _notificationService.getAllNotifications();

      setState(() {
        _allNotifications = notifications;
        isLoading = false;
      });
    } catch (e) {
      // Fallback to mock data
      setState(() {
        _allNotifications = mockNotifications;
        isLoading = false;
        error = 'Không thể tải thông báo: $e';
      });
    }
  }

  List<NotificationItem> get invites => _allNotifications
      .where((notif) => notif.type == PersonalNotificationType.invite)
      .map(
        (notif) => NotificationItem(
          title: notif.title,
          subtitle: notif.subtitle,
          type: NotificationType.invite,
          timestamp: notif.timestamp,
        ),
      )
      .toList();

  List<NotificationItem> get requests => _allNotifications
      .where((notif) => notif.type == PersonalNotificationType.request)
      .map(
        (notif) => NotificationItem(
          title: notif.title,
          subtitle: notif.subtitle,
          type: NotificationType.request,
          timestamp: notif.timestamp,
        ),
      )
      .toList();

  List<NotificationItem> get notifications => _allNotifications
      .where((notif) => notif.type == PersonalNotificationType.notification)
      .map(
        (notif) => NotificationItem(
          title: notif.title,
          subtitle: notif.subtitle,
          type: NotificationType.notification,
          timestamp: notif.timestamp,
        ),
      )
      .toList();

  void _handleInviteResponse(
    BuildContext context,
    bool accept,
    NotificationItem item,
  ) {
    if (accept) {
      NotificationUtils.showNotification(context, 'Đã chấp nhận lời mời');
    } else {
      NotificationUtils.showNotification(context, 'Đã từ chối lời mời');
    }
    setState(() {
      // Remove the matching PersonalNotification from our internal list
      _allNotifications.removeWhere(
        (notif) =>
            notif.title == item.title &&
            notif.subtitle == item.subtitle &&
            notif.timestamp == item.timestamp,
      );
    });
  }

  void _handleRequestCancel(BuildContext context, NotificationItem item) {
    NotificationUtils.showNotification(context, 'Đã thu hồi yêu cầu');
    setState(() {
      _allNotifications.removeWhere(
        (notif) =>
            notif.title == item.title &&
            notif.subtitle == item.subtitle &&
            notif.timestamp == item.timestamp,
      );
    });
  }

  void _handleNotificationTap(BuildContext context, NotificationItem item) {
    NotificationUtils.showNotification(context, 'Xem chi tiết: ${item.title}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Thông báo'),
        bottom: TabBar(
          controller: _tab,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.orange, width: 3),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Lời mời'),
            Tab(text: 'Thông báo'),
            Tab(text: 'Khác'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFEFF7F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tab,
                labelPadding: const EdgeInsets.symmetric(vertical: 2),
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.orange, width: 3),
                ),
                labelColor: Colors.black87,
                unselectedLabelColor: Colors.black54,
                tabs: const [
                  Tab(text: 'Lời mời'),
                  Tab(text: 'Thông báo'),
                  Tab(text: 'Khác'),
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      if (error != null)
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade100),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  error!,
                                  style: TextStyle(color: Colors.red.shade700),
                                ),
                              ),
                              TextButton(
                                onPressed: _loadNotifications,
                                child: const Text('Thử lại'),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            // Compute mapped lists once to avoid repeated mapping in child widgets
                            final inviteItems = invites;
                            final requestItems = requests;
                            final notificationItems = notifications;

                            return TabBarView(
                              controller: _tab,
                              children: [
                                _InviteTabBody(
                                  invites: inviteItems,
                                  requests: requestItems,
                                  onAccept: (item) => _handleInviteResponse(
                                    context,
                                    true,
                                    item,
                                  ),
                                  onReject: (item) => _handleInviteResponse(
                                    context,
                                    false,
                                    item,
                                  ),
                                  onCancel: (item) =>
                                      _handleRequestCancel(context, item),
                                  onRefresh: _loadNotifications,
                                ),
                                _FeedTabBody(
                                  notifications: notificationItems,
                                  onTap: (item) =>
                                      _handleNotificationTap(context, item),
                                  onRefresh: _loadNotifications,
                                ),
                                const Center(child: Text('Đang phát triển')),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

// Updated Invite tab body: accepts lists and callbacks (no ancestor lookups)
class _InviteTabBody extends StatelessWidget {
  final List<NotificationItem> invites;
  final List<NotificationItem> requests;
  final void Function(NotificationItem) onAccept;
  final void Function(NotificationItem) onReject;
  final void Function(NotificationItem) onCancel;
  final Future<void> Function()? onRefresh;

  const _InviteTabBody({
    required this.invites,
    required this.requests,
    required this.onAccept,
    required this.onReject,
    required this.onCancel,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (invites.isEmpty && requests.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh ?? () async {},
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(24.0),
          child: Center(child: Text('Không có lời mời hoặc yêu cầu')),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (invites.isNotEmpty) ...[
              const _SectionHeader('Lời mời tham gia nhóm'),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: invites.length,
                itemBuilder: (_, i) => RepaintBoundary(
                  child: _InviteCard(
                    title: invites[i].title,
                    subtitle: invites[i].subtitle,
                    onAccept: () => onAccept(invites[i]),
                    onReject: () => onReject(invites[i]),
                  ),
                ),
                separatorBuilder: (_, __) => const SizedBox(height: 8),
              ),
            ],
            if (requests.isNotEmpty) ...[
              const SizedBox(height: 12),
              const _SectionHeader('Đã gửi yêu cầu'),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: requests.length,
                itemBuilder: (_, i) => RepaintBoundary(
                  child: _RequestRow(
                    title: requests[i].title,
                    subtitle: requests[i].subtitle,
                    onCancel: () => onCancel(requests[i]),
                  ),
                ),
                separatorBuilder: (_, __) => const SizedBox(height: 8),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Updated Feed tab body: accepts mapped list and callback
class _FeedTabBody extends StatelessWidget {
  final List<NotificationItem> notifications;
  final void Function(NotificationItem) onTap;
  final Future<void> Function()? onRefresh;

  const _FeedTabBody({
    required this.notifications,
    required this.onTap,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh ?? () async {},
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(24.0),
          child: Center(child: Text('Không có thông báo')),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: notifications.length,
        itemBuilder: (_, i) => RepaintBoundary(
          child: _NotifTile(
            text: notifications[i].subtitle,
            timeText: formatTime(notifications[i].timestamp),
            onTap: () => onTap(notifications[i]),
          ),
        ),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
  );
}

class _InviteCard extends StatelessWidget {
  final String title, subtitle;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const _InviteCard({
    required this.title,
    required this.subtitle,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard.service(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const CircleAvatar(radius: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: onReject,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                      ),
                      child: const Text('Từ chối'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: onAccept,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text('Tham gia'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestRow extends StatelessWidget {
  final String title, subtitle;
  final VoidCallback? onCancel;

  const _RequestRow({
    required this.title,
    required this.subtitle,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) => CustomCard.service(
    margin: const EdgeInsets.only(bottom: 8),
    child: ListTile(
      leading: const CircleAvatar(),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: OutlinedButton(
        onPressed: onCancel,
        child: const Text('Thu hồi'),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

class _NotifTile extends StatelessWidget {
  final String text;
  final String? timeText;
  final VoidCallback? onTap;

  const _NotifTile({required this.text, this.timeText, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: CustomCard.info(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.circle_notifications_outlined),
              SizedBox(width: 8),
              Text('Thông báo', style: TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              if (timeText != null)
                Text(
                  timeText!,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
            ],
          ),
          SizedBox(height: 6),
          Text(text, style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    ),
  );
}
