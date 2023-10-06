import 'dart:async';

import 'package:auth_repo/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_expense_tracker/utils/constants.dart';
import 'package:net_source/net_source.dart';
import 'package:services_repo/services_repo.dart';
part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit(this._repo, this._sRepo) : super(const MainState()) {
    setupLocation();
  }
  final AuthRepo _repo;
  final ServicesRepo _sRepo;
  Future<void> setupLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      // Permissions are denied forever, handle appropriately.
      return;
    }

    await getLocation();
  }

  Future<void> getLocation() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
    } else {}
    final p = await Geolocator.getCurrentPosition();
    if (!isClosed) emit(state.copyWith(position: p));
  }
}
