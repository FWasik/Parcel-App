import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:parcel_app/repositories/package_repository.dart';
import 'package:parcel_app/models/package.dart';
import 'package:parcel_app/l10n/localization.dart';

part 'package_event.dart';
part 'package_state.dart';

class PackageBloc extends Bloc<PackageEvent, PackageState> with Localization {
  final PackageRepository packageRepository;

  PackageBloc({required this.packageRepository}) : super(Init()) {
    on<FetchRequested>(((event, emit) async {
      emit(LoadingPackages());

      try {
        List<Package> packages = [];

        packages = await packageRepository.fetchPackages(event.type);

        emit(Fetched(packages: packages, type: event.type));
      } catch (e) {
        emit(Error(e.toString()));
      }
    }));

    on<InitRequested>(((event, emit) async {
      emit(LoadingPackages());

      try {
        emit(Init());
      } catch (e) {
        emit(Error(e.toString()));
      }
    }));

    on<CreateRequested>(((event, emit) async {
      emit(LoadingPackages());

      try {
        await packageRepository.createPackage(
            email: event.email,
            phoneNumber: event.phoneNumber,
            fullName: event.fullName,
            address: event.address);

        emit(Created());

        List<Package> packages = await packageRepository.fetchPackages('sent');

        emit(Fetched(packages: packages, type: 'sent'));
      } catch (e) {
        String exception =
            'Exception: RangeError (index): Invalid value: Valid value range is empty: 0';

        if (e.toString() == exception) {
          emit(Error(loc.invalidReceiver));
        } else {
          emit(Error(loc.sentToYourself));
        }

        List<Package> packages = await packageRepository.fetchPackages('sent');

        emit(Fetched(packages: packages, type: 'sent'));
      }
    }));

    on<DeleteRequested>(((event, emit) async {
      emit(LoadingPackages());

      try {
        await packageRepository.deletePackage(id: event.id);

        emit(Deleted());

        List<Package> packages =
            await packageRepository.fetchPackages(event.type);

        emit(Fetched(packages: packages, type: event.type));
      } catch (e) {
        emit(Error(e.toString()));
      }
    }));

    on<AcceptRequested>(((event, emit) async {
      emit(LoadingPackages());

      try {
        await packageRepository.acceptPackage(
            package: event.package, uidSender: event.uidSender);

        emit(Accepted());

        List<Package> packages =
            await packageRepository.fetchPackages(event.type);

        emit(Fetched(packages: packages, type: event.type));
      } catch (e) {
        emit(Error(e.toString()));
      }
    }));
  }
}
