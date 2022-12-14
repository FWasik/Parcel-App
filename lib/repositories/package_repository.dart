import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:parcel_app/models/custom_user.dart';
import 'package:parcel_app/models/package.dart';
import 'package:parcel_app/utils/utils.dart';
import 'package:parcel_app/repositories/auth_repository.dart';

class PackageRepository {
  final AuthRepository authRepository;

  PackageRepository({required this.authRepository});

  Future<List<Package>> fetchPackages(String type) async {
    List<Package> packages = [];

    try {
      final User user = FirebaseAuth.instance.currentUser!;
      String senderOrReceiver = '';

      if (type == 'sent') {
        senderOrReceiver = 'uidSender';
      } else if (type == 'received') {
        senderOrReceiver = 'uidReceiver';
      }

      final data = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .collection("Packages")
          .where(senderOrReceiver, isEqualTo: user.uid)
          .get();

      data.docs.forEach(((element) async {
        var data = element.data();
        data['id'] = element.reference.id.toString();

        DateTime timeCreated =
            DateTime.parse(data["timeCreated"].toDate().toString());

        data['timeCreated'] =
            DateFormat('yyyy-MM-dd – kk:mm').format(timeCreated);

        return packages.add(Package.fromJson(data));
      }));

      packages.sort(
        (a, b) {
          return b.timeCreated.compareTo(a.timeCreated);
        },
      );

      return packages;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> createPackage(
      {required String email,
      required String phoneNumber,
      required String fullName,
      required String address}) async {
    final User user = FirebaseAuth.instance.currentUser!;

    try {
      final data = await FirebaseFirestore.instance
          .collection("Users")
          .where("email", isEqualTo: email)
          .where("phoneNumber", isEqualTo: phoneNumber)
          .where("fullName", isEqualTo: fullName)
          .get();

      CustomUser receiver = data.docs.map((element) {
        return CustomUser.fromJson(element.data());
      }).toList()[0];
      final sender = await authRepository.getUserInfo(user.uid);

      if (sender!.email == receiver.email) {
        throw Exception("Cannot send package to yourself!");
      }

      // sender
      createPackageInFirestore(user.uid, user.uid, receiver.uid,
          receiver.fullName, receiver.phoneNumber, address);

      //receiver
      createPackageInFirestore(receiver.uid, user.uid, receiver.uid,
          sender.fullName, sender.phoneNumber, address);

      Utils.showSnackBar("Package created and sent!", Colors.green);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deletePackage({required String id}) async {
    final User user = FirebaseAuth.instance.currentUser!;

    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .collection("Packages")
          .doc(id)
          .delete();

      Utils.showSnackBar("Package deleted!", Colors.green);
    } catch (e) {
      throw Exception(e);
    }
  }

  void createPackageInFirestore(
      String doc,
      String uidSender,
      String uidReceiver,
      String fullName,
      String phoneNumber,
      String address) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(doc)
        .collection("Packages")
        .doc()
        .set({
      "uidSender": uidSender,
      "uidReceiver": uidReceiver,
      "fullName": fullName,
      "phoneNumber": phoneNumber,
      "address": address,
      "timeCreated": DateTime.now().toLocal(),
    });
  }
}
