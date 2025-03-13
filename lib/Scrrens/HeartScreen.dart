import 'package:flutter/material.dart';

class Heartscreen extends StatefulWidget {
  const Heartscreen({super.key});

  @override
  State<Heartscreen> createState() => _HeartscreenState();
}

class _HeartscreenState extends State<Heartscreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      child: AboutDialog(),
    );
  }
}
