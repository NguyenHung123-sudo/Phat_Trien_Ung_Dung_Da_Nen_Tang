import 'package:flutter/material.dart';
import '../widgets/shared_button.dart';
import '../widgets/shared_text_field.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  String _selectedRole = 'Customer';
  bool _isLoading = false;

  final List<String> _roles = ['Admin', 'Customer', 'Vendor'];

  Future<void> _register() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')));
      return;
    }
    setState(() => _isLoading = true);
    final result = await ApiService.register(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      role: _selectedRole,
      fullName: _fullNameController.text.trim(),
    );
    setState(() => _isLoading = false);
    if (!mounted) return;
    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng ký thành công!')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result['message'])));
    }
  }

  Widget _buildRoleChip(String role, IconData icon, Color color) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : const Color(0xFF131820),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : const Color(0xFF2C3A50),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? color : const Color(0xFF7A8899), size: 24),
            const SizedBox(height: 6),
            Text(
              role,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : const Color(0xFF7A8899),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0C0F14), Color(0xFF131820), Color(0xFF0E1520)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A2030),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF2C3A50)),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            size: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFEF6C00)],
                      ).createShader(bounds),
                      child: const Text(
                        'Tạo tài khoản mới',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Gradient divider
              Container(
                height: 1,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFEF6C00), Colors.transparent],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon header
                      Center(
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF59E0B), Color(0xFFEF6C00)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF59E0B).withOpacity(0.4),
                                blurRadius: 22,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.person_add_rounded,
                              size: 36, color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Form card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A2030),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF2C3A50)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Thông tin cá nhân',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF59E0B))),
                            const SizedBox(height: 16),
                            SharedTextField(
                              controller: _fullNameController,
                              label: 'Họ và tên',
                              prefixIcon: Icons.person_outline_rounded,
                            ),
                            const SizedBox(height: 14),
                            SharedTextField(
                              controller: _emailController,
                              label: 'Email',
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 14),
                            SharedTextField(
                              controller: _passwordController,
                              label: 'Mật khẩu',
                              obscureText: true,
                              prefixIcon: Icons.lock_outline,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Role selector
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A2030),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF2C3A50)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Chọn vai trò',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF59E0B))),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(child: _buildRoleChip('Admin', Icons.security_rounded, Colors.purpleAccent)),
                                const SizedBox(width: 10),
                                Expanded(child: _buildRoleChip('Customer', Icons.person_rounded, const Color(0xFFF59E0B))),
                                const SizedBox(width: 10),
                                Expanded(child: _buildRoleChip('Vendor', Icons.store_rounded, Colors.lightBlueAccent)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      SharedButton(
                        label: 'TẠO TÀI KHOẢN',
                        onPressed: _register,
                        isLoading: _isLoading,
                        icon: Icons.how_to_reg_rounded,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
