import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/admin_user_provider.dart';

class AdminUserDetailPage extends ConsumerWidget {
  final int userId;

  const AdminUserDetailPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(adminUserDetailProvider(userId));
    final actionState = ref.watch(adminUserActionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết người dùng')),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, __) => Center(child: Text('Lỗi: $err', style: const TextStyle(color: Colors.red))),
        data: (user) {
          final nextStatus = user.status == 'Locked' ? 'Active' : 'Locked';
          final nextRole = user.role == 'Admin' ? 'Customer' : 'Admin';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 42,
                  backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty ? NetworkImage(user.avatarUrl!) : null,
                  child: user.avatarUrl == null || user.avatarUrl!.isEmpty ? const Icon(Icons.person, size: 42) : null,
                ),
              ),
              const SizedBox(height: 16),
              _InfoTile(label: 'ID', value: user.userId.toString()),
              _InfoTile(label: 'Họ tên', value: user.fullName),
              _InfoTile(label: 'Email', value: user.email ?? 'Chưa có'),
              _InfoTile(label: 'Số điện thoại', value: user.phone ?? 'Chưa có'),
              _InfoTile(label: 'Quyền', value: user.role),
              _InfoTile(label: 'Trạng thái', value: user.status),
              _InfoTile(label: 'Email đã xác nhận', value: user.isEmailConfirmed ? 'Đã xác nhận' : 'Chưa xác nhận'),
              _InfoTile(label: 'Ngày xác nhận email', value: user.emailConfirmedAt?.toLocal().toString() ?? 'Chưa có'),
              _InfoTile(label: 'Giới tính', value: user.gender ?? 'Chưa có'),
              _InfoTile(label: 'Ngày sinh', value: user.dateOfBirth?.toLocal().toString().split(' ').first ?? 'Chưa có'),
              _InfoTile(label: 'Ngày tạo', value: user.createdAt?.toLocal().toString() ?? 'Chưa có'),
              _InfoTile(label: 'Cập nhật', value: user.updatedAt?.toLocal().toString() ?? 'Chưa có'),
              const SizedBox(height: 16),
              if (actionState.error != null) Text(actionState.error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: actionState.isLoading
                    ? null
                    : () async {
                        final ok = await ref.read(adminUserActionProvider.notifier).updateStatus(user.userId, nextStatus);
                        if (ok && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã đổi trạng thái sang $nextStatus.')));
                        }
                      },
                icon: Icon(nextStatus == 'Locked' ? Icons.lock : Icons.lock_open),
                label: Text(nextStatus == 'Locked' ? 'Khóa tài khoản' : 'Mở khóa tài khoản'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: actionState.isLoading
                    ? null
                    : () async {
                        final ok = await ref.read(adminUserActionProvider.notifier).updateRole(user.userId, nextRole);
                        if (ok && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã phân quyền $nextRole.')));
                        }
                      },
                icon: const Icon(Icons.admin_panel_settings),
                label: Text('Phân quyền thành $nextRole'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(value),
    );
  }
}
