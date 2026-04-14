import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _users = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final users = await _apiService.getUsers();
      if (mounted) setState(() => _users = users);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        title: const Text(
          'Danh sách người dùng (API)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Đăng xuất',
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          // User info card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF9C95FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  child: Text(
                    (widget.user['username'] ?? 'U')[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Xin chào!',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    Text(
                      widget.user['username'] ?? 'User',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.user['email'] != null)
                      Text(
                        widget.user['email'],
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Section title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dữ liệu từ MockAPI',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Color(0xFF6C63FF)),
                  onPressed: _fetchUsers,
                  tooltip: 'Tải lại',
                ),
              ],
            ),
          ),

          // User list
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
                  )
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red, size: 48),
                            const SizedBox(height: 12),
                            Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _fetchUsers,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Thử lại'),
                            ),
                          ],
                        ),
                      )
                    : _users.isEmpty
                        ? const Center(
                            child: Text(
                              'Không có dữ liệu',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            itemCount: _users.length,
                            itemBuilder: (context, index) {
                              final u = _users[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: const Color(0xFF6C63FF).withValues(alpha: 0.15),
                                    child: Text(
                                      (u['username'] ?? 'U')[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: Color(0xFF6C63FF),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    u['email'] ?? 'Unknown',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '#${u['id'] ?? index + 1}',
                                      style: const TextStyle(
                                        color: Color(0xFF6C63FF),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
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
