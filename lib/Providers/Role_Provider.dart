
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled123/Auth_Services/Account_service.dart';
import 'package:untitled123/Auth_Services/UserModel.dart';

class RoleProvider extends ChangeNotifier{
  FirebaseAuth _auth=FirebaseAuth.instance;
  String? myRole;
  Users? Me;

  Future<void> UpdateMyRole() async {
    Me=await GetMe(_auth.currentUser!.uid.trim());
    myRole=Me!.role;
    notifyListeners();
    debugPrint(myRole);
  }
}