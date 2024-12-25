import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled123/Auth_Services/NewSignUp.dart';

import '../UI_helper/Custom_widgets.dart';
import '../homescreen.dart';
import 'SignUp.dart';
class newLogin extends StatefulWidget {
  const newLogin({super.key});

  @override
  State<newLogin> createState() => _newLoginState();
}

class _newLoginState extends State<newLogin> {
  final _formkey = GlobalKey<FormState>();
  bool loading=false;
  String? DropDownValue;
  FirebaseAuth _auth=FirebaseAuth.instance;
  var email = TextEditingController();
  var password = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.green.shade700,
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: [
            SizedBox(height: height/4,),
            Container(
              height: height-height/4,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 7,
                    spreadRadius: 2,
                    color: Colors.green.shade500
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      "Welcome Back!!!",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(margin: EdgeInsets.only(left: 20,top: 40,right: 20),

                    child: Form(
                      key: _formkey,
                      child: Column(
                        spacing: 30,
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter Email";
                              }
                              return null;
                            },
                            controller: email,
                            decoration: InputDecoration(
                              hintText: "Email",
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter Password";
                              }
                              return null;
                            },
                            controller: password,
                            decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: Icon(Icons.password),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: RoundButton(
                              loading: loading,
                              text: 'Login',
                              onTap: () {
                                if (_formkey.currentState!.validate()) {

                                  // Handle login
                                  setState(() {
                                    loading=true;
                                  });
                                  _auth.signInWithEmailAndPassword(email: email.text.trim(), password: password.text.trim()).then((value){
                                    setState(() {
                                      loading=false;
                                    });
                                    Get.off(Homescreen());
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        onTap: () {
                          // Action for Forgot Password
                        },
                      ),
                    ],
                  ),
                  RoundButton(
                    text: 'Create Account',
                    onTap: () {
                      // Action for creating Account
                      Get.to(newSignUp());
                    },
                  ),
                ],
              ),
            )
        
          ],),
        ),
      ),
    );
  }
}
