import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

class StripeService {
  final _supabase = Supabase.instance.client;

  // Актуальный Price ID из Stripe
  static const String priceId = 'price_1THeDO1nVM8AbdfCUeaylULL';

  /// Создает сессию оплаты с передачей botId в пути URL
  Future<void> createCheckoutSession({required String botId}) async {
    final session = _supabase.auth.currentSession;

    if (session == null) {
      debugPrint('StripeService: No active Supabase session');
      throw 'User not authenticated';
    }

    try {
      debugPrint(
          'StripeService: Initiating checkout session for bot $botId...');

      // ЗАДАЧА #10: Передаем botId как часть пути для надежности редиректа
      final response = await _supabase.functions.invoke(
        'create-checkout-session',
        body: {
          'priceId': priceId,
          'successUrl': 'https://app.dokki.org/payment-success/$botId',
          'cancelUrl': 'https://app.dokki.org/payment-cancel',
        },
      );

      if (response.status == 200 || response.status == 201) {
        final String? stripeRedirectUrl = response.data['url'];

        if (stripeRedirectUrl != null && stripeRedirectUrl.startsWith('http')) {
          if (kIsWeb) {
            // Открываем Stripe в той же вкладке через JS
            js.context.callMethod(
                'eval', ['window.location.href = "$stripeRedirectUrl"']);
          } else {
            // На мобиле — внешнее приложение
            final uri = Uri.parse(stripeRedirectUrl);
            final launched =
                await launchUrl(uri, mode: LaunchMode.externalApplication);

            if (!launched) throw 'Could not launch payment URL';
          }
        } else {
          throw 'Server returned invalid checkout URL';
        }
      } else {
        throw response.data?['error'] ?? 'Server error ${response.status}';
      }
    } catch (e) {
      debugPrint('StripeService Exception: $e');
      rethrow;
    }
  }
}
