part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final CustomUser? user;
  const AuthState(this.user);

  @override
  List<Object?> get props => [];
}

class Loading extends AuthState {
  const Loading({user}) : super(user);

  @override
  List<Object?> get props => [];
}

class Authenticated extends AuthState {
  const Authenticated(user) : super(user);

  @override
  List<Object?> get props => [];
}

class UnAuthenticated extends AuthState {
  const UnAuthenticated({user}) : super(user);
  @override
  List<Object?> get props => [];
}

class SignedUp extends AuthState {
  const SignedUp({user}) : super(user);

  @override
  List<Object?> get props => [];
}

class EditFailed extends AuthState {
  final String? error;

  const EditFailed(this.error, {user}) : super(user);

  @override
  List<Object?> get props => [error];
}

class Deleted extends AuthState {
  const Deleted({user}) : super(user);

  @override
  List<Object?> get props => [];
}

class AuthError extends AuthState {
  final String error;

  const AuthError(this.error, {user}) : super(user);

  @override
  List<Object?> get props => [error];
}
