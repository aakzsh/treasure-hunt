import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../extras/colors.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  String scores = "hehe";
  var score = [];
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    // setState(() {
    //   score = ["123"];
    // });
    print("123");
    await FirebaseFirestore.instance
        .collection("leaderboard")
        .doc("scores")
        .get()
        .then((value) => {
              // print(value),
              setState(() {
                score = value.data()!['scores'];
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios)),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 50.0),
                        child: Text(
                          "Leaderboard",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24.0,
                              color: MyColors.GreenColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(score.toString())
            ],
          ),
        ));
  }
}

String showTxt(score) {
  score..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  return "";
}