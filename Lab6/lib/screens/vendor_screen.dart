import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../singleton/auth_singleton.dart';
import '../widgets/shared_appbar.dart';
import 'login_screen.dart';

class VendorScreen extends StatefulWidget {
  const VendorScreen({super.key});

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
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
        title: 'Kênh Người Bán',
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
                  // Hero banner - light blue theme for vendor
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 44),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF00131F), Color(0xFF001C2E), Color(0xFF131820)],
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 94,
                          height: 94,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF38BDF8).withOpacity(0.5),
                                blurRadius: 28,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.storefront_rounded,
                              size: 48, color: Colors.black87),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          _user?.fullName ?? 'Vendor',
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
                            color: const Color(0xFF38BDF8).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xFF38BDF8).withOpacity(0.5)),
                          ),
                          child: const Text(
                            'VENDOR',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF38BDF8),
                              letterSpacing: 1.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats row
                        Row(
                          children: [
                            _StatCard(
                              label: 'Sản phẩm',
                              value: '0',
                              icon: Icons.inventory_2_rounded,
                              color: const Color(0xFF38BDF8),
                            ),
                            const SizedBox(width: 14),
                            _StatCard(
                              label: 'Đơn hàng',
                              value: '0',
                              icon: Icons.receipt_long_rounded,
                              color: const Color(0xFF34D399),
                            ),
                            const SizedBox(width: 14),
                            _StatCard(
                              label: 'Doanh thu',
                              value: '0đ',
                              icon: Icons.trending_up_rounded,
                              color: const Color(0xFFF59E0B),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 18,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Quản lý cửa hàng',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF38BDF8),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        _ActionTile(
                          icon: Icons.add_business_rounded,
                          label: 'Quản lý sản phẩm',
                          subtitle: 'Thêm, sửa, xóa sản phẩm',
                          color: const Color(0xFF38BDF8),
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        _ActionTile(
                          icon: Icons.bar_chart_rounded,
                          label: 'Thống kê bán hàng',
                          subtitle: 'Xem báo cáo doanh thu',
                          color: const Color(0xFF34D399),
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        _ActionTile(
                          icon: Icons.settings_rounded,
                          label: 'Cài đặt cửa hàng',
                          subtitle: 'Thông tin và cài đặt',
                          color: const Color(0xFFF59E0B),
                          onTap: () {},
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

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2030),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2C3A50)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF7A8899))),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  const _ActionTile(
      {required this.icon,
      required this.label,
      required this.subtitle,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white)),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF7A8899))),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: Color(0xFF2C3A50), size: 22),
          ],
        ),
      ),
    );
  }
}
