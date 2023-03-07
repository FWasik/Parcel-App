import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';
import 'package:parcel_app/l10n/localization.dart';
import 'package:parcel_app/models/return.dart';
import 'package:parcel_app/repositories/return_repository.dart';

part 'return_event.dart';
part 'return_state.dart';

class ReturnBloc extends Bloc<ReturnEvent, ReturnState> with Localization {
  final ReturnRepository returnRepo;

  ReturnBloc({required this.returnRepo}) : super(Init()) {
    on<FetchReturnsRequested>(((event, emit) async {
      emit(LoadingReturns());

      try {
        List<Return> returns = await returnRepo.fetchReturns();

        emit(Fetched(returns: returns));
      } catch (e) {
        emit(Error(e.toString()));
      }
    }));

    on<CreateReturnsRequested>(((event, emit) async {
      emit(LoadingReturns());

      try {
        await returnRepo.createReturn(
            packageId: event.packageId,
            type: event.type,
            descritpion: event.description);

        emit(Created());

        List<Return> returns = await returnRepo.fetchReturns();

        emit(Fetched(returns: returns));
      } catch (e) {
        if (e.toString().startsWith("Exception: ")) {
          emit(Error(e.toString().substring(11)));
        } else {
          emit(Error(e.toString()));
        }

        List<Return> returns = await returnRepo.fetchReturns();

        emit(Fetched(returns: returns));
      }
    }));
  }
}
