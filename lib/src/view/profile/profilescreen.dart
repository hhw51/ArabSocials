import 'package:flutter/material.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color.fromARGB(255, 255, 90, 7),
      ),
    );
  }
}