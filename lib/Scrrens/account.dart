import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:untitled123/Auth_Services/UserModel.dart';
import 'package:untitled123/Auth_Services/ChangePassword.dart';

import '../Auth_Services/Account_service.dart';
import '../Auth_Services/SignUp_Services.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int no_of_orders = 7;
  late int balance;
  late String Username;
  late String Role;
  late String mail;
  FirebaseAuth _auth = FirebaseAuth.instance;
  late Users Iam;
  bool is_loading_complete = false;

  Future<void> getdata() async {
    try {
      Iam = await GetMe(_auth.currentUser!.uid.trim());
      debugPrint("No issue while getting me");
      balance = Iam.balance;
      Username = Iam.first_name + " " + Iam.last_name;
      Role = Iam.role;
      mail = Iam.email;

      setState(() {
        is_loading_complete = true;
      });
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      // Show an error message to the user

    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: is_loading_complete
          ? SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                height: height / 4,
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Row(
                          children: [
                            Container(
                              height: height / 7,
                              width: width / 3,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage('assets/user.png'),
                              ),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Username,
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                  Text(
                                    Role,
                                    style: TextStyle(color: Colors.white, fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Icon(Icons.email, color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          child: Text(
                            mail,
                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                height: height / 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: height / 6,
                      width: width / 2.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Text(
                                balance.toString(),
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          Text('Wallet'),
                        ],
                      ),
                    ),
                    Container(
                      height: height / 6,
                      width: width / 2.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Text(
                                no_of_orders.toString(),
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          Text('Orders'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    height: height / 4,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: ListView(
                      children: [
                        ListTile(
                          leading: Icon(Icons.password),
                          title: Text("Change Password"),
                          trailing: Icon(Icons.navigate_next),
                          onTap: () {
                            Get.to(Changepassword());
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.timer),
                          title: Text("Order History"),
                          trailing: Icon(Icons.navigate_next),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(color: Colors.orange, fontSize: 15),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            logout();
                          },
                          child: Text(
                            "Logout",
                            style: TextStyle(color: Colors.orange, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
