part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {}

class Loading extends AuthState {
  @override
  List<Object?> get props => [];
}

class Authenticated extends AuthState {
  CustomUser? user;
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

class Updated extends AuthState {
  @override
  List<Object?> get props => [];
}

class UpdateFailed extends AuthState {
  final String? error;

  UpdateFailed(this.error);

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
