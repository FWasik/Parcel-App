import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:email_validator/email_validator.dart';

import 'package:parcel_app/bloc/package/package_bloc.dart';
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
  final addressController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    phoneNumberController.dispose();
    fullNameController.dispose();
    addressController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Send Package'),
        ),
        body:
            BlocConsumer<PackageBloc, PackageState>(listener: (context, state) {
          if (state is Error) {
            Utils.showSnackBar(state.error, Colors.red);
          } else if (state is Created) {
            Navigator.of(context).pop();
          }
        }, builder: (context, state) {
          if (state is LoadingPackages || state is Created) {
            return CustomCircularProgressIndicator(
                color: Theme.of(context).primaryColor);
          } else {
            return Container(
              padding: const EdgeInsets.all(18),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Send Package",
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                              prefixIcon:
                                  Icon(Icons.mail, color: Colors.indigo),
                              hintText: "Email",
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.indigo, width: 2),
                              )),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return value != null &&
                                    !EmailValidator.validate(value)
                                ? 'Enter a valid email'
                                : null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          controller: phoneNumberController,
                          decoration: const InputDecoration(
                              prefixIcon:
                                  Icon(Icons.phone, color: Colors.indigo),
                              hintText: "Phone number",
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.indigo, width: 2),
                              )),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return value == null || value.isEmpty
                                ? "Phone number cannot be empty"
                                : null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          controller: fullNameController,
                          decoration: const InputDecoration(
                              prefixIcon:
                                  Icon(Icons.person, color: Colors.indigo),
                              hintText: "Full name",
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.indigo, width: 2),
                              )),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return value == null || value.isEmpty
                                ? "Full name cannot be empty"
                                : null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          controller: addressController,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.location_city,
                                  color: Colors.indigo),
                              hintText: "Address",
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.indigo, width: 2),
                              )),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return value == null || value.isEmpty
                                ? "Address cannot be empty"
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
                            text: const Text(
                              "Create and sent",
                              style: TextStyle(fontSize: 24),
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
          }
        }));
  }

  void _createPackageInfo(BuildContext context) {
    if (formKey.currentState!.validate()) {
      context.read<PackageBloc>().add(CreateRequested(
          emailController.text,
          phoneNumberController.text,
          fullNameController.text,
          addressController.text));
    }
  }
}
