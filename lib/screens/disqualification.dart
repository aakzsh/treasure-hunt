import 'package:fanapp/extras/colors.dart';
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
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Center(
        child: Text(
          "Sorry, your team is out!!",
          style: TextStyle(color: MyColors.GreenColor, fontSize: 20),
        ),
      )),
    );
  }
}
