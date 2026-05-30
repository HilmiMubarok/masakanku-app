import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/chat_bubble.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, dynamic>> _dummyMessages = [
    {
      'text': 'Haloo! Aku udah liat kulkas kamu nih. Mau aku bikinin ide menu apa hari ini?',
      'isUser': false,
    },
    {
      'text': 'Bikinin menu sehat dong dari stok yang ada',
      'isUser': true,
    },
    {
      'text': 'Siapp! Dari stok telur, sawi, dan ayam, kita bisa bikin **Tumis Ayam Sawi Hijau**. Cuma butuh 15 menit dan pastinya sehat. Mau lihat resep lengkapnya?',
      'isUser': false,
    },
  ];

  final List<String> _quickPrompts = [
    'Menu sehat',
    'Resep low budget',
    'Ada sisa nasi nih',
    'Comfort food',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text('AI Assistant', style: textTheme.headlineMedium?.copyWith(fontSize: 18)),
            const SizedBox(height: 2),
            Text(
              'Online',
              style: textTheme.labelSmall?.copyWith(color: colors.matchaGreen, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: colors.outlineVariant.withValues(alpha: 0.3),
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: _dummyMessages.length,
              itemBuilder: (context, index) {
                final msg = _dummyMessages[index];
                return ChatBubble(
                  text: msg['text'] as String,
                  isUser: msg['isUser'] as bool,
                );
              },
            ),
          ),
          
          // Quick Prompts
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _quickPrompts.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return ActionChip(
                  label: Text(_quickPrompts[index]),
                  onPressed: () {},
                  backgroundColor: colors.surface,
                  side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.5)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  labelStyle: textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant),
                );
              },
            ),
          ),
          
          // Input Area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.background,
              boxShadow: [
                BoxShadow(
                  color: colors.mainPink.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: colors.surfaceVariant,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.mic_rounded, color: colors.onSurfaceVariant),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ketik pesan...',
                        hintStyle: textTheme.bodyMedium?.copyWith(color: colors.outline),
                        filled: true,
                        fillColor: colors.surfaceVariant.withValues(alpha: 0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: colors.mainPink,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
