import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text('Profil Kamu', style: textTheme.headlineMedium),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Profile Header
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: colors.peachAccent,
                backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80'),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hilmi Mubarok', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('hilmi@example.com', style: textTheme.bodyMedium?.copyWith(color: colors.outline)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Preferences Section
          Text('Preferensi Memasak', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colors.mainPink)),
          const SizedBox(height: 16),
          _buildSettingsTile(
            context,
            icon: Icons.restaurant_menu_rounded,
            title: 'Tipe Diet',
            subtitle: 'Tidak ada pantangan',
            colors: colors,
          ),
          _buildSettingsTile(
            context,
            icon: Icons.local_fire_department_rounded,
            title: 'Level Pedas',
            subtitle: 'Sedang',
            colors: colors,
          ),
          _buildSettingsTile(
            context,
            icon: Icons.health_and_safety_rounded,
            title: 'Alergi',
            subtitle: 'Tidak ada alergi',
            colors: colors,
          ),

          const SizedBox(height: 32),
          // App Settings Section
          Text('Pengaturan Aplikasi', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colors.mainPink)),
          const SizedBox(height: 16),
          _buildSettingsTile(
            context,
            icon: Icons.dark_mode_rounded,
            title: 'Mode Gelap',
            trailing: Switch(
              value: false,
              onChanged: (val) {},
              activeTrackColor: colors.mainPink,
            ),
            colors: colors,
          ),
          _buildSettingsTile(
            context,
            icon: Icons.language_rounded,
            title: 'Bahasa',
            subtitle: 'Indonesia',
            colors: colors,
          ),
          _buildSettingsTile(
            context,
            icon: Icons.info_outline_rounded,
            title: 'Tentang Masakanku',
            subtitle: 'Versi 1.0.0',
            colors: colors,
          ),
          
          const SizedBox(height: 32),
          // Logout Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.error,
                side: BorderSide(color: colors.error.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Keluar Akun', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required AppColors colors,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colors.surfaceVariant,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: colors.onSurfaceVariant, size: 20),
        ),
        title: Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
        subtitle: subtitle != null ? Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.outline)) : null,
        trailing: trailing ?? Icon(Icons.chevron_right_rounded, color: colors.outline),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
