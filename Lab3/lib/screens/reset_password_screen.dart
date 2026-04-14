import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onResetPassword() {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: const Text('Đã reset password'),
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
          'Reset password',
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
                // Orange lock + refresh icon
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 64,
                        color: Colors.orange.shade400,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Icon(
                          Icons.refresh,
                          size: 26,
                          color: Colors.orange.shade400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Nhập email' : null,
                ),

                const SizedBox(height: 20),

                // Reset password button (text, centered)
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
                    onPressed: _onResetPassword,
                    child: const Text(
                      'Reset password',
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
