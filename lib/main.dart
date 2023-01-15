import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:parcel_app/bloc/auth/auth_bloc.dart';
import 'package:parcel_app/bloc/language/language_bloc.dart';
import 'package:parcel_app/bloc/package/package_bloc.dart';
import 'package:parcel_app/bloc/return/return_bloc.dart';
import 'package:parcel_app/bloc/theme/theme_bloc.dart';
import 'package:parcel_app/repositories/auth_repository.dart';
import 'package:parcel_app/repositories/package_repository.dart';
import 'package:parcel_app/repositories/return_repository.dart';
import 'package:parcel_app/screens/main_page.dart';
import 'package:parcel_app/screens/sign_in.dart';
import 'package:parcel_app/utils/utils.dart';
import 'package:parcel_app/bloc/font/font_bloc.dart';

Future main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository: AuthRepository())),
        BlocProvider<PackageBloc>(
            create: (context) => PackageBloc(
                packageRepository:
                    PackageRepository(authRepository: AuthRepository()))),
        BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
        BlocProvider<FontBloc>(create: (context) => FontBloc()),
        BlocProvider<LanguageBloc>(create: (context) => LanguageBloc()),
        BlocProvider<ReturnBloc>(
            create: (context) => ReturnBloc(returnRepo: ReturnRepository()))
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, stateLan) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, stateTheme) {
            return MaterialApp(
              theme: stateTheme.themeData,
              scaffoldMessengerKey: Utils.messengerKey,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              supportedLocales: const [Locale('en'), Locale('pl')],
              locale: Locale(stateLan.language),
              home: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return const MainPage();
                    }
                    return const SignIn();
                  }),
            );
          },
        );
      }),
    );
  }
}
