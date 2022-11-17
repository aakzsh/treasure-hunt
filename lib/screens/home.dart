import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanapp/currentuser.dart';
import 'package:fanapp/data/firebase_helper.dart';
import 'package:fanapp/data/questions.dart';
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
    //print("isout"+ CurrentUser.isOut.toString());
    /* if (CurrentUser.isOut) {
     // print("disqualified");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: ((context) => Disqualification())),
          (route) => false);
    }*/
    getRound();
    /*getTeamData();
    setDetails();*/

    super.initState();
  }

  Future<bool> isOut() async {
    bool isout = false;
    await ins.collection("teams").doc(CurrentUser.id).get().then((value) => {
          isout = value.data()!['isOut'],
        });
    return isout;
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
    print("group$group");
    ins
        .collection("questions")
        .doc(group)
        .get()
        .then((value) => {
              print("xyz${value.data()}"),
              setState(() {
                questions = value.data();
              })
            })
        .then((value) => {log(questions.toString())});
  }

  void getTeamData() async {
    var prefs = await SharedPreferences.getInstance();
    var tn = prefs.getString("teamName");
    print("tn hai$tn");
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
      body: FutureBuilder<int>(
          future: updateTeamData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                if (snapshot.data == 200) {
                  return SingleChildScrollView(
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
                              SizedBox(
                                  height: 200,
                                  child: Image.asset("assets/levi2.png")),
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
                            "Team ${CurrentUser.userName}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Current Points - ${CurrentUser.score}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 20),
                          CurrentUser.level <= 4
                              ? Text("Next Clue - \n" + getQuestion()['clue'])
                              : Text(
                                  "Congratulations! You have cleared all the questions"),
                          const SizedBox(height: 20),
                          btnWidget("Leaderboard", callback: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        const Leaderboard())));
                          }),
                          const SizedBox(height: 20),
                          btnWidget("Scan QR Code", callback: () async {
                            if (CurrentUser.level <= 4) {
                              bool out = await isOut();
                              if (out) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            Disqualification())),
                                    (route) => false);
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const QRScanner())));
                              }
                            } else {
                              ShowSnackBar(
                                  "All Questions Done! Nothing to Scan more",
                                  context);
                            }
                          }),
                          const SizedBox(height: 20),
                          btnWidget("Logout", callback: () async {
                            var prefs = await SharedPreferences.getInstance();
                            await prefs.setBool("isLogged", false);
                            await prefs.setString("teamName", "");
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyApp()),
                                (route) => false);
                          }),
                        ],
                      ),
                    )),
                  );
                } else {
                  return Center(
                      child: Column(
                    children: [
                      Text('Something went wrong! Please try again'),
                      btnWidget("Retry", callback: () {
                        setState(() {});
                      })
                    ],
                  ));
                }
              } else {
                return Container();
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(
                  child: Column(
                children: [
                  Text('Something went wrong! Please try again'),
                  btnWidget("Retry", callback: () {
                    setState(() {});
                  })
                ],
              ));
            }
          }),
    );
  }

  Map<dynamic, dynamic> getQuestion() {
    switch (CurrentUser.userGRP) {
      case "A":
        return round1gA[CurrentUser.level];
      case "B":
        return round1gB[CurrentUser.level];
      case "C":
        return round1gC[CurrentUser.level];
      case "D":
        return round1gD[CurrentUser.level];
      case "E":
        return round1gE[CurrentUser.level];
      default:
        return round1gA[CurrentUser.level];
    }
  }
}
