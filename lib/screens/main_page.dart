import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:parcel_app/bloc/auth/auth_bloc.dart';
import 'package:parcel_app/bloc/font/font_bloc.dart';
import 'package:parcel_app/bloc/theme/theme_bloc.dart';
import 'package:parcel_app/screens/home_page.dart';
import 'package:parcel_app/screens/packages_received_page.dart';
import 'package:parcel_app/screens/packages_sent_page.dart';
import 'package:parcel_app/screens/profile_info_page.dart';
import 'package:parcel_app/screens/settings_page.dart';
import 'package:parcel_app/screens/sign_in.dart';
import 'package:parcel_app/utils/utils.dart';
import 'package:parcel_app/widgets/menu_widget.dart';
import 'package:parcel_app/widgets/progress_widget.dart';
import 'package:parcel_app/bloc/package/package_bloc.dart';

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
      HomePage(),
      PackagesSentPage(),
      PackagesReceivedPage(),
      ProfileInfoPage(),
    ];

    return BlocBuilder<FontBloc, FontState>(builder: (context, stateFont) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Parcel App'),
          actions: [CustomMenu()],
        ),
        bottomNavigationBar:
            BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: state.color,
            selectedItemColor: Theme.of(context).primaryColor,
            backgroundColor: state.backgroudBottomBar,
            currentIndex: _currentIndex,
            onTap: (int newIndex) {
              setState(() {
                _currentIndex = newIndex;

                if (_currentIndex == 1) {
                  BlocProvider.of<PackageBloc>(context)
                      .add(FetchRequested('sent'));
                } else if (_currentIndex == 2) {
                  BlocProvider.of<PackageBloc>(context)
                      .add(FetchRequested('received'));
                }
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.vertical_align_top), label: "Sent"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.vertical_align_bottom), label: "Received"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile")
            ],
          );
        }),
        body:
            BlocConsumer<AuthBloc, AuthState>(listener: (context, state) async {
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
    });
  }
}
