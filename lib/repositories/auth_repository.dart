import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parcel_app/models/custom_user.dart';

import 'package:parcel_app/utils/utils.dart';
import 'package:parcel_app/l10n/localization.dart';

class AuthRepository with Localization {
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

      Utils.showSnackBar(loc.signedUp, Colors.green, loc.dissmiss);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception(loc.emailUse);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      Utils.showSnackBar(loc.signedIn, Colors.green, loc.dissmiss);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw Exception(loc.invalidCredentials);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();

      Utils.showSnackBar(loc.signedOut, Colors.green, loc.dissmiss);
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

    Utils.showSnackBar(loc.updated, Colors.green, loc.dissmiss);
  }

  Future<void> deleteUser({required String uid}) async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      await user.delete();

      await FirebaseFirestore.instance.collection("Users").doc(uid).delete();

      Utils.showSnackBar(loc.deletedUser, Colors.green, loc.dissmiss);
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

    try {
      final data =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();

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

      Utils.showSnackBar(loc.emailSent, Colors.green, loc.dissmiss);
    } on FirebaseAuthException catch (e) {
      print(e);

      throw Exception(e.message);
    }
  }
}
