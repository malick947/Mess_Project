import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:untitled123/Auth_Services/UserModel.dart';
import 'package:untitled123/Auth_Services/newLogin.dart';
import 'package:untitled123/homescreen.dart';
import 'package:get/get.dart';

Future<List<Map<String, dynamic>>> getLegalUsers() async {
  final CollectionReference collection = FirebaseFirestore.instance.collection('eligible_users');
  QuerySnapshot querySnapshot = await collection.get();


  List<Map<String, dynamic>> users = querySnapshot.docs.map((doc) {
    return doc.data() as Map<String, dynamic>;
  }).toList();

  return users;
}


Future<void> CreateLegalUser(String firstname,String lastname,String emailToMatch,String password,String role) async {
  FirebaseAuth _auth=FirebaseAuth.instance;
  final users=FirebaseFirestore.instance.collection('customers');
  List<Map<String, dynamic>> legalUsers = await getLegalUsers();
  bool emailFound = false;

  for (var user in legalUsers) {
    if (user['email'] == emailToMatch) {
      emailFound = true;
      break;
    }
  }


  if (emailFound) {
    await _auth.createUserWithEmailAndPassword(email: emailToMatch, password: password).then((value){
        Users newUser=Users(uid:_auth.currentUser!.uid.toString(),first_name: firstname, last_name: lastname, email: emailToMatch, password: password, role: role);

        users.add(newUser.toMap());
        Get.to(Homescreen());
    },onError: (error){
      Get.snackbar('Error Message', error.toString(),
      duration: Duration(seconds: 3),
      colorText: Colors.black,
      backgroundColor: Colors.white);
    });

  } else {
    Get.snackbar(
      "Use University Mail" ,
      "",
      duration: Duration(seconds: 3),
      colorText: Colors.black,

      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.grey,
    );
  }
}

void logout(){
  FirebaseAuth _auth=FirebaseAuth.instance;
  _auth.signOut();
  Get.snackbar(
    "Sign Out Successfully" ,
    "",
    duration: Duration(seconds: 3),
    colorText: Colors.white,


    backgroundColor: Colors.green.shade700,
  );
  Get.off(newLogin());
}