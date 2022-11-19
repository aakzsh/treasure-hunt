import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanapp/extras/snackbar.dart';
import 'package:fanapp/extras/widgets.dart';
import 'package:flutter/material.dart';

class New extends StatefulWidget {
  const New({super.key});

  @override
  State<New> createState() => _NewState();
}

class _NewState extends State<New> {
  var ins = FirebaseFirestore.instance;
  TextEditingController nameCont = TextEditingController(),
      passkey = TextEditingController(),
      group = TextEditingController(),
      id = TextEditingController();
  void addToDb() async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(hintText: "Teamname"),
              controller: nameCont,
            ),
            TextField(
              decoration: InputDecoration(hintText: "id"),
              controller: id,
            ),
            TextField(
              decoration: InputDecoration(hintText: "passkey"),
              controller: passkey,
            ),
            TextField(
              decoration: InputDecoration(hintText: "group"),
              controller: group,
            ),
            btnWidget(
              "Add",
              callback: () async {
                // print(name.text);
                ins
                    .collection("teams")
                    .doc(id.text)
                    .set({
                      "group": group.text,
                      "id": id.text,
                      "isOut": false,
                      "level": 1,
                      "name": nameCont.text,
                      "passkey": passkey.text,
                      "score": 0,
                    })
                    .then((value) => {ShowSnackBar("done", context)})
                    .catchError((err) {
                      ShowSnackBar(err.toString(), context);
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
