import 'package:flutter/material.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text, Color? color, String dissmiss) {
    if (text == null) return;

    final snackBar = SnackBar(
      content: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      action: SnackBarAction(
        label: dissmiss,
        textColor: Colors.orangeAccent,
        onPressed: () {},
      ),
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
