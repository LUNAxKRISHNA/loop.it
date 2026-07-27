/*
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


*/


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loopit_ui/loopit_ui.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  bool _firstNotificationRead = false;

  void _showNotificationDetails({
    required BuildContext context,
    required String title,
    required String description,
    required String time,
    required String dispatchId,
    required String status,
    required String location,
    required String sentBy,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: LoopitColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: LoopitColors.grey300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Title & Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: "Inter",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: LoopitColors.black,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: status == "Pending"
                          ? const Color(0xFFFEF3C7)
                          : const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: status == "Pending"
                            ? const Color(0xFFD97706)
                            : const Color(0xFF059669),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                time,
                style: const TextStyle(
                  fontFamily: "Inter",
                  fontSize: 12,
                  color: LoopitColors.grey500,
                ),
              ),

              const SizedBox(height: 16),
              const Divider(color: LoopitColors.grey100, thickness: 1),
              const SizedBox(height: 16),

              // Detailed Description
              const Text(
                "Description",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: LoopitColors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: const TextStyle(
                  fontFamily: "Inter",
                  fontSize: 14,
                  height: 1.4,
                  color: LoopitColors.grey500,
                ),
              ),

              const SizedBox(height: 20),

              // Info Meta Grid (Dispatch ID, Destination, Sent By)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: LoopitColors.grey50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildDetailRow("Dispatch ID", dispatchId),
                    const SizedBox(height: 10),
                    _buildDetailRow("Destination", location),
                    const SizedBox(height: 10),
                    _buildDetailRow("Sent By", sentBy),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Close Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LoopitColors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Dismiss",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: LoopitColors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 13,
            color: LoopitColors.grey500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: LoopitColors.black,
          ),
        ),
      ],
    );
  }

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
                      if (!_firstNotificationRead) {
                        setState(() {
                          _firstNotificationRead = true;
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
                            color: LoopitColors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.done_all,
                        size: 20,
                        color: _firstNotificationRead
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
                    // Notification 1
                    NotificationCard(
                      isUnread: !_firstNotificationRead,
                      unreadIcon: Icons.local_shipping_outlined,
                      readIcon: Icons.check_circle_outline,
                      title: "New Dispatch Assigned",
                      description:
                          "You have been assigned a new dispatch #DSP-1235 for South Campus.",
                      time: "2 mins ago",
                      onTap: () {
                        if (!_firstNotificationRead) {
                          setState(() {
                            _firstNotificationRead = true;
                          });
                        }
                        _showNotificationDetails(
                          context: context,
                          title: "New Dispatch Assigned",
                          description:
                              "You have been assigned a new dispatch #DSP-1235 for South Campus. Please confirm receipt and verify the route assignment.",
                          time: "2 mins ago",
                          dispatchId: "#DSP-1235",
                          status: "Pending",
                          location: "South Campus - Block B",
                          sentBy: "Transportation Dept.",
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Notification 2
                    NotificationCard(
                      isUnread: false,
                      unreadIcon: Icons.local_shipping_outlined,
                      readIcon: Icons.check_circle_outline,
                      title: "Dispatch #DSP-1234 Delivered",
                      description:
                          "Your dispatch to North Campus has been successfully delivered.",
                      time: "Yesterday",
                      onTap: () {
                        _showNotificationDetails(
                          context: context,
                          title: "Dispatch #DSP-1234 Delivered",
                          description:
                              "Your dispatch to North Campus has been successfully delivered and confirmed by campus security.",
                          time: "Yesterday, 4:30 PM",
                          dispatchId: "#DSP-1234",
                          status: "Delivered",
                          location: "North Campus - Main Gate",
                          sentBy: "School of STEM Logistics",
                        );
                      },
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
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.isUnread,
    required this.unreadIcon,
    required this.readIcon,
    required this.title,
    required this.description,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                color: isUnread ? LoopitColors.black : LoopitColors.grey100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUnread ? unreadIcon : readIcon,
                size: 20,
                color: isUnread ? LoopitColors.white : LoopitColors.grey500,
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
      ),
    );
  }
}