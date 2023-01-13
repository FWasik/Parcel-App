import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:parcel_app/bloc/package/package_bloc.dart';
import 'package:parcel_app/bloc/font/font_bloc.dart';

class DeleteDialogs {
  static Future<void> showDeletePackageDialog(
      BuildContext context, String id, String type) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BlocBuilder<FontBloc, FontState>(builder: (context, stateFont) {
          return AlertDialog(
            title: Text('Deleting a packge',
                style: TextStyle(fontSize: 18 * stateFont.resize)),
            content: SingleChildScrollView(
              child: Text(
                'Are you sure you want to delete this package from history?',
                style: TextStyle(fontSize: 14 * stateFont.resize),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel',
                    style: TextStyle(fontSize: 14 * stateFont.resize)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'Confirm',
                  style: TextStyle(
                      color: Colors.red, fontSize: 14 * stateFont.resize),
                ),
                onPressed: () {
                  context.read<PackageBloc>().add(DeleteRequested(id, type));

                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }
}
