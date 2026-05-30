import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/auth/device_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jdmnfluhrdiagqpjwuwq.supabase.co',
    anonKey: 'sb_publishable_TMiGczkZAz_Mo0olitptuQ_i6gu-2xa',
  );

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        deviceAuthProvider.overrideWithValue(DeviceAuthService(prefs)),
      ],
      child: const MasakankuApp(),
    ),
  );
}

class MasakankuApp extends StatelessWidget {
  const MasakankuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Masakanku',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
