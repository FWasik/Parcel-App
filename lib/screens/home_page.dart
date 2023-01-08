import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcel_app/bloc/auth/auth_bloc.dart';
import 'package:parcel_app/models/custom_user.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        if (state is Authenticated) {
          CustomUser? user = state.user!;

          return Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const FlutterLogo(
                size: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome to Parcel App!",
                style: TextStyle(fontSize: 35),
              ),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text(
                  'You are logged in as ',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  user.fullName,
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.underline),
                ),
              ]),
              const SizedBox(height: 20),
              const Text(
                'Choose one of options below',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 60),
              const Icon(Icons.keyboard_double_arrow_down, size: 80)
            ]),
          );
        } else {
          return Container();
        }
      }),
    );
  }
}
