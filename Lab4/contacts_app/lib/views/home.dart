import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_app/controllers/auth_services.dart';
import 'package:contacts_app/controllers/crud_services.dart';
import 'package:contacts_app/views/update_contact.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Stream<QuerySnapshot> _stream;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchnode = FocusNode();

  @override
  void initState() {
    _stream = CRUDService().getContacts();
    super.initState();
  }

  @override
  void dispose() {
    _searchnode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // call contact using url_launcher
  Future<void> callUser(String phone) async {
    final String url = "tel:$phone";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "Could not launch $url";
    }
  }

  void searchContacts(String search) {
    if (search.isEmpty) {
      _stream = CRUDService().getContacts();
    } else {
      _stream = CRUDService().getContacts(searchQuery: search);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Drawer (≡ menu) theo mockup đề bài
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                "Contacts App",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                await AuthService().logout();
                if (!context.mounted) return;
                Navigator.pushReplacementNamed(context, "/login");
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Contacts"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/add");
        },
        child: const Icon(Icons.person_add),
      ),
      body: Column(
        children: [
          // Search box
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              child: TextFormField(
                onChanged: (value) {
                  searchContacts(value);
                },
                focusNode: _searchnode,
                controller: _searchController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Search"),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          // List of contacts
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: _stream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text("Something Went Wrong"));
                  }
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return snapshot.data!.docs.isEmpty
                      ? const Center(
                          child: Text("No Contacts Found"))
                      : ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            final Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return ListTile(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UpdateContact(
                                            name: data["name"] ?? "",
                                            phone: data["phone"] ?? "",
                                            email: data["email"] ?? "",
                                            docID: document.id,
                                          ))),
                              leading: CircleAvatar(
                                child: Text(
                                  (data["name"] != null &&
                                          data["name"]
                                              .toString()
                                              .isNotEmpty)
                                      ? data["name"][0].toUpperCase()
                                      : "?",
                                ),
                              ),
                              title: Text(data["name"] ?? ""),
                              subtitle: Text(data["phone"] ?? ""),
                              trailing: IconButton(
                                icon: const Icon(Icons.call),
                                onPressed: () {
                                  if (data["phone"] != null &&
                                      data["phone"]
                                          .toString()
                                          .isNotEmpty) {
                                    callUser(data["phone"]);
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        );
                }),
          ),
        ],
      ),
    );
  }
}
