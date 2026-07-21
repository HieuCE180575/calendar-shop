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

  InputDecoration _inputDecoration({
    required String label,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 14),
      prefixIcon: Icon(prefixIcon, color: const Color(0xFF0056C6)),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        borderSide: const BorderSide(color: Color(0xFF0056C6), width: 1.8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);
    _syncForm(state);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Hồ sơ cá nhân',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            onPressed: () => context.push('/change-password'),
            icon: const Icon(Icons.lock_reset, color: Color(0xFF0056C6)),
            tooltip: 'Đổi mật khẩu',
          ),
        ],
      ),
      body: state.user == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.account_circle_outlined, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    const Text(
                      'Chưa có thông tin phiên làm việc.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0056C6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () => ref.read(authNotifierProvider.notifier).loadMe(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tải lại thông tin'),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                // Header Profile Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 46,
                            backgroundColor: const Color(0xFF0056C6).withOpacity(0.1),
                            backgroundImage: _avatarUrlController.text.trim().isNotEmpty
                                ? NetworkImage(_avatarUrlController.text.trim())
                                : null,
                            child: _avatarUrlController.text.trim().isEmpty
                                ? const Icon(Icons.person, size: 48, color: Color(0xFF0056C6))
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFF0056C6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit, size: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.user!.fullName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        state.user!.email ?? state.user!.phone ?? 'Chưa cập nhật liên hệ',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0056C6).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.shield_outlined, size: 14, color: Color(0xFF0056C6)),
                                const SizedBox(width: 4),
                                Text(
                                  state.user!.role,
                                  style: const TextStyle(
                                    color: Color(0xFF0056C6),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle_outline, size: 14, color: Colors.green.shade700),
                                const SizedBox(width: 4),
                                Text(
                                  state.user!.status,
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Form section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cập nhật thông tin',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0056C6),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _fullNameController,
                        decoration: _inputDecoration(
                          label: 'Họ tên',
                          prefixIcon: Icons.person_outline,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration(
                          label: 'Email',
                          prefixIcon: Icons.email_outlined,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: _inputDecoration(
                          label: 'Số điện thoại',
                          prefixIcon: Icons.phone_android_outlined,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _avatarUrlController,
                        decoration: _inputDecoration(
                          label: 'Link Avatar URL',
                          prefixIcon: Icons.image_outlined,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 16),
                      if (state.error != null)
                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(state.error!, style: TextStyle(color: Colors.red.shade700, fontSize: 13)),
                        ),
                      if (state.message != null)
                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(state.message!, style: TextStyle(color: Colors.green.shade700, fontSize: 13)),
                        ),
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đã cập nhật hồ sơ cá nhân thành công!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Quick Navigation Tiles
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF0056C6)),
                        title: const Text('Đơn hàng của tôi', style: TextStyle(fontWeight: FontWeight.w600)),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                        onTap: () => context.push('/orders'),
                      ),
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: const Icon(Icons.lock_outline, color: Color(0xFF0056C6)),
                        title: const Text('Đổi mật khẩu', style: TextStyle(fontWeight: FontWeight.w600)),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                        onTap: () => context.push('/change-password'),
                      ),
                      if (state.user!.role == 'Admin') ...[
                        const Divider(height: 1, indent: 56),
                        ListTile(
                          leading: const Icon(Icons.admin_panel_settings_outlined, color: Colors.purple),
                          title: const Text('Trang Quản trị Admin', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.purple)),
                          trailing: const Icon(Icons.chevron_right, color: Colors.purple),
                          onTap: () => context.push('/admin'),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
  }
}
