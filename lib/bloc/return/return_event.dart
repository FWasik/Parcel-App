part of 'return_bloc.dart';

abstract class ReturnEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchReturnsRequested extends ReturnEvent {
  FetchReturnsRequested();
}

class CreateReturnsRequested extends ReturnEvent {
  final String packageId;
  final String type;
  final String description;

  CreateReturnsRequested(this.packageId, this.type, this.description);
}

class InitReturnsRequested extends ReturnEvent {}
