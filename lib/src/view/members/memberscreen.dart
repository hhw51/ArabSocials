import 'package:flutter/material.dart';

class Memberscreen extends StatefulWidget {
  const Memberscreen({super.key});

  @override
  State<Memberscreen> createState() => _MemberscreenState();
}

class _MemberscreenState extends State<Memberscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color.fromARGB(255, 255, 7, 44),
      ),
    );
  }
}