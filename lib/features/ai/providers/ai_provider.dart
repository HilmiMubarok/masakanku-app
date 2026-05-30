import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/repositories/ai_repository.dart';
import '../domain/repositories/i_ai_repository.dart';

/// Provider for the Supabase Client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider for the AI Repository
final aiRepositoryProvider = Provider<IAIRepository>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return AIRepository(supabaseClient);
});
