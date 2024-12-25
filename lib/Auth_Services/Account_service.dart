

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

Future<Users> GetMe(String uid) async{

  List<Map<String, dynamic>> Banday = await getUsers();
  bool emailFound = false;

  late Users Me;
  for (var user in Banday) {
    if (user['uid'] == uid) {


      Me=Users(uid: user['uid'], first_name: user['firstName'], last_name: user['lastName'], email: user['email'], password: user['password'], role: user['role'],balance: user['balance']);
      debugPrint(Me.first_name);
      break;
    }
  }

  return Me;


}