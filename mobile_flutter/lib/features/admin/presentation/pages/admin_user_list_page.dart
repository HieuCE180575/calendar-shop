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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style:
            TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  Widget _buildRoleChip(String role) {
    final isAdmin = role == 'Admin';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isAdmin
            ? Colors.purple.shade50
            : const Color(0xFF0056C6).withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        role,
        style: TextStyle(
          color: isAdmin ? Colors.purple.shade700 : const Color(0xFF0056C6),
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(adminUsersProvider(_filter));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Quản lý người dùng',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black87, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Filter & Search Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Search field (Pill design matching home page)
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm theo tên, email, số điện thoại...',
                    hintStyle:
                        TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    prefixIcon:
                        const Icon(Icons.search, color: Color(0xFF0056C6)),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        value: _role,
                        isDense: true,
                        decoration: InputDecoration(
                          labelText: 'Quyền',
                          labelStyle: const TextStyle(fontSize: 13),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: null, child: Text('Tất cả quyền')),
                          DropdownMenuItem(
                              value: 'Customer', child: Text('Customer')),
                          DropdownMenuItem(
                              value: 'Admin', child: Text('Admin')),
                        ],
                        onChanged: (value) => setState(() => _role = value),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        value: _status,
                        isDense: true,
                        decoration: InputDecoration(
                          labelText: 'Trạng thái',
                          labelStyle: const TextStyle(fontSize: 13),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: null, child: Text('Tất cả trạng thái')),
                          DropdownMenuItem(
                              value: 'Active', child: Text('Active')),
                          DropdownMenuItem(
                              value: 'Pending', child: Text('Pending')),
                          DropdownMenuItem(
                              value: 'Locked', child: Text('Locked')),
                        ],
                        onChanged: (value) => setState(() => _status = value),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // User list section
          Expanded(
            child: usersAsync.when(
              loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF0056C6))),
              error: (err, __) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Lỗi: $err',
                      style: const TextStyle(color: Colors.red)),
                ),
              ),
              data: (users) {
                if (users.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_search_outlined,
                            size: 56, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'Không tìm thấy người dùng phù hợp.',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 15),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  color: const Color(0xFF0056C6),
                  onRefresh: () async =>
                      ref.invalidate(adminUsersProvider(_filter)),
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          leading: CircleAvatar(
                            radius: 22,
                            backgroundColor:
                                const Color(0xFF0056C6).withOpacity(0.1),
                            backgroundImage: user.avatarUrl != null &&
                                    user.avatarUrl!.isNotEmpty
                                ? NetworkImage(user.avatarUrl!)
                                : null,
                            child: user.avatarUrl == null ||
                                    user.avatarUrl!.isEmpty
                                ? Text(
                                    user.fullName.isNotEmpty
                                        ? user.fullName[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      color: Color(0xFF0056C6),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  user.fullName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              if (user.isEmailConfirmed)
                                Tooltip(
                                  message: 'Đã xác nhận email',
                                  child: Icon(Icons.verified,
                                      size: 16, color: Colors.blue.shade600),
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                user.email ??
                                    user.phone ??
                                    'Chưa có thông tin liên hệ',
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 13),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  _buildRoleChip(user.role),
                                  const SizedBox(width: 6),
                                  _buildStatusChip(user.status),
                                ],
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right,
                              color: Colors.grey),
                          onTap: () =>
                              context.push('/admin/users/${user.userId}'),
                        ),
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
