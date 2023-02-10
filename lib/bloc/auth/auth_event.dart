part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested(this.email, this.password);
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String phoneNumber;
  final String fullName;

  SignUpRequested(this.email, this.password, this.phoneNumber, this.fullName);
}

class SignOutRequested extends AuthEvent {}

class UnSignedUpRequested extends AuthEvent {}

class EditUserRequested extends AuthEvent {
  final String uid;
  final String email;
  final String phoneNumber;
  final String fullName;

  EditUserRequested(this.uid, this.email, this.phoneNumber, this.fullName);
}

class InitRequested extends AuthEvent {}

class UnUpdatedRequested extends AuthEvent {}

class DeleteUserRequested extends AuthEvent {
  final String uid;

  DeleteUserRequested(this.uid);
}

class ResetUserPasswordRequested extends AuthEvent {
  final String email;

  ResetUserPasswordRequested(this.email);
}
