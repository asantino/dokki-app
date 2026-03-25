import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../bot_management/presentation/screens/connect_bot_screen.dart';

// TODO: Интеграция с in_app_purchase после регистрации в App Store
// import 'package:in_app_purchase/in_app_purchase.dart';

class PaymentScreen extends StatefulWidget {
  final String botId;
  final String botName;
  final String botDescription;
  final double priceMonthly;
  final double priceYearly;

  const PaymentScreen({
    super.key,
    required this.botId,
    required this.botName,
    required this.botDescription,
    required this.priceMonthly,
    required this.priceYearly,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPlan = 'yearly';

  void _showPaymentSuccess() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Оплата успешна'),
        content: const Text('Подписка активирована (тестовый режим)'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(c);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ConnectBotScreen(
                    botId: widget.botId,
                    botName: widget.botName,
                  ),
                ),
              );
            },
            child: const Text('Продолжить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double savings = (widget.priceMonthly * 12) - widget.priceYearly;
    final int savingsPercent =
        (((widget.priceMonthly * 12) - widget.priceYearly) /
                (widget.priceMonthly * 12) *
                100)
            .round();
    final double currentPrice =
        _selectedPlan == 'monthly' ? widget.priceMonthly : widget.priceYearly;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Подписка на ${widget.botName}',
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                fontSize: 18)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.botName,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text(widget.botDescription,
                style: const TextStyle(
                    fontSize: 16, color: AppColors.textSecondary)),
            const SizedBox(height: 32),
            _buildPlanCard(
              id: 'monthly',
              title: 'Месяц',
              price: '\$${widget.priceMonthly.toStringAsFixed(2)}/месяц',
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              id: 'yearly',
              title: 'Год',
              price: '\$${widget.priceYearly.toStringAsFixed(2)}/год',
              subtitle: 'Экономия \$$savings ($savingsPercent%)',
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _showPaymentSuccess,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'ПОДКЛЮЧИТЬ ЗА \$${currentPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
      {required String id,
      required String title,
      required String price,
      String? subtitle}) {
    final bool isSelected = _selectedPlan == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? AppColors.accent : Colors.transparent,
              width: 2),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: id,
              groupValue: _selectedPlan,
              activeColor: AppColors.accent,
              onChanged: (val) => setState(() => _selectedPlan = val!),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontFamily: 'Inter')),
                Text(price,
                    style: const TextStyle(
                        fontSize: 16, color: AppColors.textSecondary)),
                if (subtitle != null)
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
