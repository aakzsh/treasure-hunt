import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanapp/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../extras/colors.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  String scores = "hehe";
  var score = [];
  // String group = "A";
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    // setState(() {
    //   score = ["123"];
    // });
    var prefs = await SharedPreferences.getInstance();
    int round = prefs.getInt("round")!;

    setState(() {
      group = prefs.getString("group")!;
    });

    print("123");
    await FirebaseFirestore.instance
        .collection("leaderboard")
        .doc(round == 1 ? "scores" : "scores2")
        .get()
        .then((value) => {
              // print(value),
              setState(() {
                score = value.data()!['scores'];
              })
            })
        .then((value) => {filterData()});
  }

  void filterData() async {
    log(score.toString());
    log("group hai" + group);
    var x = List.from(score.where((element) => element['group'] == 'A'));
    x.sort((a, b) => b['points'].compareTo(a['points']));
    setState(() {
      score = x;
    });
    log(x.toString());
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
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 0.0),
                        child: Text(
                          "Leaderboard Group $group",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24.0,
                              color: MyColors.GreenColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          getData();
                        },
                        icon: const Icon(Icons.refresh)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 400,
                child: ListView.builder(
                    itemCount: score.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: const Icon(Icons.auto_graph),
                        trailing: Text(
                          "Rank ${index + 1}",
                          style: TextStyle(color: Colors.green, fontSize: 15),
                        ),
                        title: Text(score[index]['team']),
                        subtitle:
                            Text("Score: " + score[index]['points'].toString()),
                      );
                    }),
              )
            ],
          ),
        ));
  }
}

String showTxt(score) {
  score..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  return "";
}
