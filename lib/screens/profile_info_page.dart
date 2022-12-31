import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:parcel_app/bloc/auth_bloc.dart';
import 'package:parcel_app/screens/sign_in.dart';
import 'package:parcel_app/screens/update_user.dart';
import 'package:parcel_app/models/custom_user.dart';

class ProfileInfoPage extends StatefulWidget {
  const ProfileInfoPage({Key? key}) : super(key: key);

  @override
  State<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is Authenticated) {
        CustomUser? user = state.user!;
        String email = user.email;
        String phoneNumber = user.phoneNumber;
        String fullName = user.fullName;

        return Container(
          padding: const EdgeInsets.all(18),
          child: Stack(children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  Text("Full name: \n ${email}"),
                  Text("Full name: \n ${fullName}"),
                  Text("Phone number: \n ${phoneNumber}"),
                  const SizedBox(height: 16)
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: 70,
                height: 70,
                child: FittedBox(
                  child: FloatingActionButton(
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.red,
                      onPressed: () {
                        _showMyDialog();
                      },
                      heroTag: null),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 70,
                height: 70,
                child: FittedBox(
                  child: FloatingActionButton(
                      child: const Icon(
                        Icons.create,
                        color: Colors.white,
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UpdateUser(
                                uid: uid,
                                email: email,
                                phoneNumber: phoneNumber,
                                fullName: fullName)));
                      },
                      heroTag: null),
                ),
              ),
            ),
          ]),
        );
      } else if (state is Loading) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return Container();
      }
    }));
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deleting an account'),
          content: const SingleChildScrollView(
            child: Text(
              'Are you sure you want to delete an account?',
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
                context.read<AuthBloc>().add(DeleteUserRequested(uid));

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const SignIn()),
                    (route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}
