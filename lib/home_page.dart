import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parcel_app/profile_info_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Padding(
        padding: EdgeInsets.all(32),
        child: ProfileInfo(),
      ),
    );
  }
}
