import 'package:fanapp/currentuser.dart';
import 'package:fanapp/data/firebase_helper.dart';
import 'package:fanapp/screens/home.dart';
import 'package:fanapp/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
      );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<bool>(
          future: showLoginPage(),
          builder: (buildContext, snapshot) {
            print("data hai " + snapshot.data.toString());
            if (snapshot.hasData) {
              if (snapshot.data == false) {
                return const Login();
              }

              return const Home();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

Future<bool> showLoginPage() async {
  // SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool("isLogged") != true) {
    print(false);
    return false;
  } else {
    print(true);
    CurrentUser.id = prefs.getString("teamName")!;
    await updateTeamData();

    return true;
  }
}
