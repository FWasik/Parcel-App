import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'font_event.dart';
part 'font_state.dart';

class FontBloc extends HydratedBloc<FontEvent, FontState> {
  FontBloc() : super(FontState(resize: 1)) {
    on<FontChangeRequested>(((event, emit) async {
      emit(FontState(resize: event.resize));
    }));
  }

  @override
  FontState fromJson(Map<String, dynamic> json) =>
      FontState(resize: json['resize']);

  @override
  Map<String, double> toJson(FontState state) => {'resize': state.resize};
}
