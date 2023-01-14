import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:parcel_app/bloc/font/font_bloc.dart';
import 'package:parcel_app/bloc/package/package_bloc.dart';
import 'package:parcel_app/widgets/button_widget.dart';
import 'package:parcel_app/widgets/no_data_found_widget.dart';
import 'package:parcel_app/widgets/progress_widget.dart';
import 'package:parcel_app/models/package.dart';
import 'package:parcel_app/widgets/switch_gesture.dart';
import 'package:parcel_app/utils/delete_dialogs.dart';

class PackagesReceivedPage extends StatefulWidget {
  const PackagesReceivedPage({Key? key}) : super(key: key);

  @override
  State<PackagesReceivedPage> createState() => _PackagesReceivedPageState();
}

class _PackagesReceivedPageState extends State<PackagesReceivedPage> {
  bool _isReceived = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<PackageBloc, PackageState>(builder: (context, state) {
      if (state is LoadingPackages || state is Deleted || state is Accepted) {
        return CustomCircularProgressIndicator(
            color: Theme.of(context).primaryColor);
      } else if (state is Fetched) {
        List<Package> filteredData = state.packages
            .where((element) => element.isReceived == _isReceived)
            .toList();
        var appLoc = AppLocalizations.of(context)!;

        if (state.packages.isEmpty) {
          return NoDataFound(additionalText: appLoc.additionalTextReceived);
        } else {
          return BlocBuilder<FontBloc, FontState>(
              builder: (context, stateFont) {
            return Column(children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SwitchGesture(
                      text: appLoc.nonReceived,
                      onTap: () {
                        setState(() {
                          _isReceived = false;
                        });
                      },
                      selected: _isReceived == false,
                      size: 20 * stateFont.resize,
                    ),
                    SwitchGesture(
                      text: appLoc.received,
                      onTap: () {
                        setState(() {
                          _isReceived = true;
                        });
                      },
                      selected: _isReceived,
                      size: 20 * stateFont.resize,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (_, index) {
                      return Card(
                        elevation: 10,
                        child: ListTile(
                          title: Text(
                              appLoc.packageNumber(filteredData[index].id),
                              style:
                                  TextStyle(fontSize: 18 * stateFont.resize)),
                          subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                    appLoc.sender(filteredData[index].fullName),
                                    style: TextStyle(
                                        fontSize: 14 * stateFont.resize)),
                                const SizedBox(height: 10),
                                Text(
                                    appLoc.senderPhoneNumber(
                                        filteredData[index].phoneNumber),
                                    style: TextStyle(
                                        fontSize: 14 * stateFont.resize)),
                                const SizedBox(height: 10),
                                Text(
                                    appLoc.senderEmail(
                                        filteredData[index].emailSender),
                                    style: TextStyle(
                                        fontSize: 14 * stateFont.resize)),
                                const SizedBox(height: 10),
                                Text(
                                    appLoc.parcelMachineAddressReceive(
                                        filteredData[index].address),
                                    style: TextStyle(
                                        fontSize: 14 * stateFont.resize)),
                                const SizedBox(height: 10),
                                Text(
                                    appLoc.createdAndSent(
                                        filteredData[index].timeCreated),
                                    style: TextStyle(
                                        fontSize: 14 * stateFont.resize)),
                              ]),
                          trailing: (!_isReceived
                              ? CustomAcceptPackageButton(
                                  onPressed: () {
                                    context.read<PackageBloc>().add(
                                        AcceptRequested(
                                            filteredData[index],
                                            filteredData[index].uidSender,
                                            "received"));
                                  },
                                )
                              : CustomDeletePackageButton(onPressed: () {
                                  DeleteDialogs.showDeletePackageDialog(context,
                                      filteredData[index].id, state.type);
                                })),
                        ),
                      );
                    }),
              ),
            ]);
          });
        }
      } else {
        return Container();
      }
    }));
  }
}
