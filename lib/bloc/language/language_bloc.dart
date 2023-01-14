import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:parcel_app/utils/themes.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState(language: "en")) {
    on<LanguageChangeRequested>(((event, emit) async {
      emit(LanguageState(language: event.language));
    }));
  }
}
