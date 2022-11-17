import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanapp/currentuser.dart';
import 'package:fanapp/data/firebase_helper.dart';

import 'package:fanapp/screens/home.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../extras/colors.dart';
import '../extras/snackbar.dart';
import '../extras/widgets.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final teamNameC = TextEditingController();
  final passKeyC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 12, 12, 12),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
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
              "Treasure Hunt",
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24.0)),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: teamNameC,
                cursorColor: MyColors.GreenColor,
                style: const TextStyle(fontSize: 14.0),
                decoration: InputDecoration(
                    hintText: "Team id",
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            width: 1.0, color: MyColors.GreenColor)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            width: 1.0, color: MyColors.GreenColor))),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: passKeyC,
                cursorColor: MyColors.GreenColor,
                style: const TextStyle(fontSize: 14.0),
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Pass key",
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            width: 1.0, color: MyColors.GreenColor)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            width: 1.0, color: MyColors.GreenColor))),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: btnWidget(
                  "Login",
                  callback: () async {
                    if (teamNameC.text.isNotEmpty && passKeyC.text.isNotEmpty) {
                      var data = await FirebaseFirestore.instance
                          .collection("teams")
                          .doc(teamNameC.text)
                          .get();
                      if (data.exists) {
                        print("exists");

                        if (data.data()!['passkey'] == passKeyC.text) {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool("isLogged", true);
                          await prefs.setString("teamName", teamNameC.text);
                          CurrentUser.id = data.data()!['id'];
                          await updateTeamData();
                          // var hehe = await prefs.getBool("isLogged");
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const Home())),
                              (route) => false);
                        } else {
                          ShowSnackBar("Incorrect Password", context);
                        }
                      } else {
                        ShowSnackBar("User Doesn't Exist", context);
                      }
                    } else {
                      ShowSnackBar(
                          "Please fill username and password", context);
                    }
                  },
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
