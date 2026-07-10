import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  final String? initialToken;

  const ResetPasswordPage({super.key, this.initialToken});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tokenController.text = widget.initialToken ?? '';
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (previous, next) {
      if (next.message != null && next.error == null && previous?.isLoading == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message!)));
        context.go('/login');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Đặt lại mật khẩu')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _tokenController,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'Reset token từ email', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Mật khẩu mới', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Nhập lại mật khẩu mới', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          if (state.error != null) Text(state.error!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 12),
          AppButton(
            text: 'Đặt lại mật khẩu',
            isLoading: state.isLoading,
            onPressed: () async {
              if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mật khẩu nhập lại không khớp.')));
                return;
              }
              await ref.read(authNotifierProvider.notifier).resetPassword(
                    _tokenController.text.trim(),
                    _passwordController.text.trim(),
                  );
            },
          ),
        ],
      ),
    );
  }
}
