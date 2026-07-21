import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/admin_user_provider.dart';

class AdminUserDetailPage extends ConsumerWidget {
  final int userId;

  const AdminUserDetailPage({super.key, required this.userId});

  Widget _buildStatusChip(String status) {
    Color color;
    Color bg;
    switch (status) {
      case 'Active':
        color = Colors.green.shade700;
        bg = Colors.green.shade50;
        break;
      case 'Pending':
        color = Colors.orange.shade800;
        bg = Colors.orange.shade50;
        break;
      case 'Locked':
        color = Colors.red.shade700;
        bg = Colors.red.shade50;
        break;
      default:
        color = Colors.grey.shade700;
        bg = Colors.grey.shade100;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildRoleChip(String role) {
    final isAdmin = role == 'Admin';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isAdmin ? Colors.purple.shade50 : const Color(0xFF0056C6).withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        role,
        style: TextStyle(
          color: isAdmin ? Colors.purple.shade700 : const Color(0xFF0056C6),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(adminUserDetailProvider(userId));
    final actionState = ref.watch(adminUserActionProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Chi tiết người dùng',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF0056C6))),
        error: (err, __) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Lỗi: $err', style: const TextStyle(color: Colors.red)),
          ),
        ),
        data: (user) {
          final nextStatus = user.status == 'Locked' ? 'Active' : 'Locked';
          final nextRole = user.role == 'Admin' ? 'Customer' : 'Admin';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // User Overview Banner
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
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: const Color(0xFF0056C6).withOpacity(0.1),
                      backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                          ? NetworkImage(user.avatarUrl!)
                          : null,
                      child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                          ? Text(
                              user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF0056C6)),
                            )
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.fullName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'ID Người dùng: #${user.userId}',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildRoleChip(user.role),
                        const SizedBox(width: 8),
                        _buildStatusChip(user.status),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Contact & Info Card
              _SectionContainer(
                title: 'Thông tin cá nhân & Liên hệ',
                icon: Icons.person_outline,
                children: [
                  _InfoItem(label: 'Họ tên', value: user.fullName, icon: Icons.badge_outlined),
                  _InfoItem(label: 'Email', value: user.email ?? 'Chưa cập nhật', icon: Icons.email_outlined),
                  _InfoItem(label: 'Số điện thoại', value: user.phone ?? 'Chưa cập nhật', icon: Icons.phone_android_outlined),
                  _InfoItem(label: 'Giới tính', value: user.gender ?? 'Chưa cập nhật', icon: Icons.people_outline),
                  _InfoItem(label: 'Ngày sinh', value: user.dateOfBirth?.toLocal().toString().split(' ').first ?? 'Chưa cập nhật', icon: Icons.cake_outlined),
                ],
              ),
              const SizedBox(height: 16),

              // System Info Card
              _SectionContainer(
                title: 'Trạng thái hệ thống',
                icon: Icons.info_outline,
                children: [
                  _InfoItem(
                    label: 'Xác thực Email',
                    value: user.isEmailConfirmed ? 'Đã xác nhận' : 'Chưa xác nhận',
                    icon: user.isEmailConfirmed ? Icons.verified_user : Icons.gpp_maybe_outlined,
                    valueColor: user.isEmailConfirmed ? Colors.green.shade700 : Colors.orange.shade800,
                  ),
                  _InfoItem(
                    label: 'Thời gian xác nhận Email',
                    value: user.emailConfirmedAt?.toLocal().toString().split('.').first ?? 'Chưa có dữ liệu',
                    icon: Icons.access_time,
                  ),
                  _InfoItem(
                    label: 'Ngày khởi tạo tài khoản',
                    value: user.createdAt?.toLocal().toString().split('.').first ?? 'Chưa có dữ liệu',
                    icon: Icons.calendar_today_outlined,
                  ),
                  _InfoItem(
                    label: 'Cập nhật lần cuối',
                    value: user.updatedAt?.toLocal().toString().split('.').first ?? 'Chưa có dữ liệu',
                    icon: Icons.update,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Action Buttons
              if (actionState.error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(actionState.error!, style: TextStyle(color: Colors.red.shade700, fontSize: 13)),
                ),

              Container(
                padding: const EdgeInsets.all(16),
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
                      'Thao tác quản trị',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0056C6)),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: nextStatus == 'Locked' ? Colors.red.shade600 : Colors.green.shade600,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: actionState.isLoading
                            ? null
                            : () async {
                                final ok = await ref.read(adminUserActionProvider.notifier).updateStatus(user.userId, nextStatus);
                                if (ok && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Đã cập nhật trạng thái tài khoản thành $nextStatus.'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                        icon: actionState.isLoading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Icon(nextStatus == 'Locked' ? Icons.lock_outline : Icons.lock_open_outlined),
                        label: Text(
                          nextStatus == 'Locked' ? 'Khóa tài khoản' : 'Mở khóa tài khoản',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          side: BorderSide(color: Colors.purple.shade600),
                        ),
                        onPressed: actionState.isLoading
                            ? null
                            : () async {
                                final ok = await ref.read(adminUserActionProvider.notifier).updateRole(user.userId, nextRole);
                                if (ok && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Đã chuyển quyền tài khoản thành $nextRole.'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                        icon: const Icon(Icons.admin_panel_settings_outlined, color: Colors.purple),
                        label: Text(
                          'Chuyển quyền thành $nextRole',
                          style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}

class _SectionContainer extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionContainer({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF0056C6)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _InfoItem({required this.label, required this.value, required this.icon, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade500),
          const SizedBox(width: 10),
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: valueColor ?? Colors.black87),
          ),
        ],
      ),
    );
  }
}
