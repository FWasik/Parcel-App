import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:parcel_app/models/custom_user.dart';
import 'package:parcel_app/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parcel_app/l10n/localization.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> with Localization {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(UnAuthenticated()) {
    on<InitRequested>(((event, emit) async {
      if (FirebaseAuth.instance.currentUser != null) {
        CustomUser? user = await authRepository
            .getUserInfo(FirebaseAuth.instance.currentUser!.uid);
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    }));

    on<SignInRequested>((event, emit) async {
      emit(Loading());

      try {
        await authRepository.signIn(
            email: event.email, password: event.password);

        final user = await authRepository
            .getUserInfo(FirebaseAuth.instance.currentUser!.uid);

        emit(Authenticated(user));
      } catch (e) {
        if (e.toString().startsWith("Exception: ")) {
          emit(AuthError(e.toString().substring(11)));
        } else {
          emit(AuthError(e.toString()));
        }

        emit(UnAuthenticated());
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(Loading());

      try {
        await authRepository.signUp(
          email: event.email,
          password: event.password,
          phoneNumber: event.phoneNumber,
          fullName: event.fullName,
        );

        emit(SignedUp());
      } catch (e) {
        if (e.toString().startsWith("Exception: ")) {
          emit(AuthError(e.toString().substring(11)));
        } else {
          emit(AuthError(e.toString()));
        }

        emit(UnAuthenticated());
      }
    });

    on<SignOutRequested>((event, emit) async {
      emit(Loading());
      await authRepository.signOut();
      emit(UnAuthenticated());
    });

    on<UnSignedUpRequested>((event, emit) async {
      emit(Loading());
      emit(UnAuthenticated());
    });

    on<EditUserRequested>((event, emit) async {
      try {
        if (state is Authenticated) {
          emit(Loading());

          await authRepository.updateUserInfo(
            uid: event.uid,
            email: event.email,
            phoneNumber: event.phoneNumber,
            fullName: event.fullName,
          );

          final user = await authRepository
              .getUserInfo(FirebaseAuth.instance.currentUser!.uid);

          emit(Authenticated(user));
        }
      } on FirebaseAuthException catch (e) {
        print(e);

        if (e.code == "email-already-in-use") {
          emit(EditFailed(loc.emailUse));

          final user = await authRepository
              .getUserInfo(FirebaseAuth.instance.currentUser!.uid);

          emit(Authenticated(user));
        } else {
          emit(AuthError(e.toString()));
          emit(UnAuthenticated());

          await FirebaseAuth.instance.signOut();
        }
      }
    });

    on<DeleteUserRequested>((event, emit) async {
      emit(Loading());

      try {
        await authRepository.deleteUser(uid: event.uid);
      } catch (e) {
        emit(AuthError(e.toString()));
      }

      emit(UnAuthenticated());
    });

    on<ResetUserPasswordRequested>(((event, emit) async {
      emit(Loading());

      try {
        await authRepository.resetPassword(event.email);
      } on Exception catch (e) {
        emit(AuthError(e.toString()));
      }

      emit(UnAuthenticated());
    }));
  }
}
