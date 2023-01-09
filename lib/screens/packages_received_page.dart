import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:parcel_app/bloc/package/package_bloc.dart';
import 'package:parcel_app/widgets/button_widget.dart';
import 'package:parcel_app/widgets/no_data_found_widget.dart';
import 'package:parcel_app/widgets/progress_widget.dart';
import 'package:parcel_app/models/package.dart';
import 'package:parcel_app/widgets/switch_gesture.dart';

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

        if (state.packages.isEmpty) {
          return const NoDataFound(
              additionalText:
                  'First someone needs to send you a package. Wait for it :)');
        } else {
          return Column(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SwitchGesture(
                    "Non received",
                    onTap: () {
                      setState(() {
                        _isReceived = false;
                      });
                    },
                    selected: _isReceived == false,
                  ),
                  SwitchGesture(
                    "Received",
                    onTap: () {
                      setState(() {
                        _isReceived = true;
                      });
                    },
                    selected: _isReceived,
                  ),
                ],
              ),
            ),
            // (_isReceived
            //     ? Padding(
            //         padding: const EdgeInsets.only(bottom: 20, top: 10),
            //         child: CustomButton(
            //             text: const Text(
            //               "Delete All",
            //               style: TextStyle(fontSize: 20),
            //             ),
            //             color: Colors.red,
            //             onPressed: () {},
            //             icon: const Icon(Icons.delete),
            //             width: 0.7),
            //       )''
            //     : null),
            Expanded(
              child: ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (_, index) {
                    return Card(
                      elevation: 10,
                      child: ListTile(
                        title:
                            Text('Package number: \n${filteredData[index].id}'),
                        subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Text('Sender: \n${filteredData[index].fullName}'),
                              const SizedBox(height: 10),
                              Text(
                                  "Sender's phone number: \n${filteredData[index].phoneNumber}"),
                              const SizedBox(height: 10),
                              Text(
                                  "Sender's email: \n${filteredData[index].emailSender}"),
                              const SizedBox(height: 10),
                              Text(
                                  "Parcel machine's address: \n${filteredData[index].address}"),
                              const SizedBox(height: 10),
                              Text(
                                  'Created and sent at: \n${filteredData[index].timeCreated}'),
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
                                _showDeletePackageDialog(
                                    filteredData[index].id, state.type);
                              })),
                      ),
                    );
                  }),
            ),
          ]);
        }
      } else {
        return Container();
      }
    }));
  }

  Future<void> _showDeletePackageDialog(String id, String type) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deleting a packge'),
          content: const SingleChildScrollView(
            child: Text(
              'Are you sure you want to delete this package from history?',
              style: TextStyle(fontSize: 18),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
              onPressed: () {
                context.read<PackageBloc>().add(DeleteRequested(id, type));

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
