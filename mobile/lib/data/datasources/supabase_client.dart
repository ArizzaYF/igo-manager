import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  final String url;
  final String anonKey;

  const SupabaseConfig({required this.url, required this.anonKey});
}

class SupabaseClientManager {
  SupabaseClientManager._();

  static SupabaseClient? _instance;

  static SupabaseClient get client {
    if (_instance == null) {
      throw StateError(
        'SupabaseClient not initialized. Call SupabaseClientManager.init() first.',
      );
    }
    return _instance!;
  }

  static Future<void> init(SupabaseConfig config) async {
    await Supabase.initialize(
      url: config.url,
      anonKey: config.anonKey,
    );
    _instance = Supabase.instance.client;
  }

  static bool get isInitialized => _instance != null;
}
