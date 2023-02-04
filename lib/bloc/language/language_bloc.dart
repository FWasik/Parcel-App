import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends HydratedBloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState(language: "en")) {
    on<LanguageChangeRequested>(((event, emit) async {
      emit(LanguageState(language: event.language));
    }));
  }

  @override
  LanguageState fromJson(Map<String, dynamic> json) =>
      LanguageState(language: json['language']);

  @override
  Map<String, String> toJson(LanguageState state) =>
      {'language': state.language};
}
