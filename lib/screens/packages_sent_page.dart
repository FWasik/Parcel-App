import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:parcel_app/bloc/package/package_bloc.dart';
import 'package:parcel_app/screens/send_package_page.dart';
import 'package:parcel_app/widgets/button_widget.dart';
import 'package:parcel_app/widgets/no_data_found_widget.dart';
import 'package:parcel_app/widgets/progress_widget.dart';
import 'package:parcel_app/models/package.dart';

class PackagesSentPage extends StatefulWidget {
  const PackagesSentPage({Key? key}) : super(key: key);

  @override
  State<PackagesSentPage> createState() => _PackagesSentPageState();
}

class _PackagesSentPageState extends State<PackagesSentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PackageBloc, PackageState>(builder: (context, state) {
        if (state is LoadingPackages || state is Deleted) {
          return CustomCircularProgressIndicator(
              color: Theme.of(context).primaryColor);
        } else if (state is Fetched) {
          List<Package> data = state.packages;

          if (data.isEmpty) {
            return const NoDataFound(
                additionalText: 'Create new package by hitting button below');
          } else {
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (_, index) {
                  return Card(
                    elevation: 10,
                    child: ListTile(
                      title: Text('Package number: \n${data[index].id}'),
                      subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Text('Receiver: \n${data[index].fullName}'),
                            const SizedBox(height: 10),
                            Text(
                                "Receiver's phone number: \n${data[index].phoneNumber}"),
                            const SizedBox(height: 10),
                            Text(
                                "Receiver's phone number: \n${data[index].phoneNumber}"),
                            const SizedBox(height: 10),
                            Text('Address: \n${data[index].address}'),
                            const SizedBox(height: 10),
                            Text(
                                'Created and sent at: \n${data[index].timeCreated}'),
                          ]),
                      trailing: CustomDeletePackageButton(onPressed: () {
                        _showDeletePackageDialog(data[index].id, state.type);
                      }),
                    ),
                  );
                });
          }
        } else {
          return Container();
        }
      }),
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
    );
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
