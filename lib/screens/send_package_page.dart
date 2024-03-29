import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:parcel_app/bloc/font/font_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:parcel_app/bloc/package/package_bloc.dart';
import 'package:parcel_app/screens/google_page.dart';
import 'package:parcel_app/utils/utils.dart';
import 'package:parcel_app/widgets/button_widget.dart';
import 'package:parcel_app/widgets/progress_widget.dart';

class SendPackagePage extends StatefulWidget {
  const SendPackagePage({Key? key}) : super(key: key);

  @override
  State<SendPackagePage> createState() => _SendPackagePageState();
}

class _SendPackagePageState extends State<SendPackagePage> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final fullNameController = TextEditingController();
  final addressToSendController = TextEditingController();
  final addressToReceiveController = TextEditingController();

  RegExp regExp = RegExp(r'^[0-9]{9}$');

  @override
  void dispose() {
    emailController.dispose();
    phoneNumberController.dispose();
    fullNameController.dispose();
    addressToSendController.dispose();
    addressToReceiveController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLoc = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(AppLocalizations.of(context)!.sendPackage),
        ),
        body: BlocConsumer<PackageBloc, PackageState>(
            listener: (contextPackage, statePackage) {
          if (statePackage is Error) {
            Utils.showSnackBar(statePackage.error, Colors.red, appLoc.dissmiss);
          } else if (statePackage is Created) {
            Navigator.of(context).pop();
          }
        }, builder: (contextPackage, statePackage) {
          if (statePackage is LoadingPackages || statePackage is Created) {
            return CustomCircularProgressIndicator(
                color: Theme.of(context).primaryColor);
          } else {
            return BlocBuilder<FontBloc, FontState>(
                builder: (contextFont, stateFont) {
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
                            appLoc.sendPackage,
                            style: TextStyle(
                              fontSize: 38 * stateFont.resize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.mail,
                                    color: Theme.of(context).primaryColor),
                                hintText: "Email",
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
                              return value != null &&
                                      !EmailValidator.validate(value)
                                  ? appLoc.validEmail
                                  : null;
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: phoneNumberController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone,
                                    color: Theme.of(context).primaryColor),
                                hintText: appLoc.phoneNumber,
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
                              return value == null || !regExp.hasMatch(value)
                                  ? appLoc.validPhoneNumber
                                  : null;
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: fullNameController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person,
                                    color: Theme.of(context).primaryColor),
                                hintText: appLoc.fullName,
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
                                  ? appLoc.validFullName
                                  : null;
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            maxLines: 2,
                            readOnly: true,
                            controller: addressToSendController,
                            onTap: () async {
                              addressToSendController.text =
                                  await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                builder: (context) => const GooglePage(),
                              ));
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.location_city,
                                    color: Theme.of(context).primaryColor),
                                hintText: appLoc.addressSend,
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
                                  ? appLoc.validAdress
                                  : null;
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            maxLines: 2,
                            readOnly: true,
                            controller: addressToReceiveController,
                            onTap: () async {
                              addressToReceiveController.text =
                                  await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                builder: (context) => const GooglePage(),
                              ));
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.location_city,
                                    color: Theme.of(context).primaryColor),
                                hintText: appLoc.addressReceive,
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
                                  ? appLoc.validAdress
                                  : null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomButton(
                              width: 0.7,
                              color: Theme.of(context).primaryColor,
                              icon: const Icon(Icons.local_shipping, size: 32),
                              text: Text(
                                appLoc.createAndSend,
                                style:
                                    TextStyle(fontSize: 24 * stateFont.resize),
                              ),
                              onPressed: () {
                                _createPackageInfo(context);
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

  void _createPackageInfo(BuildContext context) {
    if (formKey.currentState!.validate()) {
      context.read<PackageBloc>().add(CreatePackagesRequested(
          emailController.text,
          phoneNumberController.text,
          fullNameController.text,
          addressToSendController.text,
          addressToReceiveController.text));
    }
  }
}
