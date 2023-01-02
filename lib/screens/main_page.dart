import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:parcel_app/bloc/auth_bloc.dart';
import 'package:parcel_app/screens/profile_info_page.dart';
import 'package:parcel_app/screens/sign_in.dart';
import 'package:parcel_app/utils/utils.dart';
import 'package:parcel_app/widgets/progress_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    List<Widget> body = const [
      Text("Heeelooo"),
      ProfileInfoPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Parcel App'),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                  value: 0,
                  child: Text(
                    "Delete an account",
                    style: TextStyle(color: Colors.red),
                  )),
              const PopupMenuItem<int>(value: 1, child: Text("Sign out")),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              _showMyDialog();
            } else if (value == 1) {
              context.read<AuthBloc>().add(SignOutRequested());
            }
          })
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        backgroundColor: const Color.fromARGB(255, 49, 51, 62),
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) async {
        if (state is UnAuthenticated) {
          //Navigator.of(context).popUntil((route) => route.isFirst);

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SignIn()),
            (route) => false,
          );
        } else if (state is EditFailed) {
          Utils.showSnackBar(state.error, Colors.red);
        }
      }, builder: (context, state) {
        if (state is Loading) {
          return CustomCircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          );
        } else if (state is Authenticated) {
          return body[_currentIndex];
        } else {
          return Container();
        }
      }),
    );
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
