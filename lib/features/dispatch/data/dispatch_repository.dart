import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/campus_model.dart';
import '../../../core/models/custody_log_model.dart';
import '../../../core/models/dispatch_model.dart';
import '../../../core/providers/supabase_providers.dart';

final dispatchRepositoryProvider = Provider<DispatchRepository>((ref) {
  return DispatchRepository(ref.watch(supabaseClientProvider));
});

class DispatchRepository {
  final SupabaseClient _client;

  DispatchRepository(this._client);

  // ---------------------------------------------------------------------------
  // Campuses
  // ---------------------------------------------------------------------------

  /// Fetches all campuses from the database.
  Future<List<CampusModel>> getCampuses() async {
    final response = await _client
        .from('campuses')
        .select()
        .order('campus_name');
    return (response as List).map((e) => CampusModel.fromJson(e)).toList();
  }

  // ---------------------------------------------------------------------------
  // Dispatches — CRUD
  // ---------------------------------------------------------------------------

  /// Creates a new dispatch. The database trigger auto-generates dispatch_no.
  Future<DispatchModel> createDispatch(DispatchModel dispatch) async {
    final response = await _client
        .from('dispatches')
        .insert(dispatch.toInsertJson())
        .select()
        .single();
    return DispatchModel.fromJson(response);
  }

  /// Fetches all dispatches for the current user (created by them or holding).
  Future<List<DispatchModel>> getMyDispatches() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from('dispatches')
        .select()
        .or('sender_id.eq.$userId,current_holder_id.eq.$userId')
        .order('created_at', ascending: false);

    return (response as List).map((e) => DispatchModel.fromJson(e)).toList();
  }

  /// Fetches a single dispatch by its ID.
  Future<DispatchModel> getDispatchById(String id) async {
    final response = await _client
        .from('dispatches')
        .select()
        .eq('id', id)
        .single();
    return DispatchModel.fromJson(response);
  }

  // ---------------------------------------------------------------------------
  // QR Token Management
  // ---------------------------------------------------------------------------

  /// Generates a new QR token for the given dispatch, valid for 5 minutes.
  /// Only the current holder should be able to call this.
  Future<DispatchModel> generateQRToken(String dispatchId) async {
    final token = _generateToken();
    final expiresAt = DateTime.now().add(const Duration(minutes: 5));

    final response = await _client
        .from('dispatches')
        .update({
          'qr_token': token,
          'qr_token_expires_at': expiresAt.toIso8601String(),
        })
        .eq('id', dispatchId)
        .select()
        .single();

    return DispatchModel.fromJson(response);
  }

  // ---------------------------------------------------------------------------
  // Custody Transfer (QR Scan Handler)
  // ---------------------------------------------------------------------------

  /// Validates the scanned QR token and transfers custody to the new holder.
  ///
  /// - [qrToken]: The token decoded from the scanned QR code.
  /// - [newHolderId]: The auth uid of the person scanning (new custodian).
  /// - [newHolderName]: Display name of the new holder.
  /// - [newCampusId]: The campus where the scan is happening (optional).
  Future<DispatchModel> transferCustody({
    required String qrToken,
    required String newHolderId,
    required String newHolderName,
    String? newCampusId,
  }) async {
    // 1. Find dispatch by token and validate it's not expired
    final response = await _client
        .from('dispatches')
        .select()
        .eq('qr_token', qrToken)
        .single();

    final dispatch = DispatchModel.fromJson(response);

    if (!dispatch.isQrTokenValid) {
      throw Exception('QR code has expired. Ask the sender to generate a new one.');
    }

    // 2. Determine the new status based on location
    final newStatus = _resolveNextStatus(dispatch, newCampusId);

    // 3. Update the dispatch — the DB trigger will auto-log to dispatch_custody_logs
    final updated = await _client
        .from('dispatches')
        .update({
          'current_holder_id': newHolderId,
          'current_holder_name': newHolderName,
          'current_campus_id': newCampusId,
          'status': newStatus.toDbString(),
          // Invalidate QR after successful scan
          'qr_token': null,
          'qr_token_expires_at': null,
        })
        .eq('id', dispatch.id)
        .select()
        .single();

    return DispatchModel.fromJson(updated);
  }

  // ---------------------------------------------------------------------------
  // Handover History
  // ---------------------------------------------------------------------------

  /// Fetches the full chain-of-custody history for a dispatch, ordered by time.
  Future<List<CustodyLogModel>> getCustodyHistory(String dispatchId) async {
    final response = await _client
        .from('dispatch_custody_logs')
        .select()
        .eq('dispatch_id', dispatchId)
        .order('transferred_at');

    return (response as List).map((e) => CustodyLogModel.fromJson(e)).toList();
  }

  // ---------------------------------------------------------------------------
  // Realtime
  // ---------------------------------------------------------------------------

  /// Streams real-time updates for a specific dispatch row.
  Stream<DispatchModel> streamDispatch(String dispatchId) {
    return _client
        .from('dispatches')
        .stream(primaryKey: ['id'])
        .eq('id', dispatchId)
        .map((rows) => DispatchModel.fromJson(rows.first));
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _generateToken() {
    // Generates a compact random token using current timestamp + random suffix
    final timestamp = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
    final random = (DateTime.now().microsecond * 31337).toRadixString(36);
    return '$timestamp-$random';
  }

  DispatchStatus _resolveNextStatus(DispatchModel dispatch, String? newCampusId) {
    // First pickup from source
    if (dispatch.status == DispatchStatus.pending) {
      return DispatchStatus.collectedSource;
    }
    // Arrived at destination campus
    if (newCampusId != null && newCampusId == dispatch.destinationCampusId) {
      return DispatchStatus.arrivedDestination;
    }
    // Mid-transit transfer
    return DispatchStatus.inTransit;
  }
}
