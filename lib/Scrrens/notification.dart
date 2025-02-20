import 'package:flutter/material.dart';
import 'package:untitled123/Auth_Services/Account_service.dart';
import 'package:untitled123/Auth_Services/NewSignUp.dart';
import 'package:untitled123/Auth_Services/newLogin.dart';
import 'package:get/get.dart';
import 'package:untitled123/Models/Queue_Services.dart';
import 'package:untitled123/Scrrens/myTimeWidget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    int docs=0;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Notifications")),
      ),
      body: ElevatedButton(onPressed: () async {

        int a=await getminimumNumber('Female Student');
            debugPrint(a.toString());
      }, child: Text("Timer")),
    );;
  }
}