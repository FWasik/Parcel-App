part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {}

class Loading extends AuthState {
  @override
  List<Object?> get props => [];
}

class Authenticated extends AuthState {
  final CustomUser? user;
  Authenticated(this.user);

  @override
  List<Object?> get props => [];
}

class UnAuthenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

class SignedUp extends AuthState {
  @override
  List<Object?> get props => [];
}

class EditFailed extends AuthState {
  final String? error;

  EditFailed(this.error);

  @override
  List<Object?> get props => [error];
}

class Deleted extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthError extends AuthState {
  final String error;

  AuthError(this.error);

  @override
  List<Object?> get props => [error];
}
