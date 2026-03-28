import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/business.dart';
import '../domain/business_repository.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  final SupabaseClient _client;

  BusinessRepositoryImpl(this._client);

  @override
  Future<Business> connectBot({
    required String botId,
    required String botToken,
    required String railwayToken,
    required String railwayWorkspaceId,
  }) async {
    final userId = _client.auth.currentUser!.id;

    print('🔵 Connecting bot: userId=$userId, botId=$botId');

    try {
      final response = await _client
          .from('businesses')
          .upsert(
            {
              'user_id': userId,
              'bot_id': botId,
              'bot_token': botToken,
              'client_railway_token': railwayToken,
              'client_railway_workspace_id': railwayWorkspaceId,
              'status': 'pending',
            },
            onConflict: 'user_id,bot_id',
          )
          .select('*, bot_catalog(*)')
          .single();

      print('🔵 Upsert successful');
      return Business.fromJson(response);
    } catch (e) {
      print('🔴 Upsert failed: $e');
      rethrow;
    }
  }

  @override
  Future<List<Business>> getConnectedBots() async {
    final userId = _client.auth.currentUser!.id;

    final response = await _client
        .from('businesses')
        .select('*, bot_catalog(*)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((json) => Business.fromJson(json)).toList();
  }

  @override
  Future<Business?> getBusinessById(String id) async {
    try {
      final response = await _client
          .from('businesses')
          .select('*, bot_catalog(*)')
          .eq('id', id)
          .single();

      return Business.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateRailwayUrl(String businessId, String railwayUrl) async {
    await _client
        .from('businesses')
        .update({'railway_url': railwayUrl}).eq('id', businessId);
  }
}
