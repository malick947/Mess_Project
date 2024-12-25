
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:untitled123/Auth_Services/newLogin.dart';
import 'package:untitled123/homescreen.dart';

void is_login(){
  FirebaseAuth _auth=FirebaseAuth.instance;
  var user=_auth.currentUser;
  if(user == null){
    Get.off(newLogin(), transition: Transition.cupertino,duration: Duration(seconds: 1));
  }
  else
  {
    Get.off(Homescreen(),transition: Transition.cupertino,duration: Duration(seconds: 1));
  }
}