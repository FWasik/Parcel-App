part of 'package_bloc.dart';

@immutable
abstract class PackageState extends Equatable {}

class LoadingPackages extends PackageState {
  @override
  List<Object?> get props => [];
}

class Created extends PackageState {
  @override
  List<Object?> get props => [];
}

class Fetched extends PackageState {
  final List<Package> packages;
  final String type;

  Fetched({required this.packages, required this.type});

  @override
  List<Object?> get props => [packages];
}

class Error extends PackageState {
  final String? error;

  Error(this.error);

  @override
  List<Object?> get props => [error];
}

class Init extends PackageState {
  @override
  List<Object?> get props => [];
}
