import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../singleton/auth_singleton.dart';
import '../widgets/shared_appbar.dart';
import 'login_screen.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final result = await ApiService.getCurrentUser();
    if (!mounted) return;
    if (result['success']) {
      setState(() {
        _user = result['data'] as UserModel;
        _isLoading = false;
      });
    } else {
      _logout();
    }
  }

  void _logout() {
    AuthSingleton().clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        title: 'Trang Cá Nhân',
        actions: [
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
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Hero banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 44),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1A1400), Color(0xFF201A00), Color(0xFF131820)],
                      ),
                    ),
                    child: Column(
                      children: [
                        // Avatar with amber glow
                        Container(
                          width: 94,
                          height: 94,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF59E0B), Color(0xFFEF6C00)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF59E0B).withOpacity(0.5),
                                blurRadius: 28,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.person_rounded,
                              size: 48, color: Colors.black87),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          _user?.fullName ?? 'Người dùng',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _user?.email ?? '',
                          style: const TextStyle(
                              fontSize: 13, color: Color(0xFF7A8899)),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xFFF59E0B).withOpacity(0.5)),
                          ),
                          child: const Text(
                            'CUSTOMER',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFF59E0B),
                              letterSpacing: 1.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Info cards
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 18,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFF59E0B), Color(0xFFEF6C00)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Thông tin tài khoản',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF59E0B),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _InfoCard(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: _user?.email ?? '',
                          color: const Color(0xFF38BDF8),
                        ),
                        const SizedBox(height: 12),
                        _InfoCard(
                          icon: Icons.badge_outlined,
                          label: 'User ID',
                          value: _user?.id ?? '',
                          color: Colors.purpleAccent,
                        ),
                        const SizedBox(height: 12),
                        _InfoCard(
                          icon: Icons.calendar_today_rounded,
                          label: 'Ngày tham gia',
                          value: _user?.createdAt?.split('T').first ?? '',
                          color: const Color(0xFF34D399),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _InfoCard(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2030),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2C3A50)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF7A8899))),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
