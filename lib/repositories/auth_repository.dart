import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parcel_app/models/custom_user.dart';

import 'package:parcel_app/utils/utils.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<void> signUp({
    required String email,
    required String password,
    required String phoneNumber,
    String? fullName,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final String uid = user!.uid;

      await FirebaseFirestore.instance.collection("Users").doc(uid).set({
        "uid": uid,
        "email": email,
        "phoneNumber": phoneNumber,
        "fullName": fullName
      });

      await FirebaseAuth.instance.signOut();

      Utils.showSnackBar('You successful signed up!', Colors.green);
    } on FirebaseAuthException catch (e) {
      print(e);

      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      Utils.showSnackBar('You successful signed in!', Colors.green);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();

      Utils.showSnackBar('You successful signed out!', Colors.green);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateUserInfo({
    required String uid,
    required String email,
    required String phoneNumber,
    required String fullName,
  }) async {
    User user = FirebaseAuth.instance.currentUser!;
    await user.updateEmail(email);

    await FirebaseFirestore.instance.collection('Users').doc(uid).update(
        {'email': email, "phoneNumber": phoneNumber, 'fullName': fullName});

    Utils.showSnackBar("You successful updated profile!", Colors.green);
  }

  Future<void> deleteUser({required String uid}) async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      await user.delete();

      await FirebaseFirestore.instance.collection("Users").doc(uid).delete();

      Utils.showSnackBar("You successful deleted an account!", Colors.green);
    } on FirebaseAuthException catch (e) {
      print(e);

      throw Exception(e.message);
    } on Exception catch (e) {
      print(e);

      await FirebaseAuth.instance.signOut();
      throw Exception(e);
    }
  }

  Future<CustomUser?> getUserInfo(String uid) async {
    CustomUser user;
    //String uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      final data =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      print(data.data() as Map<String, dynamic>);
      user = CustomUser.fromJson(data.data() as Map<String, dynamic>);

      return user;
    } catch (e) {
      await FirebaseAuth.instance.signOut();
      throw Exception(e);
    }
  }

  Future resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      Utils.showSnackBar("Email sent!", Colors.green);
    } on FirebaseAuthException catch (e) {
      print(e);

      throw Exception(e.message);
    }
  }
}
