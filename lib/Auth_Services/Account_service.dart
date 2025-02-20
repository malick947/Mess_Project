

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled123/Auth_Services/UserModel.dart';

Future<List<Map<String,dynamic>>> getUsers() async {
  final CollectionReference collection = FirebaseFirestore.instance.collection('customers');
  QuerySnapshot querySnapshot = await collection.get();


  List<Map<String, dynamic>> users = querySnapshot.docs.map((doc) {
    return doc.data() as Map<String, dynamic>;
  }).toList();

  return users;
}

Future<Users> GetMe(String uid) async {
  debugPrint(uid);
  try {
    // Query the 'customers' collection to find the document where the 'uid' field matches the provided uid
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('customers')
        .where('uid', isEqualTo: uid)
        .limit(1) // Limit to 1 document since uid should be unique
        .get();

    // Check if any documents were returned
    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first; // Get the first document
      final userData = doc.data() as Map<String, dynamic>;
      return Users(
        uid: userData['uid'],
        first_name: userData['firstName'],
        last_name: userData['lastName'],
        email: userData['email'],
        password: userData['password'],
        role: userData['role'],
        balance: userData['balance'],
      );
    } else {
      throw Exception("User not found");
    }
  } catch (e) {
    debugPrint("Error fetching user: $e");
    rethrow;
  }
}