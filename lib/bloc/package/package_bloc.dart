import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';

import 'package:parcel_app/repositories/package_repository.dart';
import 'package:parcel_app/models/package.dart';
import 'package:parcel_app/l10n/localization.dart';

part 'package_event.dart';
part 'package_state.dart';

class PackageBloc extends Bloc<PackageEvent, PackageState> with Localization {
  final PackageRepository packageRepository;

  PackageBloc({required this.packageRepository}) : super(Init()) {
    on<FetchPackagesRequested>(((event, emit) async {
      emit(LoadingPackages());

      try {
        List<Package> packages = [];

        packages = await packageRepository.fetchPackages(event.type);

        emit(Fetched(packages: packages, type: event.type));
      } catch (e) {
        emit(Error(e.toString()));
      }
    }));

    on<CreatePackagesRequested>(((event, emit) async {
      emit(LoadingPackages());

      try {
        await packageRepository.createPackage(
            email: event.email,
            phoneNumber: event.phoneNumber,
            fullName: event.fullName,
            addressToSend: event.addressToSend,
            addressToReceive: event.addressToReceive);

        emit(Created());

        List<Package> packages = await packageRepository.fetchPackages('sent');

        emit(Fetched(packages: packages, type: 'sent'));
      } catch (e) {
        String exception =
            'RangeError (index): Invalid value: Valid value range is empty: 0';

        var x = e.toString();

        if (e.toString() == exception) {
          emit(Error(loc.invalidReceiver));
        } else {
          emit(Error(loc.sentToYourself));
        }

        List<Package> packages = await packageRepository.fetchPackages('sent');

        emit(Fetched(packages: packages, type: 'sent'));
      }
    }));

    on<DeletePackagesRequested>(((event, emit) async {
      emit(LoadingPackages());

      try {
        await packageRepository.deletePackage(id: event.id);

        List<Package> packages =
            await packageRepository.fetchPackages(event.type);

        emit(Fetched(packages: packages, type: event.type));
      } catch (e) {
        emit(Error(e.toString()));
      }
    }));

    on<AcceptPackagesRequested>(((event, emit) async {
      emit(LoadingPackages());

      try {
        await packageRepository.acceptPackage(
            package: event.package, uidSender: event.uidSender);

        List<Package> packages =
            await packageRepository.fetchPackages(event.type);

        emit(Fetched(packages: packages, type: event.type));
      } catch (e) {
        emit(Error(e.toString()));
      }
    }));
  }
}
