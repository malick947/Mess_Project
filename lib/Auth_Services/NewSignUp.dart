import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../UI_helper/Custom_widgets.dart';
import 'package:get/get.dart';

import 'SignUp.dart';
import 'SignUp_Services.dart';

class newSignUp extends StatefulWidget {
  const newSignUp({super.key});

  @override
  State<newSignUp> createState() => _newSignUpState();
}

class _newSignUpState extends State<newSignUp> {
  bool loading=false;
  String? DropDownValue;
  String hinttext="Select your role";
  var email = TextEditingController();
  var password = TextEditingController();
  var firstName=TextEditingController();
  var lastName=TextEditingController();
  final _formkey = GlobalKey<FormState>();

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

                  Container(margin: EdgeInsets.only(left: 20,top: 40,right: 20),

                    child: Form(
                      key: _formkey,
                      child: Column(
                        spacing: 20,
                        children: [

                          TextFormField(

                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter name";
                              }
                              return null;
                            },
                            controller: firstName,
                            decoration: InputDecoration(
                              hintText: "FirstName",
                              prefixIcon: Icon(Icons.wifi_protected_setup),
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

                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter name";
                              }
                              return null;
                            },
                            controller: lastName,
                            decoration: InputDecoration(
                              hintText: "LastName",
                              prefixIcon: Icon(Icons.wifi_protected_setup),
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

                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter email";
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

                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Set password";
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
                          DropdownButtonHideUnderline(child: DropdownButton2(
                            value: DropDownValue,
                            isDense: true,
                            hint: Text(
                              hinttext,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                DropDownValue = value;
                                hinttext=value!;
                              });
                            },
                            items: [
                              DropdownMenuItem(
                                child: Text("Male Student"),
                                value: 'Male Student',),
                              DropdownMenuItem(
                                child: Text("Female Student"),
                                value: 'Female Student',),
                              DropdownMenuItem(
                                child: Text("Faculty or Staff"),
                                value: 'Faculty or Staff',)
                            ],

                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                            ),)
                          ),
                          RoundButton(
                            loading: loading,
                            text: 'SignUp',
                            onTap: () {
                              //Must be check role slot of user
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  loading=true;
                                });
                                if(DropDownValue!=null){
                                  CreateLegalUser(firstName.text.toString(), lastName.text.toString(), email.text.toString(), password.text.toString(), DropDownValue!);
                                  setState(() {
                                    loading=false;
                                  });
                                }
                                else{
                                  Get.snackbar(
                                    "Select Role" ,
                                    "",


                                    duration: Duration(seconds: 3),
                                    colorText: Colors.white,

                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green,
                                  );
                                  setState(() {
                                    loading=false;
                                  });
                                }

                              }
                            },
                          ),
                        ],
                      ),
                    ),
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
