import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../singleton/auth_singleton.dart';
import '../widgets/shared_appbar.dart';
import 'login_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<UserModel> _users = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    final result = await ApiService.getAllUsers();
    if (!mounted) return;
    if (result['success']) {
      setState(() {
        _users = result['data'] as List<UserModel>;
        _isLoading = false;
      });
    } else {
      if (result['unauthorized'] == true) _logout();
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteUser(UserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF1A2030),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_forever_rounded,
                    color: Colors.redAccent, size: 28),
              ),
              const SizedBox(height: 16),
              const Text('Xác nhận xóa',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 8),
              Text(
                'Bạn có chắc muốn xóa\n${user.email}?',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF7A8899), fontSize: 13),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF2C3A50)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Hủy',
                          style: TextStyle(color: Color(0xFF7A8899))),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Xóa',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed == true) {
      await ApiService.deleteUser(user.id);
      _loadUsers();
    }
  }

  void _logout() {
    AuthSingleton().clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
  }

  Color _roleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin': return Colors.purpleAccent;
      case 'vendor': return Colors.lightBlueAccent;
      default: return const Color(0xFFF59E0B);
    }
  }

  IconData _roleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'admin': return Icons.security_rounded;
      case 'vendor': return Icons.store_rounded;
      default: return Icons.person_rounded;
    }
  }

  List<UserModel> get _filteredUsers => _searchQuery.isEmpty
      ? _users
      : _users
          .where((u) =>
              u.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (u.fullName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false))
          .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        title: 'Quản lý người dùng',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFFF59E0B)),
            onPressed: _loadUsers,
            tooltip: 'Tải lại',
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFFF59E0B)),
            onPressed: _logout,
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFF59E0B)))
          : Column(
              children: [
                // Admin info + stats bar
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF131820),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.purpleAccent, Color(0xFF6A1F9A)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.4),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.admin_panel_settings_rounded,
                            color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Quản trị viên',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white)),
                            Text(AuthSingleton().email ?? '',
                                style: const TextStyle(
                                    color: Color(0xFF7A8899), fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color(0xFFF59E0B).withOpacity(0.4)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${_filteredUsers.length}',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFF59E0B)),
                            ),
                            const Text('Users',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF7A8899))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Search bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm người dùng...',
                      hintStyle: const TextStyle(color: Color(0xFF4A5A6A)),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: Color(0xFFF59E0B), size: 20),
                      filled: true,
                      fillColor: const Color(0xFF1A2030),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF2C3A50)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF2C3A50)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFFF59E0B), width: 1.5),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),

                // User list
                Expanded(
                  child: _filteredUsers.isEmpty
                      ? const Center(
                          child: Text('Không tìm thấy người dùng',
                              style: TextStyle(color: Color(0xFF7A8899))))
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          itemCount: _filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = _filteredUsers[index];
                            final isMe =
                                user.email == AuthSingleton().email;
                            final rColor = _roleColor(user.role);
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A2030),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isMe
                                      ? const Color(0xFFF59E0B).withOpacity(0.4)
                                      : const Color(0xFF2C3A50),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: rColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(_roleIcon(user.role),
                                        color: rColor, size: 22),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                user.email,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.white),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (isMe)
                                              Container(
                                                margin: const EdgeInsets.only(left: 6),
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFF59E0B)
                                                      .withOpacity(0.15),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: const Text('You',
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color(0xFFF59E0B))),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Text(user.fullName ?? '',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF7A8899))),
                                        const SizedBox(height: 5),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: rColor.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(user.role,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                  color: rColor)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!isMe)
                                    GestureDetector(
                                      onTap: () => _deleteUser(user),
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                            Icons.delete_outline_rounded,
                                            color: Colors.redAccent,
                                            size: 18),
                                      ),
                                    ),
                                ],
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
