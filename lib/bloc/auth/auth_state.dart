part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  final CustomUser? user;
  const AuthState(this.user);

  @override
  List<Object?> get props => [user];
}

class Loading extends AuthState {
  const Loading({user}) : super(user);

  @override
  List<Object?> get props => [user];
}

class Authenticated extends AuthState {
  const Authenticated(user) : super(user);

  @override
  List<Object?> get props => [user];
}

class UnAuthenticated extends AuthState {
  const UnAuthenticated({user}) : super(user);

  @override
  List<Object?> get props => [user];
}

class SignedUp extends AuthState {
  const SignedUp({user}) : super(user);

  @override
  List<Object?> get props => [user];
}

class EditFailed extends AuthState {
  final String error;

  const EditFailed(this.error, {user}) : super(user);

  @override
  List<Object?> get props => [error, user];
}

class AuthError extends AuthState {
  final String error;

  const AuthError(this.error, {user}) : super(user);

  @override
  List<Object?> get props => [error, user];
}
