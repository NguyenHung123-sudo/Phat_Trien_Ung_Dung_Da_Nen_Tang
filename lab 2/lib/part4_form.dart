import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Part4Form extends StatelessWidget {
  const Part4Form({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterPage();
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Application')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            // Avatar Image
            Center(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/3d_avatar_21.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.person, size: 100, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'First Name',
              controller: firstNameController,
            ),
            CustomTextField(
              label: 'Last Name',
              controller: lastNameController,
            ),
            const CustomTextField(
              label: 'Email',
              suffixText: '@mlritm.ac.in',
            ),
            const CustomTextField(
              label: 'Phone Number',
              prefixText: '+91 ',
              keyboardType: TextInputType.phone,
              maxLength: 10,
            ),
            const Divider(indent: 8, endIndent: 8),
            const CustomTextField(label: 'Username'),
            const CustomTextField(
              label: 'Password',
              obscureText: true,
            ),
            const CustomTextField(
              label: 'Confirm Password',
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final fullName = '${firstNameController.text} ${lastNameController.text}';
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Registration Successful"),
                    content: Text("Welcome, $fullName"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Register'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? prefixText, suffixText;
  final int? maxLength;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.label,
    this.keyboardType,
    this.obscureText = false,
    this.prefixText,
    this.suffixText,
    this.maxLength,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        inputFormatters: maxLength != null
            ? [LengthLimitingTextInputFormatter(maxLength)]
            : null,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          prefixText: prefixText,
          suffixText: suffixText,
        ),
      ),
    );
  }
}
