import 'dart:async';
import 'package:flutter/cupertino.dart';

class TimerProvider with ChangeNotifier {
  Map<int, int> orderTimers = {}; // Map to store timers for each order
  Map<int, Timer> activeTimers = {}; // Map to store active timers for each order

  // Method to initialize timers for multiple orders
  void initializeTimers(List<int> orderIds, List<int> durations) {
    if (orderIds.length != durations.length) {
      throw ArgumentError("orderIds and durations must have the same length");
    }

    for (int i = 0; i < orderIds.length; i++) {
      int orderId = orderIds[i];
      int duration = durations[i];

      // Only start the timer if the duration is positive
      if (duration > 0) {
        startDecreasingMinutes(orderId, duration);
      } else {
        // Set the remaining time to zero for orders with zero or negative duration
        orderTimers[orderId] = 0;
        notifyListeners(); // Update the UI
      }
    }
  }

  void startDecreasingMinutes(int orderId, int initialMinutes) {
    // If the timer is already running, don't start it again
    if (activeTimers.containsKey(orderId)) {
      return;
    }

    // Initialize the timer if it doesn't exist
    if (!orderTimers.containsKey(orderId)) {
      orderTimers[orderId] = initialMinutes;
    }

    // Start the timer
    activeTimers[orderId] = Timer.periodic(Duration(seconds: 10), (timer) {
      if (orderTimers[orderId]! > 0) {
        orderTimers[orderId] = orderTimers[orderId]! - 1;
        notifyListeners();
      } else {
        timer.cancel();
        activeTimers.remove(orderId); // Remove the timer when it's done
      }
    });
  }

  int getRemainingMinutes(int orderId) {
    return orderTimers[orderId] ?? 0;
  }

  // Clean up timers when the provider is disposed
  @override
  void dispose() {
    activeTimers.forEach((orderId, timer) {
      timer.cancel();
    });
    super.dispose();
  }
}