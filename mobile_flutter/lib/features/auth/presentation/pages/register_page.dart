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
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (previous, next) {
      if (previous?.isLoading == true && next.message != null && next.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message!)));
        context.go('/login');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký Customer')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _fullNameController, decoration: const InputDecoration(labelText: 'Họ tên', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Số điện thoại', border: OutlineInputBorder())),
          const SizedBox(height: 8),
          const Text('Email là bắt buộc để nhận link xác nhận tài khoản. Số điện thoại dùng để đăng nhập thêm.', style: TextStyle(fontSize: 12)),
          const SizedBox(height: 12),
          TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Mật khẩu', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _confirmPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'Nhập lại mật khẩu', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          if (state.error != null) Text(state.error!, style: const TextStyle(color: Colors.red)),
          if (state.message != null) Text(state.message!, style: const TextStyle(color: Colors.green)),
          const SizedBox(height: 12),
          AppButton(
            text: 'Tạo tài khoản',
            isLoading: state.isLoading,
            onPressed: () {
              if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mật khẩu nhập lại không khớp.')));
                return;
              }
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
