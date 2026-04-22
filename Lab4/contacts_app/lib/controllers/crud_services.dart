import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CRUDService {
  User? get user => FirebaseAuth.instance.currentUser;

  // add new contacts to firestore
  Future<void> addNewContacts(
      String name, String phone, String email) async {
    if (user == null) throw Exception("User not logged in");
    final Map<String, dynamic> data = {
      "name": name,
      "email": email,
      "phone": phone,
    };
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("contacts")
          .add(data);
    } catch (e) {
      rethrow;
    }
  }

  // read documents inside firestore
  Stream<QuerySnapshot> getContacts({String? searchQuery}) async* {
    if (user == null) return;
    var contactsQuery = FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("contacts")
        .orderBy("name");

    // a filter to perform search
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final String searchEnd = "$searchQuery\uf8ff";
      contactsQuery = contactsQuery.where("name",
          isGreaterThanOrEqualTo: searchQuery, isLessThan: searchEnd);
    }

    final contacts = contactsQuery.snapshots();
    yield* contacts;
  }

  // update a contact
  Future<void> updateContact(
      String name, String phone, String email, String docID) async {
    if (user == null) throw Exception("User not logged in");
    final Map<String, dynamic> data = {
      "name": name,
      "email": email,
      "phone": phone,
    };
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("contacts")
          .doc(docID)
          .update(data);
    } catch (e) {
      rethrow;
    }
  }

  // delete contact from firestore
  Future<void> deleteContact(String docID) async {
    if (user == null) throw Exception("User not logged in");
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("contacts")
          .doc(docID)
          .delete();
    } catch (e) {
      rethrow;
    }
  }
}
