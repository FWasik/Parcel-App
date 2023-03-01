import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcel_app/bloc/font/font_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:parcel_app/bloc/package/package_bloc.dart';
import 'package:parcel_app/bloc/theme/theme_bloc.dart';
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

class _PackagesSentPageState extends State<PackagesSentPage>
    with TickerProviderStateMixin {
  bool isReceived = false;
  bool showCheckboxes = false;
  List<Package> checkedPackages = [];
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

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
        body: BlocBuilder<PackageBloc, PackageState>(
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
              return NoDataFound(additionalText: appLoc.additionalTextSent);
            } else {
              return BlocBuilder<FontBloc, FontState>(
                  builder: (context, stateFont) {
                return BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (contextTheme, stateTheme) {
                  return Column(children: [
                    TabBar(
                      indicatorColor: Theme.of(context).primaryColor,
                      indicatorWeight: 5.0,
                      onTap: (tabController) {
                        setState(() {
                          if (tabController == 1) {
                            isReceived = true;
                          } else {
                            isReceived = false;
                          }
                          clearCheckboxes();
                        });
                      },
                      controller: tabController,
                      tabs: <Widget>[
                        CustomTab(
                            text: appLoc.nonReceived,
                            selected: isReceived == false,
                            size: 20 * stateFont.resize),
                        CustomTab(
                            text: appLoc.received,
                            selected: isReceived,
                            size: 20 * stateFont.resize)
                      ],
                    ),
                    if (checkedPackages.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomPackageButton(
                              onPressed: () async {
                                deletePackages(
                                    checkedPackages.toList(), statePackage);
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
                                clearCheckboxes();
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
                      Divider(
                        thickness: 5,
                        color: stateTheme.checkboxColor,
                      ),
                    ],
                    Expanded(
                        child: (filteredData.isNotEmpty
                            ? ListView.builder(
                                itemCount: filteredData.length,
                                itemBuilder: (_, index) {
                                  return Card(
                                    elevation: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ListTile(
                                              onTap: () {
                                                if (showCheckboxes == true) {
                                                  var value =
                                                      checkedPackages.contains(
                                                          filteredData[index]);
                                                  selectCheckbox(filteredData,
                                                      index, !value);
                                                } else {
                                                  setState(() {
                                                    showCheckboxes = true;
                                                    checkedPackages.add(
                                                        filteredData[index]);
                                                  });
                                                }
                                              },
                                              leading: showCheckboxes
                                                  ? Transform.scale(
                                                      scale: 1.5,
                                                      child: Checkbox(
                                                        activeColor: stateTheme
                                                            .checkboxColor,
                                                        value: checkedPackages
                                                            .contains(
                                                                filteredData[
                                                                    index]),
                                                        onChanged: (value) {
                                                          selectCheckbox(
                                                              filteredData,
                                                              index,
                                                              value);
                                                        },
                                                      ),
                                                    )
                                                  : null,
                                              title: SelectableText(
                                                appLoc.packageNumber(
                                                    filteredData[index].id),
                                                style: TextStyle(
                                                    fontSize:
                                                        18 * stateFont.resize),
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
                                                          filteredData[index]
                                                              .fullName),
                                                      style: TextStyle(
                                                          fontSize: 14 *
                                                              stateFont.resize),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      appLoc
                                                          .receiverPhoneNumber(
                                                              filteredData[
                                                                      index]
                                                                  .phoneNumber),
                                                      style: TextStyle(
                                                          fontSize: 14 *
                                                              stateFont.resize),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      appLoc.receiverEmail(
                                                          filteredData[index]
                                                              .emailReceiver),
                                                      style: TextStyle(
                                                          fontSize: 14 *
                                                              stateFont.resize),
                                                    ),
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
                                                              stateFont.resize),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      appLoc.createdAndSent(
                                                          filteredData[index]
                                                              .timeCreated),
                                                      style: TextStyle(
                                                          fontSize: 14 *
                                                              stateFont.resize),
                                                    ),
                                                  ]),
                                              trailing: CustomPackageButton(
                                                onPressed: () async {
                                                  await deletePackages(
                                                      [filteredData[index]],
                                                      statePackage);
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  size: 28,
                                                ),
                                                color: Colors.red,
                                              ),
                                            ),
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
                                                      fontSize: 18 *
                                                          stateFont.resize),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        GoogleSearchParcelPage(
                                                      parcelAddress:
                                                          filteredData[index]
                                                              .addressToSend,
                                                    ),
                                                  ));
                                                }),
                                          ]),
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

  void selectCheckbox(List<Package> filteredData, int index, bool? value) {
    if (value == true) {
      setState(() {
        checkedPackages.add(filteredData[index]);
      });
    } else {
      setState(() {
        checkedPackages.remove(filteredData[index]);
      });
    }

    if (checkedPackages.isEmpty) {
      showCheckboxes = false;
    }
  }

  void acceptPackages(List<Package> packagesToAccept) {
    context
        .read<PackageBloc>()
        .add(AcceptPackagesRequested(packagesToAccept, "received"));

    clearCheckboxes();
  }

  Future<void> deletePackages(
      List<Package> packagesToDelete, Fetched statePackage) async {
    bool? isDeleted = await DeleteDialogs.showDeletePackageDialog(
        context, packagesToDelete, statePackage.type);
    if (isDeleted == true) {
      clearCheckboxes();
    }
  }

  void clearCheckboxes() {
    setState(() {
      checkedPackages.clear();
      showCheckboxes = false;
    });
  }
}
