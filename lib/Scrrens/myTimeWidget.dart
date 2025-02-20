import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeIncrementer extends StatelessWidget {
  final String timestamp;
  final int incrementMinutes;

  TimeIncrementer({required this.timestamp, required this.incrementMinutes});

  @override
  Widget build(BuildContext context) {
    // Extract time from the timestamp
    DateTime parsedTime = _parseTimestamp(timestamp);
    // Increment time by the specified minutes
    DateTime incrementedTime = parsedTime.add(Duration(minutes: incrementMinutes));
    // Format the incremented time
    String formattedTime = _formatTime(incrementedTime);

    return Center(
      child: Text(
        formattedTime,
        style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
      ),
    );
  }

  DateTime _parseTimestamp(String timestamp) {
    // Remove the 'UTC' part and split the string
    String cleanedTimestamp = timestamp.replaceAll('UTC', '').trim();
    List<String> parts = cleanedTimestamp.split(' ');

    // Extract the timezone offset
    String offset = parts.removeLast(); // e.g., +5 or -5
    int hoursOffset = int.parse(offset); // Convert to integer

    // Parse the timestamp without the offset
    DateFormat format = DateFormat("MMMM d, yyyy 'at' h:mm:ss a");
    DateTime parsedTime = format.parse(parts.join(' '));

    // Adjust for the timezone offset to convert to UTC time
    return parsedTime.subtract(Duration(hours: hoursOffset));
  }

  String _formatTime(DateTime dateTime) {
    // Format the time in "h:mm" format
    return DateFormat('h:mm a').format(dateTime);
  }
}