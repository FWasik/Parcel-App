import 'package:flutter/material.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text, Color? color) {
    if (text == null) return;

    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: color,
      action: SnackBarAction(
        label: "Dissmiss",
        textColor: Colors.yellow,
        onPressed: () {},
      ),
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
