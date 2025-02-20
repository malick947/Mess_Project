import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled123/Auth_Services/UserModel.dart';
import 'package:untitled123/Providers/Role_Provider.dart';
import '../Auth_Services/Account_service.dart';
import '../Models/Queue_Services.dart';
import '../Providers/StopWatch_Provider.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  late Future<void> _initialization;
  late String role;
  Users? me;
  List<Map<String, dynamic>> myOrders = [];
  List<int> orderDurations = [];
  int currentServ = 0;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _initialization = _initializeData();
    // Refresh data every 60 seconds
    Timer.periodic(const Duration(seconds: 60), (timer) async {
      await _fetchOrders();
    });
  }

  Future<void> _initializeData() async {
    await _updateMyRole();
    await _fetchOrders();
  }

  Future<void> _updateMyRole() async {
    me = await GetMe(_auth.currentUser!.uid.trim());
    setState(() {
      role = me!.role;
    });
  }

  Future<void> _fetchOrders() async {
    if (role.isEmpty) await _updateMyRole();

    final orders = await GetMyOrdersDetails(role, _auth.currentUser!.uid.trim());
    await _calculateDurations(orders, role);

    setState(() {
      myOrders = orders;
    });
  }

  Future<void> _calculateDurations(List<Map<String, dynamic>> orders, String role) async {
    try {
      // Fetch the current serving number
      final currentServing = await getminimumNumber(role);

      // Ensure currentServing is an integer
      if (currentServing == null) {
        throw Exception("Current serving number is null");
      }

      // Calculate durations for each order
      final List<int> durations = [];
      for (final order in orders) {
        // Ensure order['orderID'] is an integer
        final orderID = order['orderID'];
        if (orderID == null || orderID is! int) {
          throw Exception("Invalid orderID: $orderID");
        }

        // Calculate duration (orderID - currentServing)
        final duration = orderID - currentServing;
        durations.add(duration);
      }

      // Update state with the new durations
      setState(() {
        currentServ = currentServing;
        orderDurations = durations;
      });
    } catch (e) {
      // Handle errors gracefully
      debugPrint("Error in _calculateDurations: $e");
      setState(() {
        orderDurations = []; // Clear durations if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Queue")),
      ),
      body: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: height / 6,
                        width: width / 2.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Queue No.', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text('$currentServ', style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        const Center(child: Text("Pending Orders", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
                        Container(
                          height: height / 2.1,
                          width: width,
                          child: ListView.builder(
                            itemCount: myOrders.length,
                            itemExtent: 100,
                            itemBuilder: (context, index) {
                              final orderNo = myOrders[index]['orderID'];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    border: Border.all(width: 1, color: Colors.orange.shade800),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.orangeAccent)],
                                  ),
                                  child: Center(
                                    child: ListTile(
                                      leading: const Icon(Icons.widgets, color: Colors.white),
                                      title: Text(
                                        'Order No $orderNo',
                                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Container(
                                        height: 50,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.grey)],
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${orderDurations[index]} m',
                                            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}