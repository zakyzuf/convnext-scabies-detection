import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getUserDetectionHistory() async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception("User belum login");

    final response = await supabase
        .from('detection_history')
        .select()
        .eq('id_user', user.id)
        .order('created_at', ascending: false);

    if (response is List) {
      return response.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future<void> deleteDetectionHistory(int id) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception("User belum login");

    try {
      await supabase
          .from('detection_history')
          .delete()
          .eq('id_user', user.id)
          .eq('id', id);

      return;
    } catch (error) {
      throw Exception("Gagal menghapus data: ${error.toString()}");
    }
  }
}
