
import 'package:fanapp/main.dart';
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

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const Text(
                "Round 1",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24.0,
                    color: MyColors.GreenColor,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Team XYZ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Current Points - 5",
                textAlign: TextAlign.center,
                style: TextStyle(
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
              btnWidget("Scan QR Code", callback: () {
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
