import 'package:flutter/foundation.dart'; // Для kDebugMode и debugPrint
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/supabase/supabase_client.dart';
import '../../../../core/localization/language_provider.dart';
import '../../../../core/localization/app_strings.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoginMode = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  late AppStrings _s;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.accent),
    );
  }

  Future<void> _handleAuth() async {
    if (kDebugMode) debugPrint('=== DEBUG AUTH START ===');

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (kDebugMode) {
      debugPrint('Email: $email | Mode: ${_isLoginMode ? "LOGIN" : "SIGNUP"}');
    }

    if (email.isEmpty || password.isEmpty) {
      _showError(_s.authFieldsRequired);
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (kDebugMode) debugPrint('DEBUG: Calling Supabase auth...');
      final supabase = ref.read(supabaseClientProvider);

      if (_isLoginMode) {
        if (kDebugMode) debugPrint('DEBUG: Attempting signInWithPassword...');
        await supabase.auth
            .signInWithPassword(email: email, password: password);

        if (kDebugMode) debugPrint('DEBUG: Sign in SUCCESS');

        if (mounted) {
          if (kDebugMode) debugPrint('→ Manual redirect to /');
          context.go('/');
        }
      } else {
        if (kDebugMode) debugPrint('DEBUG: Attempting signUp...');
        await supabase.auth.signUp(email: email, password: password);
        if (mounted) {
          _showSuccess(_s.authCheckEmail);
        }
      }
    } on AuthException catch (e) {
      if (kDebugMode) debugPrint('DEBUG AuthException: ${e.message}');
      _showError(e.message);
    } catch (e) {
      if (kDebugMode) debugPrint('DEBUG General error: $e');
      _showError('${_s.authError}: $e');
    } finally {
      if (kDebugMode) debugPrint('=== DEBUG AUTH END ===');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    _s = s;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Dokki',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                  fontFamily: 'Inter',
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isLoginMode ? s.authLogin : s.authRegistration,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 48),
              _buildLabel('Email'),
              const SizedBox(height: 8),
              // ФИКС: Переход к следующему полю по Enter
              _buildTextField(
                _emailController,
                hint: 'example@mail.com',
                prefixIcon: const Icon(Icons.email_outlined,
                    color: AppColors.textSecondary),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              _buildLabel(s.authPassword),
              const SizedBox(height: 8),
              // ФИКС: Запуск авторизации по Enter
              _buildTextField(
                _passwordController,
                obscureText: _obscurePassword,
                hint: '••••••••',
                textInputAction: TextInputAction.done,
                onSubmitted: _handleAuth,
                prefixIcon: const Icon(Icons.lock_outline,
                    color: AppColors.textSecondary),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              if (_isLoginMode)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(s.authForgotPassword,
                        style: const TextStyle(
                            color: AppColors.accent, fontFamily: 'Inter')),
                  ),
                ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleAuth,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                              color: AppColors.surface, strokeWidth: 2))
                      : Text(
                          _isLoginMode
                              ? s.authLogin.toUpperCase()
                              : s.authRegistration.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.surface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ),
              if (_isLoginMode) ...[
                const SizedBox(height: 24),
                Row(children: [
                  const Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(s.authOr,
                        style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontFamily: 'Inter')),
                  ),
                  const Expanded(child: Divider(color: AppColors.border)),
                ]),
                const SizedBox(height: 24),
                _buildSocialButton(
                  icon: Image.network('https://www.google.com/favicon.ico',
                      height: 20),
                  label: s.authGoogle,
                  onPressed: () {},
                ),
                const SizedBox(height: 12),
                _buildSocialButton(
                  icon: const Icon(Icons.apple, color: AppColors.textPrimary),
                  label: 'Sign in with Apple',
                  onPressed: () {},
                ),
              ],
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => setState(() => _isLoginMode = !_isLoginMode),
                child: Text(
                  _isLoginMode ? s.authNoAccount : s.authHasAccount,
                  style: const TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
            color: AppColors.textSecondary, fontSize: 14, fontFamily: 'Inter'),
      ),
    );
  }

  Widget _buildSocialButton(
      {required Widget icon,
      required String label,
      required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        icon: icon,
        label: Text(label,
            style: const TextStyle(
                color: AppColors.textPrimary, fontFamily: 'Inter')),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.border),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    bool obscureText = false,
    String? hint,
    Widget? suffixIcon,
    Widget? prefixIcon,
    TextInputAction? textInputAction,
    VoidCallback? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted != null ? (_) => onSubmitted() : null,
      style: const TextStyle(color: AppColors.textPrimary, fontFamily: 'Inter'),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5)),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
      ),
    );
  }
}
