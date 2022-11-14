import 'package:flutter/material.dart';

class Disqualification extends StatefulWidget {
  const Disqualification({super.key});

  @override
  State<Disqualification> createState() => _DisqualificationState();
}

class _DisqualificationState extends State<Disqualification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Sorry, your team is out!!"),
        ],
      )),
    );
  }
}
