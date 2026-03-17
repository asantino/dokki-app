import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentsRepository {
  final SupabaseClient _client;

  AppointmentsRepository(this._client);

  Future<List<Map<String, dynamic>>> getAppointments() async {
    final response = await _client
        .from('appointments')
        .select()
        .order('datetime_utc', ascending: false)
        .limit(50);
    return List<Map<String, dynamic>>.from(response);
  }
}
