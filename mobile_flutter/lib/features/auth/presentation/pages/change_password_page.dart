import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Đổi mật khẩu')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _oldPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'Mật khẩu cũ', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _newPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'Mật khẩu mới', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _confirmPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'Nhập lại mật khẩu mới', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          if (state.error != null) Text(state.error!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 12),
          AppButton(
            text: 'Đổi mật khẩu',
            isLoading: state.isLoading,
            onPressed: () async {
              if (_newPasswordController.text.trim() != _confirmPasswordController.text.trim()) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mật khẩu nhập lại không khớp.')));
                return;
              }
              final ok = await ref.read(authNotifierProvider.notifier).changePassword(
                    _oldPasswordController.text.trim(),
                    _newPasswordController.text.trim(),
                  );
              if (ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đổi mật khẩu thành công. Vui lòng đăng nhập lại.')));
                context.go('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
