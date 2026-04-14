import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Style dùng chung cho TextField
  InputDecoration _fieldDecoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: false,
      );

  void _onSignUp() {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: const Text('Đăng ký thành công'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context); // Back về Login
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Registration',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Person icon with + badge
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Icon(
                        Icons.person,
                        size: 72,
                        color: Colors.blue.shade400,
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade400,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // Username field
                TextFormField(
                  controller: _usernameController,
                  style: const TextStyle(fontSize: 14),
                  decoration: _fieldDecoration('Username'),
                  validator: (v) => v == null || v.isEmpty ? 'Nhập tên đăng nhập' : null,
                ),

                const SizedBox(height: 12),

                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 14),
                  decoration: _fieldDecoration('Email'),
                  validator: (v) => v == null || v.isEmpty ? 'Nhập email' : null,
                ),

                const SizedBox(height: 12),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(fontSize: 14),
                  decoration: _fieldDecoration('Password'),
                  validator: (v) => v == null || v.isEmpty ? 'Nhập mật khẩu' : null,
                ),

                const SizedBox(height: 20),

                // Sign up button (text, centered)
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF4EDFA),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: _onSignUp,
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: Color(0xFF7B5EA7),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // Back button (outlined)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      foregroundColor: Colors.black87,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back', style: TextStyle(fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
