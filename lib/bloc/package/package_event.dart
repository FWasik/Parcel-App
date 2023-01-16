part of 'package_bloc.dart';

abstract class PackageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPackagesRequested extends PackageEvent {
  final String type;

  FetchPackagesRequested(this.type);
}

class CreatePackagesRequested extends PackageEvent {
  final String email;
  final String phoneNumber;
  final String fullName;
  final String addressToSend;
  final String addressToReceive;

  CreatePackagesRequested(this.email, this.phoneNumber, this.fullName,
      this.addressToSend, this.addressToReceive);
}

class InitPackagesRequested extends PackageEvent {}

class DeletePackagesRequested extends PackageEvent {
  final String id;
  final String type;

  DeletePackagesRequested(this.id, this.type);
}

class AcceptPackagesRequested extends PackageEvent {
  final Package package;
  final String uidSender;
  final String type;

  AcceptPackagesRequested(this.package, this.uidSender, this.type);
}
