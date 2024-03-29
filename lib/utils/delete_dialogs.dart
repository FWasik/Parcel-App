import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:parcel_app/bloc/package/package_bloc.dart';
import 'package:parcel_app/bloc/font/font_bloc.dart';
import 'package:parcel_app/bloc/auth/auth_bloc.dart';
import 'package:parcel_app/models/package.dart';
import 'package:parcel_app/screens/sign_in.dart';

class DeleteDialogs {
  static Future<bool?> showDeletePackageDialog(
      BuildContext context, List<Package> packages, String type) async {
    var appLoc = AppLocalizations.of(context)!;
    return showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BlocBuilder<FontBloc, FontState>(builder: (context, stateFont) {
          return AlertDialog(
            title: Text(appLoc.deletePackage,
                style: TextStyle(fontSize: 20 * stateFont.resize)),
            content: SingleChildScrollView(
              child: Text(
                appLoc.askDeletePackage,
                style: TextStyle(fontSize: 16 * stateFont.resize),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(appLoc.cancel,
                    style: TextStyle(fontSize: 16 * stateFont.resize)),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text(
                  appLoc.confirm,
                  style: TextStyle(
                      color: Colors.red, fontSize: 16 * stateFont.resize),
                ),
                onPressed: () {
                  context
                      .read<PackageBloc>()
                      .add(DeletePackagesRequested(packages, type));

                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
      },
    );
  }

  static Future<void> showDeleteUserDialog(BuildContext context) async {
    var appLoc = AppLocalizations.of(context)!;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BlocBuilder<FontBloc, FontState>(builder: (context, stateFont) {
          return AlertDialog(
            title: Text(appLoc.deleteUser,
                style: TextStyle(fontSize: 24 * stateFont.resize)),
            content: SingleChildScrollView(
              child: Text(
                appLoc.askDeleteUser,
                style: TextStyle(fontSize: 18 * stateFont.resize),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(appLoc.cancel,
                    style: TextStyle(fontSize: 18 * stateFont.resize)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  appLoc.confirm,
                  style: TextStyle(
                      color: Colors.red, fontSize: 18 * stateFont.resize),
                ),
                onPressed: () {
                  context.read<AuthBloc>().add(DeleteUserRequested(
                      FirebaseAuth.instance.currentUser!.uid));

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const SignIn()),
                      (route) => false);
                },
              ),
            ],
          );
        });
      },
    );
  }
}
