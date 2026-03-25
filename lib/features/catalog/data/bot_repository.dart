import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/bot.dart';

class BotRepository {
  final SupabaseClient _supabase;

  BotRepository(this._supabase);

  Future<List<Bot>> getBots() async {
    try {
      final response =
          await _supabase.from('bot_catalog').select().eq('is_active', true);

      return (response as List<dynamic>)
          .map((json) => Bot.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stack) {
      debugPrint('Error in getBots: $e');
      debugPrint('Stacktrace: $stack');
      rethrow;
    }
  }

  Future<Bot?> getBotById(String id) async {
    try {
      final response = await _supabase
          .from('bot_catalog')
          .select()
          .eq('id', id)
          .maybeSingle();
      if (response == null) return null;
      return Bot.fromJson(response);
    } catch (e) {
      debugPrint('Error in getBotById: $e');
      return null;
    }
  }
}
