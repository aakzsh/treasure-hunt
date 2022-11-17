import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanapp/extras/snackbar.dart';
import 'package:fanapp/main.dart';
import 'package:fanapp/screens/disqualification.dart';
import 'package:fanapp/screens/leaderboard.dart';
import 'package:fanapp/screens/scanner.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../extras/colors.dart';
import '../extras/widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

String group = 'A';

class _HomeState extends State<Home> {
  var ins = FirebaseFirestore.instance;
  int round = 0, score = 0, level = 0;
  String teamname = "";
  var questions;
  @override
  void initState() {
    getRound();
    getTeamData();
    setDetails();

    super.initState();
  }

  Future<bool> isOut() async {
    bool isout = false;
    ins.collection("teams").doc(teamname).get().then((value) => {
          isout = value.data()!['isOut'],
          if (isout == true)
            {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: ((context) => Disqualification())),
                  (route) => false)
            }
        });
    return true;
  }

  void getRound() async {
    ins.collection("misc").doc("round").get().then((value) => {
          setState(() {
            round = value.data()!['round'];
          })
        });
  }

  void getQuestions() async {
    print("get questions pe hoon");
    print("group" + group);
    ins
        .collection("questions")
        .doc(group)
        .get()
        .then((value) => {
              print("xyz" + value.data().toString()),
              setState(() {
                questions = value.data();
              })
            })
        .then((value) => {log(questions.toString())});
  }

  void getTeamData() async {
    var prefs = await SharedPreferences.getInstance();
    var tn = prefs.getString("teamName");
    print("tn hai" + tn.toString());
    ins
        .collection("teams")
        .doc(tn.toString())
        .get()
        .then((value) => {
              if (value.data()!['isOut'] == true)
                {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => Disqualification())),
                      (route) => false)
                },
              setState(() {
                teamname = value.data()!['name'];
                group = value.data()!['group'];
                level = value.data()!['level'];
              })
            })
        .then((value) => {isOut(), getQuestions()});
    log(teamname.toString());
    log(group.toString());
    log(level.toString());
  }

  void setDetails() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("group", group);
    await prefs.setInt("round", round);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 12, 12, 12),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset("assets/infoxlogo.png"),
                  SizedBox(height: 200, child: Image.asset("assets/levi2.png")),
                  Positioned(
                    bottom: 0,
                    child: Text(
                      "Attack On \nInfox",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dancingScript(
                          textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 60.0,
                      )),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                "Round $round",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 24.0,
                    color: MyColors.GreenColor,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Team $teamname",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Current Points - $score",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                  "Next Clue - Cillum do in qui veniam pariatur fugiat do minim magna consectetur est consequat."),
              const SizedBox(height: 20),
              btnWidget("Leaderboard", callback: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const Leaderboard())));
              }),
              const SizedBox(height: 20),
              btnWidget("Scan QR Code", callback: () async {
                await isOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const QRScanner())));
              }),
              const SizedBox(height: 20),
              btnWidget("Logout", callback: () async {
                var prefs = await SharedPreferences.getInstance();
                await prefs.setBool("isLogged", false);
                await prefs.setString("teamName", "");
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                    (route) => false);
              }),
            ],
          ),
        )),
      ),
    );
  }
}
