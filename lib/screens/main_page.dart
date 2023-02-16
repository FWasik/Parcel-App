import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:parcel_app/bloc/auth/auth_bloc.dart';
import 'package:parcel_app/bloc/font/font_bloc.dart';
import 'package:parcel_app/bloc/return/return_bloc.dart';
import 'package:parcel_app/bloc/theme/theme_bloc.dart';
import 'package:parcel_app/screens/home_page.dart';
import 'package:parcel_app/screens/packages_received_page.dart';
import 'package:parcel_app/screens/packages_sent_page.dart';
import 'package:parcel_app/screens/profile_info_page.dart';
import 'package:parcel_app/screens/returns_packages_page.dart';
import 'package:parcel_app/screens/sign_in.dart';
import 'package:parcel_app/utils/utils.dart';
import 'package:parcel_app/widgets/menu_widget.dart';
import 'package:parcel_app/widgets/progress_widget.dart';
import 'package:parcel_app/bloc/package/package_bloc.dart';
import 'package:parcel_app/l10n/localization.dart';

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
      ReturnPackagesPage(),
      ProfileInfoPage(),
    ];
    Localization.init(context);

    return BlocBuilder<FontBloc, FontState>(builder: (context, stateFont) {
      var appLoc = AppLocalizations.of(context)!;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(AppLocalizations.of(context)!.parcelApp),
          actions: const [CustomMenu()],
        ),
        bottomNavigationBar:
            BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: state.color,
            selectedItemColor: Theme.of(context).primaryColor,
            backgroundColor: state.backgroudBottomBar,
            currentIndex: _currentIndex,
            selectedFontSize: 13 * stateFont.resize,
            unselectedFontSize: 13 * stateFont.resize,
            onTap: (int newIndex) {
              setState(() {
                _currentIndex = newIndex;

                if (_currentIndex == 1) {
                  BlocProvider.of<PackageBloc>(context)
                      .add(FetchPackagesRequested('sent'));
                } else if (_currentIndex == 2) {
                  BlocProvider.of<PackageBloc>(context)
                      .add(FetchPackagesRequested('received'));
                } else if (_currentIndex == 3) {
                  BlocProvider.of<ReturnBloc>(context)
                      .add(FetchReturnsRequested());
                }
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(Icons.home), label: appLoc.home),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.vertical_align_top),
                  label: appLoc.sent),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.vertical_align_bottom),
                  label: appLoc.receive),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.radio), label: appLoc.returns),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.person), label: appLoc.profile)
            ],
          );
        }),
        body: BlocConsumer<AuthBloc, AuthState>(
            listener: (contextAuth, stateAuth) async {
          if (stateAuth is UnAuthenticated) {
            //Navigator.of(context).popUntil((route) => route.isFirst);

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const SignIn()),
              (route) => false,
            );
          } else if (stateAuth is EditFailed) {
            Utils.showSnackBar(stateAuth.error, Colors.red, appLoc.dissmiss);
          }
        }, builder: (contextAuth, stateAuth) {
          if (stateAuth is Loading) {
            return CustomCircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            );
          } else if (stateAuth is Authenticated) {
            return body[_currentIndex];
          } else {
            return Container();
          }
        }),
      );
    });
  }
}
