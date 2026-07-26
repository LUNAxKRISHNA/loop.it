import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loopit_ui/loopit_ui.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends ConsumerState<NotificationsScreen> {
  bool _allMarkedAsRead = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LoopitColors.grey50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Notifications",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: LoopitColors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!_allMarkedAsRead) {
                        setState(() {
                          _allMarkedAsRead = true;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: LoopitColors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color:
                                LoopitColors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.done_all,
                        size: 20,
                        color: _allMarkedAsRead
                            ? Colors.blue
                            : LoopitColors.black,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Expanded(
                child: ListView(
                  children: [
                    NotificationCard(
                      isUnread: _allMarkedAsRead ? false : true,
                      unreadIcon: Icons.local_shipping_outlined,
                      readIcon: Icons.check_circle_outline,
                      title: "New Dispatch Assigned",
                      description:
                          "You have been assigned a new dispatch #DSP-1235 for South Campus.",
                      time: "2 mins ago",
                    ),

                    const SizedBox(height: 16),

                    const NotificationCard(
                      isUnread: false,
                      unreadIcon: Icons.local_shipping_outlined,
                      readIcon: Icons.check_circle_outline,
                      title: "Dispatch #DSP-1234 Delivered",
                      description:
                          "Your dispatch to North Campus has been successfully delivered.",
                      time: "Yesterday",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final bool isUnread;
  final IconData unreadIcon;
  final IconData readIcon;
  final String title;
  final String description;
  final String time;

  const NotificationCard({
    super.key,
    required this.isUnread,
    required this.unreadIcon,
    required this.readIcon,
    required this.title,
    required this.description,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: LoopitColors.white,
        borderRadius: BorderRadius.circular(24),
        border: isUnread
            ? Border.all(
                color: LoopitColors.black,
                width: 1.5,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: LoopitColors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUnread
                  ? LoopitColors.black
                  : LoopitColors.grey100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUnread ? unreadIcon : readIcon,
              size: 20,
              color: isUnread
                  ? LoopitColors.white
                  : LoopitColors.grey500,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 15,
                          fontWeight: isUnread
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: LoopitColors.black,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: LoopitColors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: "Inter",
                    fontSize: 13,
                    height: 1.4,
                    color: LoopitColors.grey500,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  time,
                  style: const TextStyle(
                    fontFamily: "Inter",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: LoopitColors.grey300,
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
