import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _loginController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);
    final result = state.forgotPasswordResult;

    return Scaffold(
      appBar: AppBar(title: const Text('Quên mật khẩu')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Nhập email hoặc số điện thoại. Hệ thống sẽ gửi reset token về email đã xác nhận của tài khoản.'),
          const SizedBox(height: 16),
          TextField(
            controller: _loginController,
            decoration: const InputDecoration(labelText: 'Email hoặc số điện thoại', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          if (state.error != null) Text(state.error!, style: const TextStyle(color: Colors.red)),
          if (state.message != null) ...[
            Text(state.message!, style: const TextStyle(color: Colors.green)),
            const SizedBox(height: 8),
          ],
          if (result?.expiredAt != null) ...[
            Text('Token hết hạn: ${result!.expiredAt!.toLocal()}'),
            const SizedBox(height: 8),
          ],
          AppButton(
            text: 'Gửi reset token về email',
            isLoading: state.isLoading,
            onPressed: () => ref.read(authNotifierProvider.notifier).forgotPassword(_loginController.text.trim()),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.push('/reset-password'),
            child: const Text('Tôi đã có token'),
          ),
        ],
      ),
    );
  }
}
