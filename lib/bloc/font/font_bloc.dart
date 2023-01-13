import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'font_event.dart';
part 'font_state.dart';

class FontBloc extends Bloc<FontEvent, FontState> {
  FontBloc() : super(FontState(resize: 1)) {
    on<FontChangeRequested>(((event, emit) async {
      emit(FontState(resize: event.resize));
    }));
  }
}
