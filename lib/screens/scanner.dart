import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanapp/extras/colors.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as mobile;
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../currentuser.dart';
import '../data/questions.dart';
import 'home.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controllery;
  bool scanned = false;
  bool checkingans = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Column(
            children: <Widget>[
              Container(
                color: Color.fromARGB(255, 12, 12, 12),
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      Text(
                        "ATTACK ON INFOX",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 24.0,
                            color: MyColors.GreenColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "QR Code Scanner",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
              ),
              Expanded(
                  child: Stack(
                children: [
                  mobile.MobileScanner(
                      allowDuplicates: false,
                      onDetect: (barcode, args) {
                        if (barcode.rawValue != null) {
                          if (scanned == false) {
                            showQRScanned(barcode.rawValue!);
                            scanned = true;
                          }
                        }
                      }),
                ],
              )),
              // Expanded(
              //   flex: 5,
              //   child: QRView(
              //     key: qrKey,
              //     onQRViewCreated: _onQRViewCreated,
              //   ),
              // ),
            ],
          ),
          Visibility(
            visible: checkingans,
            child: Container(
              color: Colors.black12,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: CircularProgressIndicator(
                  color: MyColors.GreenColor,
                ),
              ),
            ),
          )
        ],
      )),
    );
  }

  Future<bool> checkAnswer(String ans) async {
    if (ans == getQuestion()['code']) {
      //increase points and level'
      await FirebaseFirestore.instance
          .collection('teams')
          .doc(CurrentUser.id)
          .update({
            'level': FieldValue.increment(1),
            'score': FieldValue.increment(5)
          })
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));

      return true;
    } else {
      //decrease points
      await FirebaseFirestore.instance
          .collection('teams')
          .doc(CurrentUser.id)
          .update({'score': FieldValue.increment(-2)})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));

      return false;
    }
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

  Future<bool> showQRScanned(String ans) async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text('QR SCANNED'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Do you want to submit the scanned QR as the answer?',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  ans,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            actions: [
              MaterialButton(
                onPressed: () =>
                    {Navigator.of(context).pop(false), scanned = false},

                //return false when click on "NO"
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.black),
                ),
                color: Colors.white,
              ),
              MaterialButton(
                onPressed: () async => {
                  setState(() {
                    checkingans = true;
                  }),
                  await checkAnswer(ans),
                  setState(() {
                    checkingans = false;
                  }),
                  Navigator.of(context).pop(true),
                  scanned = false,
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: ((context) => const Home())),
                      (route) => false)
                },
                //return true when click on "Yes"
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.white),
                ),
                color: MyColors.GreenColor,
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  /*void x(QRViewController controllery) {}

  void _onQRViewCreated(QRViewController controllery) {
    // this.controller = controllery;
    controllery.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }*/

  // @override
  // void dispose() {
  //   controller?.dispose();
  //   super.dispose();
  // }
}
