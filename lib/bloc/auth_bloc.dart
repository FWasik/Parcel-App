import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:parcel_app/models/custom_user.dart';
import 'package:parcel_app/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(UnAuthenticated()) {
    on<SignInRequested>((event, emit) async {
      emit(Loading());

      try {
        await authRepository.signIn(
            email: event.email, password: event.password);

        final user = await authRepository.getUserInfo();

        emit(Authenticated(user));
      } catch (e) {
        emit(AuthError(e.toString()));
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
        emit(AuthError(e.toString()));
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

    on<UpdateUserRequested>((event, emit) async {
      emit(Loading());

      try {
        await authRepository.updateUserInfo(
          uid: event.uid,
          email: event.email,
          phoneNumber: event.phoneNumber,
          fullName: event.fullName,
        );

        emit(Updated());
      } on FirebaseAuthException catch (e) {
        print(e);

        if (e.code == "email-already-in-use") {
          emit(UpdateFailed(e.message));
        } else {
          emit(AuthError(e.toString()));
          emit(UnAuthenticated());

          await FirebaseAuth.instance.signOut();
        }
      }
    });

    on<UnUpdatedRequested>((event, emit) async {
      try {
        if (this.state is UpdateFailed || this.state is Updated) {
          emit(Loading());

          final user = await authRepository.getUserInfo();
          emit(Authenticated(user));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<DeleteUserRequested>((event, emit) async {
      emit(Loading());

      try {
        await authRepository.deleteUser(uid: event.uid);
        emit(UnAuthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });
  }
}
