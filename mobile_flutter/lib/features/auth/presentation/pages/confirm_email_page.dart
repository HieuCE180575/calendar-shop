import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class ConfirmEmailPage extends ConsumerStatefulWidget {
  final String? initialToken;
  final String? initialEmail;

  const ConfirmEmailPage({super.key, this.initialToken, this.initialEmail});

  @override
  ConsumerState<ConfirmEmailPage> createState() => _ConfirmEmailPageState();
}

class _ConfirmEmailPageState extends ConsumerState<ConfirmEmailPage> {
  final _tokenController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isConfirmAction = false;

  static const Color _primaryColor = Color(0xFF2563EB); // Royal Blue
  static const Color _primaryLight = Color(0xFFEFF6FF);
  static const Color _backgroundColor = Color(0xFFF8FAFC);
  static const Color _borderColor = Color(0xFFE2E8F0);
  static const Color _textPrimary = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _tokenController.text = widget.initialToken ?? '';
    _emailController.text = widget.initialEmail ?? '';
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (previous, next) {
      if (previous?.isLoading == true && next.message != null && next.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message!),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
        if (_isConfirmAction) {
          context.go('/login');
        }
      }
    });

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: _textPrimary),
          onPressed: () => context.go('/login'),
        ),
        title: const Text(
          'Xác nhận Email',
          style: TextStyle(fontWeight: FontWeight.bold, color: _textPrimary, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              // Email Hero Icon Badge
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _primaryLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFBFDBFE), width: 2),
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  size: 40,
                  color: _primaryColor,
                ),
              ),
              const SizedBox(height: 20),

              // Title & Instructions
              const Text(
                'Kích hoạt tài khoản',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Vui lòng kiểm tra email của bạn và dán mã xác nhận (token) hoặc bấm vào liên kết đã được gửi.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: _textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // Token Form Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _borderColor),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0F0F172A),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nhập mã xác nhận (Token)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _tokenController,
                      minLines: 2,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Dán chuỗi token xác nhận tại đây...',
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                        prefixIcon: const Icon(Icons.key_outlined, color: _textSecondary),
                        filled: true,
                        fillColor: _backgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: _borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: _borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: _primaryColor, width: 1.5),
                        ),
                      ),
                    ),
                    if (state.error != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        state.error!,
                        style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                    if (state.message != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        state.message!,
                        style: const TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                    const SizedBox(height: 16),
                    AppButton(
                      text: 'Xác nhận kích hoạt',
                      isLoading: state.isLoading,
                      onPressed: () {
                        final token = _tokenController.text.trim();
                        if (token.isNotEmpty) {
                          setState(() => _isConfirmAction = true);
                          ref.read(authNotifierProvider.notifier).confirmEmail(token);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Vui lòng nhập token xác nhận!')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Resend Email Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chưa nhận được email?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Nhập email đã đăng ký để hệ thống gửi lại yêu cầu xác nhận.',
                      style: TextStyle(fontSize: 12, color: _textSecondary),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Nhập email đã đăng ký...',
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                        prefixIcon: const Icon(Icons.email_outlined, color: _textSecondary),
                        filled: true,
                        fillColor: _backgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: _borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: _borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: _primaryColor, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _primaryColor,
                          side: const BorderSide(color: _primaryColor, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: state.isLoading
                            ? null
                            : () {
                                final email = _emailController.text.trim();
                                if (email.isNotEmpty) {
                                  setState(() => _isConfirmAction = false);
                                  ref.read(authNotifierProvider.notifier).resendEmailConfirmation(email);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Vui lòng nhập email!')),
                                  );
                                }
                              },
                        icon: const Icon(Icons.send_outlined, size: 18),
                        label: const Text('Gửi lại email xác nhận', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              TextButton.icon(
                onPressed: () => context.go('/login'),
                icon: const Icon(Icons.arrow_back, size: 18, color: _textSecondary),
                label: const Text(
                  'Quay lại đăng nhập',
                  style: TextStyle(color: _textSecondary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
