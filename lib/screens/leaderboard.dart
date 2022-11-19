import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanapp/currentuser.dart';
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
  int round = 1;
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

    // setState(() {
    //   // group = prefs.getString("group")!;
    //   round = prefs.getInt("round")!;
    // });

    print("123");
    // await FirebaseFirestore.instance
    //     .collection("leaderboard")
    //     .doc(round == 1 ? "scores" : "scores2")
    //     .get()
    //     .then((value) => {
    //           // print(value),
    //           setState(() {
    //             score = value.data()!['scores'];
    //           })
    //         })
    //     .then((value) => {filterData()});

    FirebaseFirestore.instance
        .collection("teams")
        .get()
        .then((value) => {
              // print(value.docs.map((e) => e.data()).toList())

              setState(() {
                score = value.docs.map((e) => e.data()).toList();
              }),
              // print(score.toString())
            })
        .then((value) => {filterData()});

    log(score.toString());
  }

  void filterData() async {
    log(score.toString());
    // log("group hai" + group);
    var x = [];

    if (round == 1) {
      x = List.from(
          score.where((element) => element['group'] == CurrentUser.userGRP));
    } else {
      x = score;
    }
    x.sort((a, b) => b['score'].compareTo(a['score']));
    setState(() {
      score = x;
    });
    log(x.toString());
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
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
                          round == 1
                              ? "Leaderboard Round 1 Group $group"
                              : "Leaderboard Round 2",
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
                // color: Colors.orange,
                // height: 400,
                height: h - 100,
                child: ListView.builder(
                    itemCount: score.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: const Icon(Icons.auto_graph),
                        trailing: Text(
                          "Rank ${index + 1}",
                          style: TextStyle(color: Colors.green, fontSize: 15),
                        ),
                        title: Text(score[index]['name']),
                        subtitle:
                            Text("Score: " + score[index]['score'].toString()),
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
