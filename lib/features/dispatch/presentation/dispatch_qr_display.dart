import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loopit_ui/loopit_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/models/dispatch_model.dart';
import '../../dispatch/data/dispatch_repository.dart';

/// Shows a bottom sheet listing active dispatches held by the current user.
/// The user selects one and a fresh QR token is generated and displayed.
Future<void> showAuthorizationQrSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _DispatchPickerSheet(),
  );
}

class _DispatchPickerSheet extends ConsumerWidget {
  const _DispatchPickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dispatchesAsync = ref.watch(_myActiveDispatchesProvider);

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
          // Drag handle
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
          const Text(
            'Show Authorization QR',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: LoopitColors.black,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Select an active dispatch to generate a transfer QR code.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: LoopitColors.grey500,
            ),
          ),
          const SizedBox(height: 20),

          dispatchesAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, _) => Center(
              child: Text(
                'Error loading dispatches: $e',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: LoopitColors.grey500,
                ),
              ),
            ),
            data: (dispatches) {
              if (dispatches.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'No active dispatches in your custody.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: LoopitColors.grey500,
                      ),
                    ),
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dispatches.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final d = dispatches[index];
                  return _DispatchTile(dispatch: d);
                },
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _DispatchTile extends StatelessWidget {
  final DispatchModel dispatch;
  const _DispatchTile({required this.dispatch});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tileColor: LoopitColors.grey50,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: LoopitColors.black,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.inventory_2_outlined, color: LoopitColors.white, size: 18),
      ),
      title: Text(
        dispatch.title ?? dispatch.dispatchNo ?? 'Dispatch',
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: LoopitColors.black,
        ),
      ),
      subtitle: Text(
        '${dispatch.dispatchNo ?? ''} · ${dispatch.status.displayLabel}',
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: LoopitColors.grey500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: LoopitColors.grey500),
      onTap: () {
        Navigator.pop(context);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => _QrDisplaySheet(dispatch: dispatch),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// QR Display Sheet — shows the generated QR with 5-minute countdown
// ---------------------------------------------------------------------------
class _QrDisplaySheet extends ConsumerStatefulWidget {
  final DispatchModel dispatch;
  const _QrDisplaySheet({required this.dispatch});

  @override
  ConsumerState<_QrDisplaySheet> createState() => _QrDisplaySheetState();
}

class _QrDisplaySheetState extends ConsumerState<_QrDisplaySheet> {
  DispatchModel? _dispatch;
  bool _isGenerating = false;
  Timer? _countdownTimer;
  int _secondsLeft = 0;

  @override
  void initState() {
    super.initState();
    _generateQR();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _generateQR() async {
    setState(() => _isGenerating = true);
    try {
      final updated = await ref
          .read(dispatchRepositoryProvider)
          .generateQRToken(widget.dispatch.id);
      if (mounted) {
        setState(() {
          _dispatch = updated;
          _isGenerating = false;
          _secondsLeft = 5 * 60; // 5 minutes
        });
        _startCountdown();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isGenerating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating QR: $e')),
        );
      }
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  String get _formattedTime {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Color get _timerColor {
    if (_secondsLeft > 120) return Colors.green.shade600;
    if (_secondsLeft > 60) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  @override
  Widget build(BuildContext context) {
    final d = _dispatch ?? widget.dispatch;

    return Container(
      decoration: const BoxDecoration(
        color: LoopitColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
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

          Text(
            d.title ?? d.dispatchNo ?? 'Dispatch QR',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: LoopitColors.black,
            ),
          ),
          if (d.dispatchNo != null) ...[
            const SizedBox(height: 4),
            Text(
              d.dispatchNo!,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: LoopitColors.grey500,
              ),
            ),
          ],
          const SizedBox(height: 24),

          // QR Code area
          if (_isGenerating)
            const SizedBox(
              height: 220,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (d.qrToken != null && _secondsLeft > 0)
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: LoopitColors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: LoopitColors.grey100, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: LoopitColors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: d.qrToken!,
                    version: QrVersions.auto,
                    size: 200,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: LoopitColors.black,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: LoopitColors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Countdown timer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timer_outlined, color: _timerColor, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Expires in $_formattedTime',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _timerColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Show this QR to the next person collecting the dispatch.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: LoopitColors.grey500,
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                const Icon(Icons.qr_code_outlined, size: 80, color: LoopitColors.grey300),
                const SizedBox(height: 12),
                const Text(
                  'QR code has expired.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: LoopitColors.grey500,
                  ),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: _generateQR,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Generate New QR'),
                ),
              ],
            ),

          const SizedBox(height: 24),

          // Regenerate button (while QR is active)
          if (!_isGenerating && d.qrToken != null && _secondsLeft > 0)
            TextButton.icon(
              onPressed: _generateQR,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text(
                'Regenerate',
                style: TextStyle(fontFamily: 'Inter', fontSize: 13),
              ),
            ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// Provider to fetch only dispatches currently held by the user
final _myActiveDispatchesProvider = FutureProvider<List<DispatchModel>>((ref) async {
  final allDispatches = await ref.watch(dispatchRepositoryProvider).getMyDispatches();
  return allDispatches
      .where((d) =>
          d.status == DispatchStatus.collectedSource ||
          d.status == DispatchStatus.inTransit)
      .toList();
});
