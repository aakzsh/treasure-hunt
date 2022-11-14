import 'package:flutter/material.dart';

import 'colors.dart';

Widget btnWidget(String title,{ Function()? callback}) {
  return MaterialButton(
    color: MyColors.GreenColor,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    onPressed: callback,
    child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
        child: Text(title)),
  );
}
