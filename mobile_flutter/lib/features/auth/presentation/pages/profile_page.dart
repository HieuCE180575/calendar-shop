import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _avatarUrlController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _avatarUrlController.dispose();
    super.dispose();
  }

  void _syncForm(AuthState state) {
    final user = state.user;
    if (_initialized || user == null) return;
    _fullNameController.text = user.fullName;
    _emailController.text = user.email ?? '';
    _phoneController.text = user.phone ?? '';
    _avatarUrlController.text = user.avatarUrl ?? '';
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);
    _syncForm(state);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ cá nhân'),
        actions: [
          IconButton(
            onPressed: () => context.push('/change-password'),
            icon: const Icon(Icons.lock_reset),
            tooltip: 'Đổi mật khẩu',
          ),
        ],
      ),
      body: state.user == null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Chưa có thông tin người dùng trong phiên hiện tại.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => ref.read(authNotifierProvider.notifier).loadMe(),
                    child: const Text('Tải hồ sơ'),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 42,
                    backgroundImage: _avatarUrlController.text.trim().isNotEmpty ? NetworkImage(_avatarUrlController.text.trim()) : null,
                    child: _avatarUrlController.text.trim().isEmpty ? const Icon(Icons.person, size: 42) : null,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(controller: _fullNameController, decoration: const InputDecoration(labelText: 'Họ tên', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Số điện thoại', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: _avatarUrlController, decoration: const InputDecoration(labelText: 'Avatar URL', border: OutlineInputBorder())),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Vai trò'),
                  subtitle: Text(state.user!.role),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Trạng thái'),
                  subtitle: Text(state.user!.status),
                ),
                if (state.error != null) Text(state.error!, style: const TextStyle(color: Colors.red)),
                if (state.message != null) Text(state.message!, style: const TextStyle(color: Colors.green)),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Lưu thông tin',
                  isLoading: state.isLoading,
                  onPressed: () async {
                    final ok = await ref.read(authNotifierProvider.notifier).updateProfile(
                          fullName: _fullNameController.text.trim(),
                          email: _emailController.text.trim(),
                          phone: _phoneController.text.trim(),
                          avatarUrl: _avatarUrlController.text.trim(),
                        );
                    if (ok && context.mounted) {
                      setState(() => _initialized = false);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã cập nhật hồ sơ.')));
                    }
                  },
                ),
              ],
            ),
    );
  }
}
