import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  final String token;
  const DashboardScreen({required this.token, super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late String userId;
  late String username;
  final _titleCtrl = TextEditingController();
  final _descCtrl  = TextEditingController();
  List? items;

  @override
  void initState() {
    super.initState();
    // Decode JWT để lấy userId và username
    final Map<String, dynamic> decoded = JwtDecoder.decode(widget.token);
    userId   = decoded['sub']?.toString() ?? decoded['nameid']?.toString() ?? '';
    username = decoded['unique_name']?.toString() ?? decoded['email']?.toString() ?? 'User';
    _getTodoList();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  // ── GET todos ───────────────────────────────────────────────
  void _getTodoList() async {
    try {
      var response = await http.get(
        Uri.parse(ApiConfig.todos),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.token}",
        },
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        setState(() => items = decoded is List ? decoded : []);
      }
    } catch (_) {}
  }

  // ── ADD todo ────────────────────────────────────────────────
  void _addTodo() async {
    if (_titleCtrl.text.isNotEmpty && _descCtrl.text.isNotEmpty) {
      try {
        var response = await http.post(
          Uri.parse(ApiConfig.todos),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${widget.token}",
          },
          body: jsonEncode({
            "title":       _titleCtrl.text,
            "description": _descCtrl.text,
          }),
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          _titleCtrl.clear();
          _descCtrl.clear();
          if (!mounted) return;
          Navigator.pop(context);
          _getTodoList();
        }
      } catch (_) {}
    }
  }

  // ── DELETE todo ─────────────────────────────────────────────
  void _deleteItem(dynamic id) async {
    try {
      var response = await http.delete(
        Uri.parse(ApiConfig.todoById(int.tryParse(id.toString()) ?? 0)),
        headers: {"Authorization": "Bearer ${widget.token}"},
      );
      if (response.statusCode == 200) {
        _getTodoList();
      }
    } catch (_) {}
  }

  // ── LOGOUT ──────────────────────────────────────────────────
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  // ── ADD DIALOG ──────────────────────────────────────────────
  Future<void> _showAddDialog(BuildContext ctx) async {
    return showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Add To-Do'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: TextField(
                controller: _titleCtrl,
                decoration: InputDecoration(
                  filled: true, fillColor: Colors.white,
                  hintText: "Title",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: TextField(
                controller: _descCtrl,
                decoration: InputDecoration(
                  filled: true, fillColor: Colors.white,
                  hintText: "Description",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _addTodo,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Add", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final count = items?.length ?? 0;

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── HEADER ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30.0,
                  child: Icon(Icons.list, size: 30.0),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'ToDo with ASP.NET Core + SQL Server',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '$count Task',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),

          // ── TODO LIST ───────────────────────────────────────
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft:  Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: items == null
                    ? const Center(child: CircularProgressIndicator())
                    : items!.isEmpty
                        ? const Center(
                            child: Text('Chưa có việc cần làm\nNhấn + để thêm!',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, color: Colors.grey)),
                          )
                        : ListView.builder(
                            itemCount: items!.length,
                            itemBuilder: (context, index) {
                              final item = items![index];
                              return Slidable(
                                key: ValueKey(item['id']),
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  dismissible: DismissiblePane(
                                    onDismissed: () => _deleteItem(item['id']),
                                  ),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: const Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                      onPressed: (_) => _deleteItem(item['id']),
                                    ),
                                  ],
                                ),
                                child: Card(
                                  child: ListTile(
                                    leading: const Icon(Icons.task),
                                    title: Text('${item['title']}'),
                                    subtitle: Text('${item['description'] ?? ''}'),
                                    trailing: const Icon(Icons.arrow_back),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
          ),
        ],
      ),

      // ── FAB ─────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        tooltip: 'Add-ToDo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
