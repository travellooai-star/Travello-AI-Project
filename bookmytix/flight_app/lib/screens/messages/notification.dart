import 'package:flight_app/controllers/notification_controller.dart';
import 'package:flight_app/models/notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flight_app/ui/themes/theme_palette.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';

class Notification extends StatefulWidget {
  const Notification({super.key});

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late NotificationController _ctrl;

  // Local mutable copies mirroring controller (rebuilt after actions)
  late List<NotificationModel> _today;
  late List<NotificationModel> _earlier;

  int get _unreadCount =>
      [..._today, ..._earlier].where((n) => !n.isRead).length;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<NotificationController>();
    final args = Get.arguments;
    final initialTab =
        (args is Map && args['tab'] != null) ? args['tab'] as int : 0;
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: initialTab);
    _today = List.from(_ctrl.today);
    _earlier = List.from(_ctrl.earlier);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _markAllRead() {
    _ctrl.markAllRead();
    setState(() {
      _today = List.from(_ctrl.today);
      _earlier = List.from(_ctrl.earlier);
    });
  }

  void _clearAll() {
    _ctrl.clearAll();
    setState(() {
      _today.clear();
      _earlier.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final unread = _unreadCount;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text('Updates',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: Text('Mark all read',
                style: TextStyle(
                    fontSize: 13,
                    color: ThemePalette.primaryMain,
                    fontWeight: FontWeight.w600)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                indicatorColor: ThemePalette.primaryMain,
                indicatorWeight: 2.5,
                labelColor: ThemePalette.primaryMain,
                unselectedLabelColor: Colors.grey.shade500,
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                unselectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Notifications'),
                        if (unread > 0) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('$unread',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Tab(text: 'Messages'),
                ],
              ),
              Divider(height: 1, color: Colors.grey.shade200),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationsTab(),
          _buildMessagesTab(),
        ],
      ),
    );
  }

  // ── NOTIFICATIONS TAB ────────────────────────────────────────────────────────
  Widget _buildNotificationsTab() {
    final hasAny = _today.isNotEmpty || _earlier.isNotEmpty;
    if (!hasAny) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFFDF5D8),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.notifications_none_rounded,
                  size: 40, color: ThemePalette.primaryMain),
            ),
            const SizedBox(height: 20),
            const Text("You're all caught up!",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const SizedBox(height: 8),
            Text('No new notifications at the moment.',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          ],
        ),
      );
    }
    return Column(
      children: [
        // ── Action bar ─────────────────────────────────────────────────────
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_today.length + _earlier.length} notification${(_today.length + _earlier.length) == 1 ? '' : 's'}',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500),
              ),
              GestureDetector(
                onTap: () => showDialog(
                  context: Get.context!,
                  builder: (_) => AlertDialog(
                    title: const Text('Clear all notifications?'),
                    content: const Text(
                        'All notifications will be permanently removed.'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ThemePalette.primaryMain),
                        onPressed: () {
                          Get.back();
                          _clearAll();
                        },
                        child: const Text('Clear All',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep_outlined,
                        size: 17, color: Colors.red.shade400),
                    const SizedBox(width: 4),
                    Text('Clear all',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.red.shade400,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade200),
        // ── List ───────────────────────────────────────────────────────────
        Expanded(
          child: ListView(
            children: [
              if (_today.isNotEmpty) ...[
                const _SectionHeader(label: 'TODAY'),
                ..._today.asMap().entries.map((e) => _NotifTile(
                      item: e.value,
                      onDismiss: () {
                        setState(() => _today.removeAt(e.key));
                        _ctrl.today.removeAt(e.key);
                      },
                    )),
              ],
              if (_earlier.isNotEmpty) ...[
                const _SectionHeader(label: 'EARLIER'),
                ..._earlier.asMap().entries.map((e) => _NotifTile(
                      item: e.value,
                      onDismiss: () {
                        setState(() => _earlier.removeAt(e.key));
                        _ctrl.earlier.removeAt(e.key);
                      },
                    )),
              ],
              SizedBox(height: 20 + MediaQuery.of(Get.context!).padding.bottom),
            ],
          ),
        ),
      ],
    );
  }

  // ── MESSAGES TAB ─────────────────────────────────────────────────────────────
  Widget _buildMessagesTab() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF5D8),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.chat_bubble_outline_rounded,
                        color: ThemePalette.primaryMain, size: 28),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.chat_bubble_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('No messages yet',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'Hotels and properties can message you here\nafter you book a stay.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Section header (TODAY / EARLIER) ─────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});
  @override
  Widget build(BuildContext context) => Container(
        color: const Color(0xFFF5F5F5),
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
        child: Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF888888),
                letterSpacing: 1.0)),
      );
}

// ── Notification Tile ─────────────────────────────────────────────────────────
class _NotifTile extends StatelessWidget {
  final NotificationModel item;
  final VoidCallback onDismiss;
  const _NotifTile({required this.item, required this.onDismiss});

  // Left icon square — color + icon by category
  Color get _iconBg {
    switch (item.category) {
      case 'flight':
        return const Color(0xFFFDF5D8);
      case 'train':
        return const Color(0xFFFEF3DC);
      case 'hotel':
        return const Color(0xFFFDF5D8);
      case 'emergency':
        return const Color(0xFFFFEBEE);
      case 'ai':
        return const Color(0xFFFDF0C0);
      default:
        return const Color(0xFFF5F5F5);
    }
  }

  Color get _iconColor {
    switch (item.category) {
      case 'flight':
        return const Color(0xFFD4AF37);
      case 'train':
        return const Color(0xFFB8935C);
      case 'hotel':
        return const Color(0xFFD4AF37);
      case 'emergency':
        return const Color(0xFFC62828);
      case 'ai':
        return const Color(0xFFD4AF37);
      default:
        return Colors.grey;
    }
  }

  IconData get _iconData {
    switch (item.category) {
      case 'flight':
        return Icons.flight_rounded;
      case 'train':
        return Icons.train_rounded;
      case 'hotel':
        return Icons.hotel_rounded;
      case 'emergency':
        return Icons.local_hospital_rounded;
      case 'ai':
        return Icons.auto_awesome_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  // Tag badge colors per brand
  Color _tagColor(String tag) {
    switch (tag) {
      case 'PIA':
        return const Color(0xFFB8860B); // dark gold
      case 'AirBlue':
        return const Color(0xFFB8935C); // warm gold-brown
      case 'AirSial':
        return const Color(0xFFB8860B); // dark gold
      case 'Serene':
        return const Color(0xFFB8935C); // warm gold-brown
      case 'Train':
        return const Color(0xFFC49A3C); // muted gold
      case 'Hotel':
        return const Color(0xFFB8860B); // dark gold
      case 'AI Trip':
        return const Color(0xFFC49A3C); // muted gold
      case 'Emergency':
        return const Color(0xFFC62828); // red — kept for safety
      default:
        return const Color(0xFFB8935C);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.title + item.date),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red.shade50,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.red),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: item.isRead ? Colors.white : const Color(0xFFFEF9EC),
            padding: EdgeInsets.symmetric(
                horizontal: spacingUnit(2), vertical: spacingUnit(1.5)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Unread dot
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 4),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: item.isRead
                          ? Colors.transparent
                          : ThemePalette.primaryMain,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Category icon square
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                      color: _iconBg, borderRadius: BorderRadius.circular(10)),
                  child: Icon(_iconData, color: _iconColor, size: 22),
                ),
                const SizedBox(width: 11),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontWeight: item.isRead
                                    ? FontWeight.w500
                                    : FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black87,
                                height: 1.3,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {},
                            child: Icon(Icons.more_horiz,
                                size: 18, color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      // Tag badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: _tagColor(item.tag).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(item.tag,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: _tagColor(item.tag),
                            )),
                      ),
                      const SizedBox(height: 4),
                      Text(item.subtitle,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              height: 1.4),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 5),
                      Text(item.date,
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade400)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            thickness: 0.6,
            indent: 69,
            color: Color(0xFFEEEEEE),
          ),
        ],
      ),
    );
  }
}
