part of 'package_bloc.dart';

abstract class PackageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchRequested extends PackageEvent {
  final String type;

  FetchRequested(this.type);
}

class CreateRequested extends PackageEvent {
  final String email;
  final String phoneNumber;
  final String fullName;
  final String address;

  CreateRequested(this.email, this.phoneNumber, this.fullName, this.address);
}

class InitRequested extends PackageEvent {}

class DeleteRequested extends PackageEvent {
  final String id;
  final String type;

  DeleteRequested(this.id, this.type);
}

class AcceptRequested extends PackageEvent {
  final Package package;
  final String uidSender;
  final String type;

  AcceptRequested(this.package, this.uidSender, this.type);
}
