import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class ConfirmEmailPage extends ConsumerStatefulWidget {
  final String? initialToken;

  const ConfirmEmailPage({super.key, this.initialToken});

  @override
  ConsumerState<ConfirmEmailPage> createState() => _ConfirmEmailPageState();
}

class _ConfirmEmailPageState extends ConsumerState<ConfirmEmailPage> {
  final _tokenController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tokenController.text = widget.initialToken ?? '';
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message!)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Xác nhận email')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Bạn có thể bấm link trong email để kích hoạt tự động, hoặc copy token trong email vào đây.'),
          const SizedBox(height: 16),
          TextField(
            controller: _tokenController,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'Email confirmation token', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          if (state.error != null) Text(state.error!, style: const TextStyle(color: Colors.red)),
          if (state.message != null) Text(state.message!, style: const TextStyle(color: Colors.green)),
          const SizedBox(height: 12),
          AppButton(
            text: 'Xác nhận email',
            isLoading: state.isLoading,
            onPressed: () => ref.read(authNotifierProvider.notifier).confirmEmail(_tokenController.text.trim()),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),
          const Text('Chưa nhận được email hoặc token hết hạn?'),
          const SizedBox(height: 12),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email đăng ký', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: state.isLoading
                ? null
                : () => ref.read(authNotifierProvider.notifier).resendEmailConfirmation(_emailController.text.trim()),
            icon: const Icon(Icons.email_outlined),
            label: const Text('Gửi lại email xác nhận'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => context.go('/login'),
            child: const Text('Quay lại đăng nhập'),
          ),
        ],
      ),
    );
  }
}
