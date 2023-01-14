part of 'language_bloc.dart';

abstract class LanguageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LanguageChangeRequested extends LanguageEvent {
  final String language;

  LanguageChangeRequested({required this.language});
}
