import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcel_app/bloc/font/font_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:parcel_app/bloc/return/return_bloc.dart';
import 'package:parcel_app/utils/utils.dart';
import 'package:parcel_app/widgets/button_widget.dart';
import 'package:parcel_app/widgets/progress_widget.dart';

class CreateReturnPage extends StatefulWidget {
  const CreateReturnPage({Key? key}) : super(key: key);

  @override
  State<CreateReturnPage> createState() => _CreateReturnState();
}

class _CreateReturnState extends State<CreateReturnPage> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  final formKey = GlobalKey<FormState>();
  final uidPackageController = TextEditingController();
  final descriptionController = TextEditingController();
  final typeController = TextEditingController();

  @override
  void dispose() {
    uidPackageController.dispose();
    descriptionController.dispose();
    typeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLoc = AppLocalizations.of(context)!;
    List<String> list = <String>[
      appLoc.typeOne,
      appLoc.typeTwo,
      appLoc.typeDiff
    ];

    String? dropdownValue;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(appLoc.createReturnButton),
        ),
        body: BlocConsumer<ReturnBloc, ReturnState>(listener: (context, state) {
          if (state is Error) {
            Utils.showSnackBar(state.error, Colors.red, appLoc.dissmiss);
          } else if (state is Created) {
            Navigator.of(context).pop();
          }
        }, builder: (context, state) {
          if (state is LoadingReturns || state is Created) {
            return CustomCircularProgressIndicator(
                color: Theme.of(context).primaryColor);
          } else {
            return BlocBuilder<FontBloc, FontState>(
                builder: (context, stateFont) {
              return Container(
                padding: const EdgeInsets.all(18),
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            appLoc.createReturn,
                            style: TextStyle(
                              fontSize: 38 * stateFont.resize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            controller: uidPackageController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.mail,
                                    color: Theme.of(context).primaryColor),
                                hintText: appLoc.formNumberPackage,
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2),
                                )),
                            style: TextStyle(fontSize: 16 * stateFont.resize),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return value != null && value.isEmpty
                                  ? appLoc.validPackageNumber
                                  : null;
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          DropdownButtonFormField<String>(
                            hint: Text(appLoc.type),
                            value: dropdownValue,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.select_all,
                                    color: Theme.of(context).primaryColor),
                                hintText: appLoc.formDesc,
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2),
                                )),
                            style: TextStyle(fontSize: 16 * stateFont.resize),
                            icon: const Icon(Icons.arrow_downward),
                            onChanged: (String? value) {
                              setState(() {
                                dropdownValue = value!;
                                typeController.text = value;
                              });
                            },
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            validator: (value) {
                              return value == null || value.isEmpty
                                  ? appLoc.validType
                                  : null;
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: descriptionController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person,
                                    color: Theme.of(context).primaryColor),
                                hintText: appLoc.formDesc,
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2),
                                )),
                            style: TextStyle(fontSize: 16 * stateFont.resize),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return value == null || value.isEmpty
                                  ? appLoc.validDesc
                                  : null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomButton(
                              width: 0.7,
                              color: Theme.of(context).primaryColor,
                              icon: const Icon(Icons.arrow_forward, size: 32),
                              text: Text(
                                appLoc.createReturnButton,
                                style:
                                    TextStyle(fontSize: 24 * stateFont.resize),
                              ),
                              onPressed: () {
                                _createReturn(context);
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
          }
        }));
  }

  void _createReturn(BuildContext context) {
    if (formKey.currentState!.validate()) {
      context.read<ReturnBloc>().add(CreateReturnsRequested(
          uidPackageController.text,
          typeController.text,
          descriptionController.text));
    }
  }
}
