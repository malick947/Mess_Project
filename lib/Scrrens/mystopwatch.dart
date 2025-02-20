import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final int hours;
  final int minutes;

  CountdownTimer({required this.hours, required this.minutes});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();

  void start() {
    // Trigger the start function from outside the widget
    _CountdownTimerState? state = this.createState();
    state._start();
  }
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int _remainingSeconds;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    // Initialize the remaining seconds
    _remainingSeconds = widget.hours * 3600 + widget.minutes * 60;
  }

  void _start() {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _stop(); // Stop the timer when it reaches zero
          }
        });
      });
    }
  }

  void _stop() {
    _isRunning = false;
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  String _formatTime(int seconds) {
    final hours = (seconds / 3600).floor();
    final minutes = ((seconds % 3600) / 60).floor();
    final secs = seconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatTime(_remainingSeconds),
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isRunning ? null : _start,
            child: Text('Start'),
          ),
          ElevatedButton(
            onPressed: _stop,
            child: Text('Stop'),
          ),
        ],
      ),
    );
  }
}