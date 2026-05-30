
import 'package:go_router/go_router.dart';
import '../../presentation/main_layout/screens/main_layout_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainLayoutScreen(),
    ),
  ],
);
