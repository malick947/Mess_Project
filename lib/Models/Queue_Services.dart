import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

Future<int> getminimumNumber(String rolebase) async {
  // Determine the collection name based on the role
  final collectionName = _getCollectionName(rolebase);
  if (collectionName.isEmpty) {
    throw Exception("Invalid rolebase: $rolebase");
  }

  try {
    // Fetch the minimum orderID directly using a Firestore query
    final querySnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .orderBy('orderID', descending: false)
        .limit(1)
        .get();

    // Check if any documents were returned
    if (querySnapshot.docs.isEmpty) {
      throw Exception("No orders found in the collection: $collectionName");
    }

    // Return the minimum orderID
    return querySnapshot.docs.first.data()['orderID'] as int;
  } catch (e) {
    debugPrint("Error fetching minimum order ID: $e");
    throw Exception("Failed to fetch minimum order ID: $e");
  }
}

// Helper function to get the collection name based on the role
String _getCollectionName(String rolebase) {
  switch (rolebase) {
    case "Male Student":
      return "male_orders";
    case "Female Student":
      return "female_orders";
    case "Faculty or Staff":
      return "faculity_staff_orders";
    default:
      return "";
  }
}

Future<List<Map<String, dynamic>>> GetMyOrdersDetails(String rolebase, String uid) async {
  String collectionName = '';

  // Determine the collection name based on the rolebase
  if (rolebase == "Male Student") {
    collectionName = "male_orders";
  } else if (rolebase == "Female Student") {
    collectionName = "female_orders";
  } else if (rolebase == "Faculty or Staff") {
    collectionName = "faculity_staff_orders";
  }

  try {
    // Access the appropriate orders collection
    final ordersCollection = FirebaseFirestore.instance.collection(collectionName);

    // Query the collection for documents where uid matches the provided uid
    final snapshot = await ordersCollection.where('uid', isEqualTo: uid).get();

    // Convert the snapshot into a List<Map<String, dynamic>>
    List<Map<String, dynamic>> orders = snapshot.docs.map((doc) {
      return doc.data() as Map<String, dynamic>;
    }).toList();

    return orders;

  } catch (e) {
    print("Error fetching orders: $e");
    // Handle errors appropriately
    throw Exception("Failed to fetch orders for the given uid.");
  }
}


Future<int> GetOrdersNumber(String rolebase) async {
  String collectionName = '';

  // Determine the collection name based on the rolebase
  if (rolebase == "Male Student") {
    collectionName = "male_orders";
  } else if (rolebase == "Female Student") {
    collectionName = "female_orders";
  } else if (rolebase == "Faculty or Staff") {
    collectionName = "faculity_staff_orders";
  }

  try {
    // Access the appropriate orders collection
    final ordersCollection = FirebaseFirestore.instance.collection(collectionName);

    // Query the collection for documents where uid matches the provided uid
    final snapshot = await ordersCollection.get();

    // Convert the snapshot into a List<Map<String, dynamic>>
    List<Map<String, dynamic>> orders = snapshot.docs.map((doc) {
      return doc.data() as Map<String, dynamic>;
    }).toList();

    return orders.length.toInt();

  } catch (e) {
    print("Error fetching orders: $e");
    // Handle errors appropriately
    throw Exception("Failed to fetch numbers of orders.");
  }
}


