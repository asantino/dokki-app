import 'package:flutter/foundation.dart'; // Оставляем этот, он включает всё необходимое для этого файла
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/screens/auth_screen.dart';
import '../navigation/main_screen.dart';
import '../supabase/supabase_client.dart';
import '../../features/catalog/presentation/screens/bot_detail_screen.dart';
import '../../features/payment/presentation/screens/payment_screen.dart';
import '../../features/settings/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/language_screen.dart';
import '../../features/settings/presentation/screens/notifications_screen.dart';
import '../../features/bot_management/presentation/screens/bot_management_screen.dart';
import '../../features/bot_management/presentation/screens/connect_bot_screen.dart';
import '../../features/bot_management/domain/business.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final supabase = ref.watch(supabaseClientProvider);

  // Исправлено с authListenber на authListener
  final authListener = _AuthNotifier(supabase);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authListener,
    redirect: (context, state) {
      final session = supabase.auth.currentSession;
      final isLoggedIn = session != null;
      final location = state.matchedLocation;

      // Защищенные маршруты
      final isProtectedRoute = location.startsWith('/profile') ||
          location.startsWith('/payment') ||
          location.startsWith('/connect-bot') ||
          location.startsWith('/bot-management');

      final isAuthRoute = location == '/auth';

      if (kDebugMode) {
        debugPrint('=== ROUTER REDIRECT CHECK ===');
        debugPrint('Location: $location | IsLoggedIn: $isLoggedIn');
      }

      // Если не залогинен и пытается зайти в защищенную зону
      if (!isLoggedIn && isProtectedRoute) {
        if (kDebugMode) debugPrint('→ Redirecting to /auth');
        return '/auth';
      }

      // Если залогинен и пытается зайти на экран логина
      if (isLoggedIn && isAuthRoute) {
        if (kDebugMode) debugPrint('→ Redirecting to /');
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return ProfileScreen(currentEmail: email);
        },
      ),
      GoRoute(
        path: '/language',
        builder: (context, state) => const LanguageScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/bot-detail/:category',
        builder: (context, state) => BotDetailScreen(
          category: state.pathParameters['category']!,
        ),
      ),
      GoRoute(
        path: '/payment',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return PaymentScreen(
            botId: extra['botId'] as String,
            botName: extra['botName'] as String,
            botDescription: extra['botDescription'] as String,
            priceMonthly: extra['priceMonthly'] as double,
            priceYearly: extra['priceYearly'] as double,
          );
        },
      ),
      GoRoute(
        path: '/connect-bot/:botId/:botName',
        builder: (context, state) => ConnectBotScreen(
          botId: state.pathParameters['botId']!,
          botName: state.pathParameters['botName']!,
        ),
      ),
      GoRoute(
        path: '/bot-management/:botId',
        builder: (context, state) => BotManagementScreen(
          business: state.extra as Business,
        ),
      ),
    ],
  );
});

/// Класс, который трансформирует события Supabase в уведомления для GoRouter
class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier(SupabaseClient supabase) {
    supabase.auth.onAuthStateChange.listen((data) {
      if (kDebugMode) {
        debugPrint('=== AUTH STATE CHANGED: ${data.event} ===');
      }
      notifyListeners();
    });
  }
}
