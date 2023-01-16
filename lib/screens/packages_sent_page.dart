import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcel_app/bloc/font/font_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:parcel_app/bloc/package/package_bloc.dart';
import 'package:parcel_app/screens/google_search_parcel.dart';
import 'package:parcel_app/screens/send_package_page.dart';
import 'package:parcel_app/widgets/button_widget.dart';
import 'package:parcel_app/widgets/no_data_found_widget.dart';
import 'package:parcel_app/widgets/progress_widget.dart';
import 'package:parcel_app/models/package.dart';
import 'package:parcel_app/widgets/switch_gesture.dart';
import 'package:parcel_app/utils/delete_dialogs.dart';

class PackagesSentPage extends StatefulWidget {
  const PackagesSentPage({Key? key}) : super(key: key);

  @override
  State<PackagesSentPage> createState() => _PackagesSentPageState();
}

class _PackagesSentPageState extends State<PackagesSentPage> {
  bool _isReceived = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
            onPressed: (() {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SendPackagePage(),
              ));
            }),
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            )),
        body: BlocBuilder<PackageBloc, PackageState>(builder: (context, state) {
          if (state is LoadingPackages ||
              state is Deleted ||
              state is Accepted) {
            return CustomCircularProgressIndicator(
                color: Theme.of(context).primaryColor);
          } else if (state is Fetched) {
            List<Package> filteredData = state.packages
                .where((element) => element.isReceived == _isReceived)
                .toList();
            var appLoc = AppLocalizations.of(context)!;

            if (state.packages.isEmpty) {
              return NoDataFound(additionalText: appLoc.additionalTextSent);
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
                            size: 20 * stateFont.resize),
                        SwitchGesture(
                            text: appLoc.received,
                            onTap: () {
                              setState(() {
                                _isReceived = true;
                              });
                            },
                            selected: _isReceived,
                            size: 20 * stateFont.resize),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (_, index) {
                          return Card(
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ListTile(
                                      title: SelectableText(
                                        appLoc.packageNumber(
                                            filteredData[index].id),
                                        style: TextStyle(
                                            fontSize: 18 * stateFont.resize),
                                      ),
                                      subtitle: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 20),
                                            Text(
                                              appLoc.receiver(
                                                  filteredData[index].fullName),
                                              style: TextStyle(
                                                  fontSize:
                                                      14 * stateFont.resize),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              appLoc.receiverPhoneNumber(
                                                  filteredData[index]
                                                      .phoneNumber),
                                              style: TextStyle(
                                                  fontSize:
                                                      14 * stateFont.resize),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              appLoc.receiverEmail(
                                                  filteredData[index]
                                                      .emailReceiver),
                                              style: TextStyle(
                                                  fontSize:
                                                      14 * stateFont.resize),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                                appLoc.parcelMachineAddressSend(
                                                    filteredData[index]
                                                        .addressToSend),
                                                style: TextStyle(
                                                    fontSize:
                                                        14 * stateFont.resize)),
                                            const SizedBox(height: 10),
                                            Text(
                                              appLoc
                                                  .parcelMachineAddressReceive(
                                                      filteredData[index]
                                                          .addressToReceive),
                                              style: TextStyle(
                                                  fontSize:
                                                      14 * stateFont.resize),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              appLoc.createdAndSent(
                                                  filteredData[index]
                                                      .timeCreated),
                                              style: TextStyle(
                                                  fontSize:
                                                      14 * stateFont.resize),
                                            ),
                                          ]),
                                      trailing: CustomDeletePackageButton(
                                          onPressed: () {
                                        // _showDeletePackageDialog(context,
                                        //     filteredData[index].id, state.type);
                                        DeleteDialogs.showDeletePackageDialog(
                                            context,
                                            filteredData[index].id,
                                            state.type);
                                      }),
                                    ),
                                    const SizedBox(height: 20),
                                    CustomButton(
                                        width: 0.7,
                                        color: Theme.of(context).primaryColor,
                                        icon: const Icon(Icons.local_shipping,
                                            size: 32),
                                        text: Text(
                                          appLoc.addressButton,
                                          style: TextStyle(
                                              fontSize: 18 * stateFont.resize),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                GoogleSearchParcelPage(
                                              parcelAddress: filteredData[index]
                                                  .addressToSend,
                                            ),
                                          ));
                                        }),
                                  ]),
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
