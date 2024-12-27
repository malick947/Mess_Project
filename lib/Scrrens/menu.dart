// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
//import 'package:get/get_core/src/get_main.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled123/Auth_Services/Account_service.dart';
import 'package:untitled123/Auth_Services/UserModel.dart';
import 'package:untitled123/Models/localDBModel.dart';
//import 'package:untitled123/Scrrens/account.dart';
//import 'package:untitled123/Scrrens/orderQueue.dart';
//import 'package:untitled123/homescreen.dart';

import '../Models/menu_model';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin {
  double quantitySelector = 0.0;
  TabController? tabController;
  List<MenuDay> menuData = [];
  String searchQuery = "";
  List<Map<String, dynamic>> cart = []; // Dynamic array of maps for cart items

  bool isLoading = true;

  int orderID =0;
  var totalCartPrice = 0; // Total price of all items in the cart
  late String userID;
  late String userName;
  late String userEmail;
  late int userBalance;
  late String userRole;

  // ignore: prefer_final_fields

  late Users currentUserInfo;

  void _refresh() {
    setState(() {
      getUserData();
    });
  }

  void getUserData() async {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    currentUserInfo = await GetMe(_firebaseAuth.currentUser!.uid.toString());

    userID = currentUserInfo.uid;
    userName = currentUserInfo.first_name + " " + currentUserInfo.last_name;
    userEmail = currentUserInfo.email;
    userBalance = currentUserInfo.balance;
    userRole = currentUserInfo.role;
  }

  // ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,

  Future<int> getNextOrderId(String rolebase) async {
    String collectionName = '';
    if (rolebase == "Male Student") {
      collectionName = "male_orders";
    } else if (rolebase == "Female Student") {
      collectionName = "female_orders";
    } else if (userRole == "Faculty or Staff") {
      collectionName = "faculity_staff_orders";
    }
    try {
      final ordersCollection = FirebaseFirestore.instance.collection(collectionName);

      final snapshot = await ordersCollection.get();

      if (snapshot.docs.isEmpty) {
        orderID = 1;
        return 1;
      }

      int maxOrderId = 0;
      for (var doc in snapshot.docs) {
        
        final orderId = doc.data()['orderID'];
        if (orderId is int && orderId > maxOrderId) {
          maxOrderId = orderId;
        }
      }

      
      orderID = maxOrderId+1;
      return maxOrderId + 1;
    } catch (e) {
      print("Error fetching orders: $e");
      // Handle errors appropriately
      throw Exception("Failed to fetch next order ID.");
    }
  }

  // ...........................................................................

  int getCartItemCount() {
    return cart.fold(0, (int sum, item) {
      final quantity =
          item['quantity'] as num; // Ensure it's treated as a number
      return sum + quantity.toInt() + 1; // Convert to int and add
    });
  }

  ////////////////////// Balance Deduction ///////////////////////////////////////////////

  Future<void> deductBalance(String uid, int priceToDeduct) async {
    try {
      // Query Firestore to find the document with the given UID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('customers')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();

      // Check if any document is returned
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first matching document reference
        DocumentReference docRef = querySnapshot.docs.first.reference;

        // Fetch the current balance
        DocumentSnapshot doc = await docRef.get();
        if (doc.exists) {
          int currentBalance = doc['balance'];

          // Check if sufficient balance is available
          if (currentBalance >= priceToDeduct) {
            int updatedBalance = currentBalance - priceToDeduct;

            // Update the balance in Firestore
            await docRef.update({'balance': updatedBalance});

            //print("Balance updated successfully. New balance: $updatedBalance");
          } else {
            //print("Insufficient balance!");
          }
        } else {
          //print("Document does not exist!");
        }
      } else {
        //print("No matching document found for UID: $uid");
      }
    } catch (e) {
      //print("Error updating balance: $e");
    }
  }

  ////////////////////// Balance Deduction ///////////////////////////////////////////////

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
    getUserData();
    showLoadingIndicator();

    tabController = TabController(
        length: weekDays.length, vsync: this); // Fixed tabs for 7 days
    fetchData();
  }

  void increment() {
    setState(() {
      //counterRoti += 1;
    });
  }

  void decrement() {
    setState(() {
      if (quantitySelector > 0) {
        quantitySelector -= 1;
      }
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

  void addToCart(String name, double price) {
    setState(() {
      final existingItemIndex = cart.indexWhere((item) => item['name'] == name);
      if (existingItemIndex >= 0) {
        // Update quantity and price for existing item
        cart[existingItemIndex]['quantity'] += 0.5;
        cart[existingItemIndex]['totalPrice'] =
            cart[existingItemIndex]['quantity'] * price;
      } else {
        // Add new item to cart
        cart.add({
          'name': name,
          'quantity': 0.5,
          'unitPrice': price,
          'totalPrice': 0.5 * price,
        });
      }
      updateTotalCartPrice();
    });
  }

  void removeFromCart(String name, double price) {
    setState(() {
      final existingItemIndex = cart.indexWhere((item) => item['name'] == name);
      if (existingItemIndex >= 0) {
        cart[existingItemIndex]['quantity'] -= 0.5;
        if (cart[existingItemIndex]['quantity'] <= 0) {
          cart.removeAt(existingItemIndex);
        } else {
          cart[existingItemIndex]['totalPrice'] =
              cart[existingItemIndex]['quantity'] * price;
        }
      }
      updateTotalCartPrice();
    });
  }

  void showLoadingIndicator() async {
    await Future.delayed(Duration(seconds: 2)); // Wait for 3 seconds

    isLoading = false; // Switch to showing text
  }

  void updateTotalCartPrice() {
    totalCartPrice = cart.fold(0, (int sum, item) {
      final totalPrice =
          item['totalPrice'] as num; // Ensure it's treated as num
      return sum + totalPrice.toInt(); // Safely convert to int and add
    });
  }

  void placeOrder() async {
    orderID = await getNextOrderId(userRole);
    //print("Next Order ID: $orderID");
    //getNextOrderId(userRole);
    getUsers();
    //print(orderID);
    final order = {
      'orderID': orderID,
      'items': cart,
      'email': userEmail,
      'role': userRole,
      'uid': userID,
      'timestamp': FieldValue.serverTimestamp(),
      'totalPrice': totalCartPrice,
    };

    if (userRole == "Male Student") {
      await FirebaseFirestore.instance.collection('male_orders').add(order);
    } else if (userRole == "Female Student") {
      await FirebaseFirestore.instance.collection('female_orders').add(order);
    } else if (userRole == "Faculty or Staff") {
      await FirebaseFirestore.instance
          .collection('faculity_staff_orders')
          .add(order);
    }
    //await FirebaseFirestore.instance.collection('orders').add(order);

    //await DatabaseHelper.instance.insertOrder(order);
    setState(() {
      cart.clear(); // Clear the cart after placing the order
      totalCartPrice = 0;
    });

    Get.snackbar(
        "Order Placed Successfully", "Wait So that We will place the Order",
        snackPosition: SnackPosition.TOP);
    Navigator.of(context).pop();
  }

  // void printLocalOrders() async {
  //   final orders = await DatabaseHelper.instance.getOrders();
  //   for (var order in orders) {
  //     //print(order);
  //   }
  // }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  String rotiName = "Roti";
  int rotiprice = 15;

  void showCartBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
                color: Colors.blueGrey.shade100,
                borderRadius: BorderRadius.circular(40)),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Cart',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          tileColor: Colors.white,
                          trailing: Text(
                              "Total: ${item['totalPrice'].toStringAsFixed(2)} rs."),
                          title: Text(item['name']),
                          subtitle: Text('Quantity: ${item['quantity']}'),
                        ),
                      );
                    },
                  ),
                ),
                Text(
                  'Total Price: $totalCartPrice rs.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange),
                  ),
                  onPressed: () async {
                    //getUserData();
                    // setState(() {
                    //   getUserData();
                    // });
                    if (totalCartPrice <= userBalance) {
                      placeOrder();
                      deductBalance(userID, totalCartPrice);
                      //printLocalOrders();

                      setState(() {});
                      _refresh();
                    } else {
                      Get.snackbar("UnSufficient Balance!",
                          "Please recharge your account to order meals.",
                          backgroundColor: Colors.red.shade400,
                          colorText: Colors.white);
                    }
                  },
                  child: Text(
                    'Confirm Order',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedShoppingCart02,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    getUserData();
                    showCartBottomSheet();
                  },
                ),
                if (getCartItemCount() >
                    0) // Show badge only if there are items in the cart
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        getCartItemCount().toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
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
                      icon: HugeIcons.strokeRoundedSearch01,
                      color: Colors.black),
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
                    return isLoading
                        ? Center(
                            child:
                                CircularProgressIndicator(), // Show progress indicator
                          )
                        : Center(
                            child: Text(
                              "No menu available for this day.",
                              style: TextStyle(fontSize: 18),
                            ),
                          ); // No menu message
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
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 20, left: 20, right: 20, bottom: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: const CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      AssetImage("assets/imagetest.png"),
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
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
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
                                        removeFromCart(item.name,
                                            double.parse(item.price));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: HugeIcon(
                                            icon: HugeIcons
                                                .strokeRoundedMinusSign,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Center(
                                            child: Text(
                                          cart
                                              .firstWhere(
                                                (cartItem) =>
                                                    cartItem['name'] ==
                                                    item.name,
                                                orElse: () => {'quantity': 0.0},
                                              )['quantity']
                                              .toString(),
                                          style: TextStyle(color: Colors.white),
                                        )),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        addToCart(item.name,
                                            double.parse(item.price));
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
        bottomNavigationBar: cart.isEmpty ? SizedBox() : buildCartBar());
  }

  Widget buildCartBar() {
    return GestureDetector(
      onTap: () {
        showCartBottomSheet(); // Open the bottom cart sheet
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.green, width: 2),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                getUserData();
                showCartBottomSheet(); // Open bottom sheet on button click
              },
              child: Text(
                "View Cart",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 10),
            // Show circular images for items in the cart
            Expanded(
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(4),
                      margin: EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.6),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                        //border: Border.all(color: Colors.green, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(
                            'assets/imagetest.png'), // Replace with actual item image
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
