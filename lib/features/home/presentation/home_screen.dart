import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loopit_ui/loopit_ui.dart';

import '../../auth/application/auth_notifier.dart';

import '../../../core/models/dispatch_model.dart';
import '../../dispatch/data/dispatch_repository.dart';
import '../../dispatch/presentation/create_dispatch/create_dispatch_screen.dart';

final myDispatchesProvider = FutureProvider<List<DispatchModel>>((ref) {
  return ref.watch(dispatchRepositoryProvider).getMyDispatches();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authNotifierProvider);
    final user = userState.valueOrNull;
    final userName = user?.name ?? 'User';
    final currentUserId = user?.id;
    final dispatchesAsync = ref.watch(myDispatchesProvider);

    return Scaffold(
      backgroundColor: LoopitColors.grey50, // Light background for contrast with white cards
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: LoopitColors.grey500,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$userName!',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: LoopitColors.black,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: LoopitColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: LoopitColors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.history,
                      color: LoopitColors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: LoopitColors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: LoopitColors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: LoopitColors.grey500, size: 24),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Search dispatches...',
                        style: TextStyle(
                          color: LoopitColors.grey500,
                          fontSize: 15,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: LoopitColors.grey50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.tune, color: LoopitColors.black, size: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Statistics Grid
              dispatchesAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Unable to load stats from Supabase',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: LoopitColors.grey500,
                      ),
                    ),
                  ),
                ),
                data: (dispatches) {
                  final activeCount = dispatches.where((d) =>
                    d.status == DispatchStatus.inTransit ||
                    d.status == DispatchStatus.collectedSource ||
                    d.status == DispatchStatus.arrivedDestination
                  ).length;

                  final pendingCount = dispatches.where((d) =>
                    d.status == DispatchStatus.pending
                  ).length;

                  final assignedCount = dispatches.where((d) =>
                    currentUserId != null && d.currentHolderId == currentUserId
                  ).length;

                  final completedCount = dispatches.where((d) =>
                    d.status == DispatchStatus.completed
                  ).length;

                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.25,
                    children: [
                      _StatCard(
                        icon: Icons.inventory_2_outlined,
                        value: activeCount.toString().padLeft(2, '0'),
                        label: 'Active Dispatches',
                      ),
                      _StatCard(
                        icon: Icons.download_outlined,
                        value: pendingCount.toString().padLeft(2, '0'),
                        label: 'Pending Collection',
                      ),
                      _StatCard(
                        icon: Icons.local_shipping_outlined,
                        value: assignedCount.toString().padLeft(2, '0'),
                        label: 'Assigned Deliveries',
                      ),
                      _StatCard(
                        icon: Icons.check_circle_outline,
                        value: completedCount.toString().padLeft(2, '0'),
                        label: 'Completed',
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),

              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: LoopitColors.black,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.add_box_outlined,
                      label: 'Create\nDispatch',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CreateDispatchScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(child: _ActionCard(icon: Icons.description_outlined, label: 'My\nDispatches')),
                  const SizedBox(width: 8),
                  const Expanded(child: _ActionCard(icon: Icons.person_outline, label: 'Assigned\n')),
                ],
              ),
              const SizedBox(height: 120), // Bottom padding for floating navigation bar clearance
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LoopitColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: LoopitColors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: LoopitColors.black, size: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: LoopitColors.black,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: LoopitColors.grey500,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
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

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      decoration: BoxDecoration(
        color: LoopitColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: LoopitColors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: LoopitColors.black, size: 28),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: LoopitColors.black,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

