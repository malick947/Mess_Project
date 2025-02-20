import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:untitled123/Providers/Role_Provider.dart';
import 'package:untitled123/Providers/StopWatch_Provider.dart';
import 'package:untitled123/Scrrens/account.dart';
import 'package:untitled123/Scrrens/menu.dart';
import 'package:untitled123/Scrrens/notification.dart';
import 'package:untitled123/Scrrens/orderQueue.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {

  int selectedindex = 0;
  static List<Widget> options = <Widget>[
    // Text("Home",style: tstyle,),
    // Text("Notifications",style: tstyle,),
    // Text("Queue",style: tstyle,),
    // Text("Account",style: tstyle,),
    MenuPage(),
    NotificationScreen(),
    QueueScreen(),
    AccountScreen()

  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SafeArea(
          child: Center(
              child: options[selectedindex],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(0.1),
              )
            ]
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
              child: GNav(
                rippleColor: Colors.grey.shade300,
                hoverColor: Colors.grey.shade100,
                gap: 8,
                activeColor: Colors.orange,
                iconSize: 24,
                padding: const EdgeInsets.symmetric(vertical: 18,horizontal: 18),
                tabBackgroundColor: Colors.grey.shade100,
                color: Colors.black,
                tabs: const [
                  GButton(icon: HugeIcons.strokeRoundedHome01,text: "Home",),
                  GButton(icon: HugeIcons.strokeRoundedNotification01,text: "Notifications",),
                  GButton(icon: HugeIcons.strokeRoundedQueue01,text: "Queue",),
                  GButton(icon: HugeIcons.strokeRoundedUser,text: "Account",),
                ],
                selectedIndex: selectedindex,
                onTabChange: (index){
                  setState(() {
                    selectedindex = index;
                  });
                },

              ),
              ),
              ),
        ),
    );
  }
}