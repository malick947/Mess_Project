import 'package:flutter/material.dart';
import 'package:untitled123/Auth_Services/Account_service.dart';
import 'package:untitled123/Auth_Services/NewSignUp.dart';
import 'package:untitled123/Auth_Services/newLogin.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Notifications")),
      ),
      body: ElevatedButton(onPressed: (){
        Get.to(newSignUp());
      }, child: Text("Goto New Signup page")),
    );;
  }
}