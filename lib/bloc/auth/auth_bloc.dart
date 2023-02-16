import 'package:parcel_app/models/custom_user.dart';
import 'package:parcel_app/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parcel_app/l10n/localization.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> with Localization {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const UnAuthenticated()) {
    on<SignInRequested>((event, emit) async {
      emit(const Loading());

      try {
        await authRepository.signIn(
            email: event.email, password: event.password);

        final user = await authRepository
            .getUserInfo(FirebaseAuth.instance.currentUser!.uid);

        emit(Authenticated(user));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          emit(AuthError(loc.invalidCredentials));
        } else {
          emit(AuthError(e.toString()));
        }

        emit(const UnAuthenticated());
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(const Loading());

      try {
        await authRepository.signUp(
          email: event.email,
          password: event.password,
          phoneNumber: event.phoneNumber,
          fullName: event.fullName,
        );

        emit(const SignedUp());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          emit(AuthError(loc.emailUse));
        } else {
          emit(AuthError(e.toString()));
        }
      }

      emit(const UnAuthenticated());
    });

    on<SignOutRequested>((event, emit) async {
      emit(const Loading());

      try {
        await authRepository.signOut();
      } on FirebaseAuthException catch (e) {
        emit(AuthError(e.toString()));
      }

      emit(const UnAuthenticated());
    });

    on<UnSignedUpRequested>((event, emit) async {
      emit(const Loading());

      emit(const UnAuthenticated());
    });

    on<EditUserRequested>((event, emit) async {
      try {
        if (state is Authenticated) {
          emit(const Loading());

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
        } else {
          emit(EditFailed(e.toString()));
        }

        final user = await authRepository
            .getUserInfo(FirebaseAuth.instance.currentUser!.uid);

        emit(Authenticated(user));
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(const UnAuthenticated());

        await FirebaseAuth.instance.signOut();
      }
    });

    on<DeleteUserRequested>((event, emit) async {
      emit(const Loading());

      try {
        await authRepository.deleteUser(uid: event.uid);
      } on FirebaseAuthException catch (e) {
        print(e);

        emit(AuthError(e.toString()));
      }

      emit(const UnAuthenticated());
    });

    on<ResetUserPasswordRequested>(((event, emit) async {
      emit(const Loading());

      try {
        await authRepository.resetPassword(event.email);
      } on FirebaseAuthException catch (e) {
        emit(AuthError(e.toString()));
      }

      emit(const UnAuthenticated());
    }));
  }

  @override
  AuthState fromJson(Map<String, dynamic> json) {
    CustomUser? user = CustomUser.fromJson(json['user']);

    return user != null ? Authenticated(user) : const UnAuthenticated();
  }

  @override
  Map<String, dynamic> toJson(AuthState state) {
    return state.user != null
        ? {"user": state.user!.toJson()}
        : {"user": state.user};
  }
}
