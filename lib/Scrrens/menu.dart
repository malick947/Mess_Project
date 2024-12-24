import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:untitled123/Models/menu_model';


class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin {
  double quantitySelector = 0.0;
  TabController? tabController;
  List<MenuDay> menuData = [];
  String searchQuery = "";

  // Days of the week in order
  final List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: weekDays.length, vsync: this); // Fixed tabs for 7 days
    fetchData();
  }

  void increment() {
    setState(() {
      quantitySelector = quantitySelector + 0.5;
    });
  }

  void decrement() {
    setState(() {
      quantitySelector = quantitySelector - 0.5;
    });
  }

  Future<void> fetchData() async {
    final menuService = MenuService(); // Initialize the service
    final data =
        await menuService.fetchMenuData(); // Fetch the data from Firestore
    setState(() {
      menuData = data;
    });
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Menu",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search your meals...",
                prefixIcon: HugeIcon(
                    icon: HugeIcons.strokeRoundedSearch01, color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.black, width: 2)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.orange, width: 2)),
              ),
            ),
          ),
          TabBar(
            isScrollable: true,
            indicatorColor: Colors.orange,
            labelColor: Colors.orange,
            controller: tabController,
            tabs: weekDays
                .map((day) => Tab(text: day))
                .toList(), // Fixed tabs for all days
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: weekDays.map((day) {
                // Find menu data for the current day
                final menuDay = menuData.firstWhere(
                  (menu) => menu.day == day,
                  orElse: () => MenuDay(day: day, items: []),
                ); // Default empty menu

                // Filter items based on search query
                final filteredItems = menuDay.items.where((item) {
                  return item.name.toLowerCase().contains(searchQuery) ||
                      item.description.toLowerCase().contains(searchQuery);
                }).toList();

                if (filteredItems.isEmpty) {
                  return Center(
                      child: Text(
                          "No menu available for $day.")); // No menu message
                }

                // Render grid of items
                return GridView.count(
                  childAspectRatio: 0.65,
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  padding: EdgeInsets.all(8),
                  children: List.generate(filteredItems.length, (index) {
                    final item = filteredItems[index];
                    return Card(
                      color: Colors.blueGrey.shade100,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 20, left: 20, right: 20, bottom: 5),
                        child: Column(
                          //spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                        0.3), // Shadow color with opacity
                                    blurRadius: 10, // Blur radius
                                    spreadRadius:
                                        1, // Spread radius (how much the shadow spreads)
                                  ),
                                ],
                              ),
                              child: const CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    AssetImage("assets/imagetest.png"),
                                //fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                              item.name,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Price: ${item.price}",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              padding: EdgeInsets.all(5),
                              height: 34,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (quantitySelector >= 0.5) {
                                        decrement();
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: HugeIcon(
                                          icon:
                                              HugeIcons.strokeRoundedMinusSign,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Center(
                                          child: Text(
                                        quantitySelector.toString(),
                                        style: TextStyle(color: Colors.white),
                                      )),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      increment();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: HugeIcon(
                                          icon: HugeIcons.strokeRoundedAdd01,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
