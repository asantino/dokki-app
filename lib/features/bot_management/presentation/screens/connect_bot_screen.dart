import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../../../../core/env/env.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/localization/language_provider.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../catalog/providers/catalog_providers.dart';
import '../../providers/bot_management_providers.dart';

class ConnectBotScreen extends ConsumerStatefulWidget {
  final String botId;
  final String botName;

  const ConnectBotScreen({
    super.key,
    required this.botId,
    required this.botName,
  });

  @override
  ConsumerState<ConnectBotScreen> createState() => _ConnectBotScreenState();
}

class _ConnectBotScreenState extends ConsumerState<ConnectBotScreen> {
  final _pageController = PageController();
  int _currentStep = 0;

  final _botTokenController = TextEditingController();
  final _railwayTokenController = TextEditingController();
  final _workspaceIdController = TextEditingController();

  bool _isLoading = false;
  late AppStrings _s;

  @override
  void dispose() {
    _pageController.dispose();
    _botTokenController.dispose();
    _railwayTokenController.dispose();
    _workspaceIdController.dispose();
    super.dispose();
  }

  Future<void> _validateTelegramAndProceed() async {
    final token = _botTokenController.text.trim();
    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_s.connErrorNoToken)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(telegramRepositoryProvider).validateToken(token);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep = 1);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_s.authError}: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _connect() async {
    final botToken = _botTokenController.text.trim();
    final railwayToken = _railwayTokenController.text.trim();
    final workspaceId = _workspaceIdController.text.trim();

    if (railwayToken.isEmpty || workspaceId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_s.connErrorNoRailway)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await ref.read(businessRepositoryProvider).connectBot(
            botId: widget.botId,
            botToken: botToken,
            railwayToken: railwayToken,
            railwayWorkspaceId: workspaceId,
          );

      final bot = await ref.read(botByIdProvider(widget.botId).future);

      await http.post(
        Uri.parse('${Env.deployServiceUrl}/deploy'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'businessId': result.id,
          'botId': widget.botId,
          'botToken': botToken,
          'githubRepo': bot?.githubRepo,
          'railwayToken': railwayToken,
          'railwayWorkspaceId': workspaceId,
        }),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_s.connSuccessDeploy),
            backgroundColor: AppColors.success,
          ),
        );

        context.pushReplacement(
          '/bot-management/${result.id}',
          extra: result,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_s.authError}: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.card,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accent, width: 2),
      ),
      prefixIcon: Icon(icon, color: AppColors.textSecondary),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = ref.watch(stringsProvider);
    _s = s;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_currentStep == 0 ? s.connStep1Title : s.connStep2Title),
        centerTitle: false,
        leading: _currentStep == 1
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  setState(() => _currentStep = 0);
                },
              )
            : null,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildTelegramStep(s),
          _buildRailwayStep(s),
        ],
      ),
    );
  }

  Widget _buildTelegramStep(AppStrings s) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.connTelegramInstrTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Text(
              s.connTelegramInstrBody,
              style: const TextStyle(
                  height: 1.6, color: AppColors.textPrimary, fontSize: 14),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            s.connTokenLabel,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _botTokenController,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
            decoration:
                _buildInputDecoration('Bot API Token', Icons.vpn_key_rounded),
            enabled: !_isLoading,
            autocorrect: false,
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _validateTelegramAndProceed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.surface,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                          color: AppColors.surface, strokeWidth: 2),
                    )
                  : Text(
                      s.connBtnContinue,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRailwayStep(AppStrings s) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.connRailwayInstrTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Text(
              s.connRailwayInstrBody,
              style: const TextStyle(
                  height: 1.6, color: AppColors.textPrimary, fontSize: 14),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            s.connRailwayTokenLabel,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _railwayTokenController,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
            decoration: _buildInputDecoration(
                'Railway Token', Icons.cloud_queue_rounded),
            enabled: !_isLoading,
            autocorrect: false,
          ),
          const SizedBox(height: 24),
          Text(
            s.connWorkspaceLabel,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _workspaceIdController,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
            decoration:
                _buildInputDecoration('Workspace ID', Icons.grid_view_rounded),
            enabled: !_isLoading,
            autocorrect: false,
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _connect,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.surface,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                          color: AppColors.surface, strokeWidth: 2),
                    )
                  : Text(
                      s.connBtnDeploy,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
