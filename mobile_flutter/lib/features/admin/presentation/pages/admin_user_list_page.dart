import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/admin_user_provider.dart';

class AdminUserListPage extends ConsumerStatefulWidget {
  const AdminUserListPage({super.key});

  @override
  ConsumerState<AdminUserListPage> createState() => _AdminUserListPageState();
}

class _AdminUserListPageState extends ConsumerState<AdminUserListPage> {
  final _searchController = TextEditingController();
  String? _role;
  String? _status;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  AdminUserFilter get _filter => AdminUserFilter(
        search: _searchController.text.trim(),
        role: _role,
        status: _status,
      );

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(adminUsersProvider(_filter));

    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý người dùng')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Tìm theo tên, email, số điện thoại',
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        initialValue: _role,
                        decoration: const InputDecoration(labelText: 'Quyền', border: OutlineInputBorder()),
                        items: const [
                          DropdownMenuItem(value: null, child: Text('Tất cả')),
                          DropdownMenuItem(value: 'Customer', child: Text('Customer')),
                          DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                        ],
                        onChanged: (value) => setState(() => _role = value),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        initialValue: _status,
                        decoration: const InputDecoration(labelText: 'Trạng thái', border: OutlineInputBorder()),
                        items: const [
                          DropdownMenuItem(value: null, child: Text('Tất cả')),
                          DropdownMenuItem(value: 'Active', child: Text('Active')),
                          DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                          DropdownMenuItem(value: 'Locked', child: Text('Locked')),
                        ],
                        onChanged: (value) => setState(() => _status = value),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: usersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, __) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Lỗi: $err', style: const TextStyle(color: Colors.red)),
                ),
              ),
              data: (users) {
                if (users.isEmpty) {
                  return const Center(child: Text('Không tìm thấy người dùng.'));
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(adminUsersProvider(_filter)),
                  child: ListView.separated(
                    itemCount: users.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty ? NetworkImage(user.avatarUrl!) : null,
                          child: user.avatarUrl == null || user.avatarUrl!.isEmpty ? Text(user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?') : null,
                        ),
                        title: Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${user.email ?? user.phone ?? 'Chưa có liên hệ'} • ${user.role} • ${user.status} • ${user.isEmailConfirmed ? 'Email OK' : 'Chưa xác nhận'}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/admin/users/${user.userId}'),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
