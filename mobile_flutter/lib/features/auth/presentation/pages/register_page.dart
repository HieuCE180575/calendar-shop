import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (previous, next) {
      if (next.user != null) context.go('/products');
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _fullNameController, decoration: const InputDecoration(labelText: 'Họ tên', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Số điện thoại', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Mật khẩu', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          if (state.error != null) Text(state.error!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 12),
          AppButton(
            text: 'Tạo tài khoản',
            isLoading: state.isLoading,
            onPressed: () {
              ref.read(authNotifierProvider.notifier).register(
                    _fullNameController.text.trim(),
                    _emailController.text.trim(),
                    _phoneController.text.trim(),
                    _passwordController.text.trim(),
                  );
            },
          ),
        ],
      ),
    );
  }
}
