import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanapp/currentuser.dart';

Future<int> updateTeamData() async {
  int code = 200;
  await FirebaseFirestore.instance
      .collection("teams")
      .doc(CurrentUser.id)
      .get()
      .then((value) => {
            print("isoutvalue" + value.data()!['isOut'].toString()),
            CurrentUser.userGRP = value.data()!['group'],
            CurrentUser.level = value.data()!['level'],
            CurrentUser.isOut = value.data()!['isOut'],
            CurrentUser.userName = value.data()!['name'],
            CurrentUser.score = value.data()!['score'],
            print("isoutvalue" + CurrentUser.isOut.toString()),
          })
      .catchError(() => code = 404);
  return code;
}
