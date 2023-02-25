import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:parcel_app/bloc/font/font_bloc.dart';
import 'package:parcel_app/bloc/package/package_bloc.dart';
import 'package:parcel_app/bloc/theme/theme_bloc.dart';
import 'package:parcel_app/screens/google_search_parcel.dart';
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
  bool isReceived = false;
  bool showCheckboxes = false;
  List<Package> checkedPackages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<PackageBloc, PackageState>(
        builder: (contextPackage, statePackage) {
      if (statePackage is LoadingPackages) {
        return CustomCircularProgressIndicator(
            color: Theme.of(context).primaryColor);
      } else if (statePackage is Fetched) {
        List<Package> filteredData = statePackage.packages
            .where((element) => element.isReceived == isReceived)
            .toList();

        var appLoc = AppLocalizations.of(context)!;

        if (statePackage.packages.isEmpty) {
          return NoDataFound(additionalText: appLoc.additionalTextReceived);
        } else {
          return BlocBuilder<FontBloc, FontState>(
              builder: (contextFont, stateFont) {
            return BlocBuilder<ThemeBloc, ThemeState>(
                builder: (contextTheme, stateTheme) {
              return Column(children: [
                if (checkedPackages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomPackageButton(
                          onPressed: () async {
                            bool? isDeleted =
                                await DeleteDialogs.showDeletePackageDialog(
                                    context,
                                    checkedPackages.toList(),
                                    statePackage.type);

                            if (isDeleted == true) {
                              setState(() {
                                checkedPackages.clear();
                                showCheckboxes = false;
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.delete,
                            size: 28,
                          ),
                          color: Colors.red,
                        ),
                        CustomPackageButton(
                            onPressed: () {
                              setState(() {
                                checkedPackages = filteredData.toList();
                              });
                            },
                            icon: const Icon(
                              Icons.check_outlined,
                              size: 28,
                            ),
                            color: stateTheme.checkboxColor),
                        CustomPackageButton(
                          onPressed: () {
                            setState(() {
                              checkedPackages.clear();
                              showCheckboxes = false;
                            });
                          },
                          icon: const Icon(
                            Icons.close,
                            size: 28,
                          ),
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SwitchGesture(
                        text: appLoc.nonReceived,
                        onTap: () {
                          setState(() {
                            isReceived = false;
                            checkedPackages.clear();
                            showCheckboxes = false;
                          });
                        },
                        selected: isReceived == false,
                        size: 20 * stateFont.resize,
                      ),
                      SwitchGesture(
                        text: appLoc.received,
                        onTap: () {
                          setState(() {
                            isReceived = true;
                            checkedPackages.clear();
                            showCheckboxes = false;
                          });
                        },
                        selected: isReceived,
                        size: 20 * stateFont.resize,
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: (filteredData.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredData.length,
                            itemBuilder: (_, index) {
                              return GestureDetector(
                                onLongPress: () {
                                  setState(() {
                                    showCheckboxes = true;
                                    checkedPackages.add(filteredData[index]);
                                  });
                                },
                                child: Card(
                                  elevation: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ListTile(
                                              leading: showCheckboxes
                                                  ? Checkbox(
                                                      activeColor: stateTheme
                                                          .checkboxColor,
                                                      value: checkedPackages
                                                          .contains(
                                                              filteredData[
                                                                  index]),
                                                      onChanged: (value) {
                                                        if (value == true) {
                                                          setState(() {
                                                            checkedPackages.add(
                                                                filteredData[
                                                                    index]);
                                                          });
                                                        } else {
                                                          setState(() {
                                                            checkedPackages
                                                                .remove(
                                                                    filteredData[
                                                                        index]);
                                                          });
                                                        }

                                                        if (checkedPackages
                                                            .isEmpty) {
                                                          showCheckboxes =
                                                              false;
                                                        }
                                                      },
                                                    )
                                                  : null,
                                              title: SelectableText(
                                                  appLoc.packageNumber(
                                                      filteredData[index].id),
                                                  style: TextStyle(
                                                      fontSize: 18 *
                                                          stateFont.resize)),
                                              subtitle: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 20),
                                                    Text(
                                                        appLoc.sender(
                                                            filteredData[index]
                                                                .fullName),
                                                        style: TextStyle(
                                                            fontSize: 14 *
                                                                stateFont
                                                                    .resize)),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                        appLoc.senderPhoneNumber(
                                                            filteredData[index]
                                                                .phoneNumber),
                                                        style: TextStyle(
                                                            fontSize: 14 *
                                                                stateFont
                                                                    .resize)),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                        appLoc.senderEmail(
                                                            filteredData[index]
                                                                .emailSender),
                                                        style: TextStyle(
                                                            fontSize: 14 *
                                                                stateFont
                                                                    .resize)),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                        appLoc.parcelMachineAddressSend(
                                                            filteredData[index]
                                                                .addressToSend),
                                                        style: TextStyle(
                                                            fontSize: 14 *
                                                                stateFont
                                                                    .resize)),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                        appLoc.parcelMachineAddressReceive(
                                                            filteredData[index]
                                                                .addressToReceive),
                                                        style: TextStyle(
                                                            fontSize: 14 *
                                                                stateFont
                                                                    .resize)),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                        appLoc.createdAndSent(
                                                            filteredData[index]
                                                                .timeCreated),
                                                        style: TextStyle(
                                                            fontSize: 14 *
                                                                stateFont
                                                                    .resize)),
                                                  ]),
                                              trailing: (!isReceived
                                                  ? CustomAcceptPackageButton(
                                                      onPressed: () {
                                                        context
                                                            .read<PackageBloc>()
                                                            .add(AcceptPackagesRequested(
                                                                filteredData[
                                                                    index],
                                                                filteredData[
                                                                        index]
                                                                    .uidSender,
                                                                "received"));

                                                        setState(() {
                                                          checkedPackages
                                                              .clear();
                                                          showCheckboxes =
                                                              false;
                                                        });
                                                      },
                                                    )
                                                  : CustomPackageButton(
                                                      onPressed: () async {
                                                        await DeleteDialogs
                                                            .showDeletePackageDialog(
                                                                context,
                                                                [
                                                                  filteredData[
                                                                      index]
                                                                ],
                                                                statePackage
                                                                    .type);

                                                        if (filteredData
                                                                .isEmpty &&
                                                            showCheckboxes ==
                                                                true) {
                                                          setState(() {
                                                            showCheckboxes =
                                                                false;
                                                            checkedPackages
                                                                .clear();
                                                          });

                                                          var x = ';';
                                                        }
                                                      },
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        size: 28,
                                                      ),
                                                      color: Colors.red,
                                                    ))),
                                          const SizedBox(height: 20),
                                          CustomButton(
                                              width: 0.7,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              icon: const Icon(
                                                  Icons.local_shipping,
                                                  size: 32),
                                              text: Text(
                                                appLoc.addressButton,
                                                style: TextStyle(
                                                    fontSize:
                                                        18 * stateFont.resize),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      GoogleSearchParcelPage(
                                                    parcelAddress:
                                                        filteredData[index]
                                                            .addressToReceive,
                                                  ),
                                                ));
                                              }),
                                        ]),
                                  ),
                                ),
                              );
                            })
                        : NoDataFound(
                            additionalText: (isReceived
                                ? appLoc.filterReceivedEmpty
                                : appLoc.filterNonReceivedEmpty))))
              ]);
            });
          });
        }
      } else {
        return Container();
      }
    }));
  }
}
