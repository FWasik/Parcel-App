part of 'return_bloc.dart';

@immutable
abstract class ReturnState extends Equatable {}

class LoadingReturns extends ReturnState {
  @override
  List<Object?> get props => [];
}

class Created extends ReturnState {
  @override
  List<Object?> get props => [];
}

class Fetched extends ReturnState {
  final List<Return> returns;

  Fetched({required this.returns});

  @override
  List<Object?> get props => [returns];
}

class Error extends ReturnState {
  final String? error;

  Error(this.error);

  @override
  List<Object?> get props => [error];
}

class Init extends ReturnState {
  @override
  List<Object?> get props => [];
}
