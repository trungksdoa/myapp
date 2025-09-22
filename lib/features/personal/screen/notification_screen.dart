import 'package:flutter/material.dart';
import 'package:myapp/shared/widgets/common/custom_card.dart';
import 'package:myapp/shared/widgets/common/notification.dart';

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

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  late final TabController _tab = TabController(length: 3, vsync: this);

  final List<NotificationItem> _items = [
    NotificationItem(
      title: 'Hội thích thân lân',
      subtitle: 'Được gọi bởi ABCD • Tham gia để chơi',
      type: NotificationType.invite,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    NotificationItem(
      title: 'Yêu chó',
      subtitle: 'Đã gửi yêu cầu tham gia nhóm',
      type: NotificationType.request,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationItem(
      title: 'Đơn hàng #123',
      subtitle: 'Đơn hàng trị giá 123.444đ đang được xử lý',
      type: NotificationType.notification,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];

  List<NotificationItem> get invites =>
      _items.where((item) => item.type == NotificationType.invite).toList();

  List<NotificationItem> get requests =>
      _items.where((item) => item.type == NotificationType.request).toList();

  List<NotificationItem> get notifications => _items
      .where((item) => item.type == NotificationType.notification)
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
      _items.remove(item);
    });
  }

  void _handleRequestCancel(BuildContext context, NotificationItem item) {
    NotificationUtils.showNotification(context, 'Đã thu hồi yêu cầu');
    setState(() {
      _items.remove(item);
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
            // <- add this
            child: TabBarView(
              controller: _tab,
              children: const [
                _InviteTabBody(),
                _FeedTabBody(),
                Center(child: Text('Đang phát triển')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InviteTabBody extends StatelessWidget {
  const _InviteTabBody();
  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_NotificationsScreenState>();
    if (state == null) return const Center(child: Text('Loading...'));

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      children: [
        if (state.invites.isNotEmpty) ...[
          const _SectionHeader('Lời mời tham gia nhóm'),
          ...state.invites.map(
            (item) => _InviteCard(
              title: item.title,
              subtitle: item.subtitle,
              onAccept: () => state._handleInviteResponse(context, true, item),
              onReject: () => state._handleInviteResponse(context, false, item),
            ),
          ),
        ],
        if (state.requests.isNotEmpty) ...[
          const SizedBox(height: 12),
          const _SectionHeader('Đã gửi yêu cầu'),
          ...state.requests.map(
            (item) => _RequestRow(
              title: item.title,
              subtitle: item.subtitle,
              onCancel: () => state._handleRequestCancel(context, item),
            ),
          ),
        ],
        if (state.invites.isEmpty && state.requests.isEmpty)
          const Center(child: Text('Không có lời mời nào')),
      ],
    );
  }
}

class _FeedTabBody extends StatelessWidget {
  const _FeedTabBody();
  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_NotificationsScreenState>();
    if (state == null) return const Center(child: Text('Loading...'));

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemBuilder: (_, i) => _NotifTile(
        text: state.notifications[i].subtitle,
        onTap: () =>
            state._handleNotificationTap(context, state.notifications[i]),
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: state.notifications.length,
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
  final VoidCallback? onTap;

  const _NotifTile({required this.text, this.onTap});

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
            ],
          ),
          SizedBox(height: 6),
          Text(text, style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    ),
  );
}
