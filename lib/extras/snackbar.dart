import 'package:flutter/material.dart';

void ShowSnackBar(String msg, BuildContext context, {Duration? duration}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    duration: duration ?? Duration(seconds: 2),
  ));
}
