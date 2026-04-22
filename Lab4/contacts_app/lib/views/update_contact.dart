import 'package:contacts_app/controllers/crud_services.dart';
import 'package:flutter/material.dart';

class UpdateContact extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final String docID;

  const UpdateContact({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
    required this.docID,
  });

  @override
  State<UpdateContact> createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    // Pre-fill các field với dữ liệu contact hiện tại
    _nameController = TextEditingController(text: widget.name);
    _phoneController = TextEditingController(text: widget.phone);
    _emailController = TextEditingController(text: widget.email);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateContact() async {
    if (!formKey.currentState!.validate()) return;

    try {
      await CRUDService().updateContact(
        _nameController.text.trim(),
        _phoneController.text.trim(),
        _emailController.text.trim(),
        widget.docID,
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating contact: $e")),
      );
    }
  }

  Future<void> _deleteContact() async {
    // Hiện dialog xác nhận trước khi xóa
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Contact"),
        content:
            const Text("Are you sure you want to delete this contact?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await CRUDService().deleteContact(widget.docID);

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting contact: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Contact"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Name field (pre-filled)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? "Name cannot be empty." : null,
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name",
                  ),
                ),
              ),
              // Phone field (pre-filled)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Phone",
                  ),
                ),
              ),
              // Email field (pre-filled)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Update button
              SizedBox(
                height: 55,
                width: MediaQuery.of(context).size.width * .9,
                child: ElevatedButton(
                  onPressed: _updateContact,
                  child: const Text(
                    "Update",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Delete button (outlined)
              SizedBox(
                height: 55,
                width: MediaQuery.of(context).size.width * .9,
                child: OutlinedButton(
                  onPressed: _deleteContact,
                  child: const Text(
                    "Delete",
                    style: TextStyle(fontSize: 16),
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
