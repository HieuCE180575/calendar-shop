import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class VerifyResetCodePage extends ConsumerStatefulWidget {
  final String? login;

  const VerifyResetCodePage({super.key, this.login});

  @override
  ConsumerState<VerifyResetCodePage> createState() => _VerifyResetCodePageState();
}

class _VerifyResetCodePageState extends ConsumerState<VerifyResetCodePage> {
  final _codeController = TextEditingController();

  static const Color _primaryColor = Color(0xFF0056C6);
  static const Color _backgroundColor = Colors.white;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      labelText: 'Mã OTP 6 chữ số',
      hintText: 'Ví dụ: 123456',
      labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 14),
      prefixIcon: const Icon(Icons.pin_outlined, color: _primaryColor),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primaryColor, width: 1.8),
      ),
    );
  }

  void _onVerify() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập mã OTP 6 chữ số.')),
      );
      return;
    }

    final success = await ref.read(authNotifierProvider.notifier).verifyResetCode(code);
    if (success && mounted) {
      context.push('/reset-password?token=${Uri.encodeComponent(code)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mark_email_read_outlined,
                        size: 48,
                        color: _primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Xác thực mã OTP',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.login != null && widget.login!.isNotEmpty
                          ? 'Mã OTP 6 số đã được gửi tới ${widget.login}. Vui lòng nhập mã để tiếp tục.'
                          : 'Vui lòng kiểm tra Email và nhập mã OTP 6 số được gửi về.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 8),
                textAlign: TextAlign.center,
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 20),
              if (state.error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          state.error!,
                          style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              AppButton(
                text: 'Xác nhận mã OTP',
                isLoading: state.isLoading,
                onPressed: _onVerify,
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: widget.login != null && widget.login!.isNotEmpty
                      ? () => ref.read(authNotifierProvider.notifier).forgotPassword(widget.login!)
                      : null,
                  icon: const Icon(Icons.refresh_outlined, size: 18),
                  label: const Text('Gửi lại mã OTP'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
