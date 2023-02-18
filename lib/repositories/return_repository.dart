import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parcel_app/l10n/localization.dart';
import 'package:parcel_app/models/return.dart';
import 'package:parcel_app/utils/utils.dart';

class ReturnRepository with Localization {
  Future<List<Return>> fetchReturns() async {
    List<Return> returns = [];

    final User user = FirebaseAuth.instance.currentUser!;

    final data = await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .collection("Returns")
        .get();

    data.docs.forEach((element) async {
      var data = element.data();
      data['id'] = element.reference.id.toString();

      DateTime timeCreated =
          DateTime.parse(data['timeCreated'].toDate().toString());

      data['timeCreated'] =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(timeCreated);

      return returns.add(Return.fromJson(data));
    });

    returns.sort((a, b) {
      return b.timeCreated.compareTo(a.timeCreated);
    });

    return returns;
  }

  Future<void> createReturn(
      {required String packageId,
      required String type,
      required String descritpion}) async {
    final User user = FirebaseAuth.instance.currentUser!;

    final isPackage = await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .collection("Packages")
        .doc(packageId)
        .get();

    if (isPackage.data() == null) {
      throw Exception(loc.noPackageWithNumber);
    } else if (!isPackage.data()!["isReceived"] ||
        isPackage.data()!["uidReceiver"] != user.uid) {
      throw Exception(loc.cannotBeReturn);
    }

    final isReturn = await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .collection("Returns")
        .where("packageId", isEqualTo: packageId)
        .get();

    if (isReturn.docs.isNotEmpty) {
      throw Exception(loc.alreadyReturn);
    }
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .collection("Returns")
        .doc()
        .set({
      "packageId": packageId,
      "type": type,
      "description": descritpion,
      "timeCreated": DateTime.now().toLocal(),
    });

    Utils.showSnackBar(loc.createdReturn, Colors.green, loc.dissmiss);
  }
}
