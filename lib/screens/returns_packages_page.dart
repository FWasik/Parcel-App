import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:parcel_app/bloc/font/font_bloc.dart';
import 'package:parcel_app/bloc/return/return_bloc.dart';
import 'package:parcel_app/models/return.dart';
import 'package:parcel_app/screens/create_return_page.dart';
import 'package:parcel_app/widgets/no_data_found_widget.dart';
import 'package:parcel_app/widgets/progress_widget.dart';

class ReturnPackagesPage extends StatefulWidget {
  const ReturnPackagesPage({Key? key}) : super(key: key);

  @override
  State<ReturnPackagesPage> createState() => _ReturnPackagesState();
}

class _ReturnPackagesState extends State<ReturnPackagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
            onPressed: (() {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CreateReturnPage(),
              ));
            }),
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            )),
        body: BlocBuilder<ReturnBloc, ReturnState>(
            builder: (contextReturn, stateReturn) {
          if (stateReturn is LoadingReturns || stateReturn is Created) {
            return CustomCircularProgressIndicator(
                color: Theme.of(context).primaryColor);
          } else if (stateReturn is Fetched) {
            List<Return> returns = stateReturn.returns;

            var appLoc = AppLocalizations.of(context)!;

            if (returns.isEmpty) {
              return NoDataFound(additionalText: appLoc.additionalTextReturns);
            } else {
              return BlocBuilder<FontBloc, FontState>(
                  builder: (contextFont, stateFont) {
                return Column(children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: returns.length,
                        itemBuilder: (_, index) {
                          return Card(
                            elevation: 10,
                            child: ListTile(
                              title: SelectableText(
                                  appLoc.returnId(returns[index].id),
                                  style: TextStyle(
                                      fontSize: 18 * stateFont.resize)),
                              subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    Text(
                                        appLoc.packageNumber(
                                            returns[index].packageId),
                                        style: TextStyle(
                                            fontSize: 14 * stateFont.resize)),
                                    const SizedBox(height: 10),
                                    Text(appLoc.returnType(returns[index].type),
                                        style: TextStyle(
                                            fontSize: 14 * stateFont.resize)),
                                    const SizedBox(height: 10),
                                    Text(
                                        appLoc.description(
                                            returns[index].description),
                                        style: TextStyle(
                                            fontSize: 14 * stateFont.resize)),
                                    const SizedBox(height: 10),
                                    Text(
                                        appLoc.timeReturnCreated(
                                            returns[index].timeCreated),
                                        style: TextStyle(
                                            fontSize: 14 * stateFont.resize)),
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
