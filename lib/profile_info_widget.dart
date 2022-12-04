import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parcel_app/utils.dart';

class ProfileInfo extends StatelessWidget {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder(
        future: getUserInfo(uid: uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic>? map = snapshot.data as Map<String, dynamic>?;
            String firstName = map?['firstName'];
            String lastName = map?["lastName"];
            String email = map?['email'];

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Sign in as", style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text(email,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                if (firstName != "")
                  Column(
                    children: [
                      SizedBox(height: 8),
                      Text(firstName,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                if (lastName != "")
                  Column(
                    children: [
                      SizedBox(height: 8),
                      Text(lastName,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                SizedBox(height: 40),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  icon: Icon(Icons.arrow_back, size: 32),
                  label: Text(
                    "Sign Out",
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: signOut,
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> getUserInfo({required String uid}) async {
    var data;
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .get()
          .then((DocumentSnapshot doc) {
        data = doc.data() as Map<String, dynamic>;
      });
    } catch (e) {
      print(e);

      Utils.showSnackBar("Error - contact administator", Colors.red);
      await FirebaseAuth.instance.signOut();
    }
    return data;
  }

  Future signOut() async {
    try {
      await FirebaseAuth.instance.signOut();

      Utils.showSnackBar("You have been signed out!", Colors.green);
    } on FirebaseAuthException catch (error) {
      print(error);

      Utils.showSnackBar(error.message, Colors.red);
    }
  }
}
