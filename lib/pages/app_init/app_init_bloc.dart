/*
 * Copyright (C) 2018  SuperGreenLab <towelie@supergreenlab.com>
 * Author: Constantin Clauzel <constantin.clauzel@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_matomo/flutter_matomo.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:super_green_app/data/backend/feeds/feeds_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/kv/models/app_data.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/main/analytics_bloc_delegate.dart';

abstract class AppInitBlocEvent extends Equatable {}

class AppInitBlocEventInit extends AppInitBlocEvent {
  AppInitBlocEventInit();

  @override
  List<Object> get props => [];
}

class AppInitBlocEventAllowAnalytics extends AppInitBlocEvent {
  final bool allowAnalytics;

  AppInitBlocEventAllowAnalytics(this.allowAnalytics);

  @override
  List<Object> get props => [allowAnalytics];
}

abstract class AppInitBlocState extends Equatable {}

class AppInitBlocStateLoading extends AppInitBlocState {
  @override
  List<Object> get props => [];
}

class AppInitBlocStateReady extends AppInitBlocState {
  final bool firstStart;

  AppInitBlocStateReady(this.firstStart);

  @override
  List<Object> get props => [firstStart];
}

class AppInitBlocStateDone extends AppInitBlocState {
  @override
  List<Object> get props => [];
}

class AppInitBloc extends Bloc<AppInitBlocEvent, AppInitBlocState> {
  AppDB _db = AppDB();

  @override
  AppInitBlocState get initialState => AppInitBlocStateLoading();

  AppInitBloc() {
    add(AppInitBlocEventInit());
  }

  @override
  Stream<AppInitBlocState> mapEventToState(AppInitBlocEvent event) async* {
    if (event is AppInitBlocEventInit) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      await Logger.init();
      FlutterError.onError = (FlutterErrorDetails details) {
        Logger.log(details.toString());
      };

      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final Directory tmpDocDir = await getTemporaryDirectory();
      Hive.init(appDocDir.path);
      Hive.registerAdapter(AppDataAdapter(), 35);
      AppDB().documentPath = appDocDir.path;
      AppDB().tmpPath = tmpDocDir.path;

      final String dirPath = '${appDocDir.path}/Pictures/sgl';
      await Directory(dirPath).create(recursive: true);

      await _db.init();

      final AppData appData = _db.getAppData();

      if (appData.storeGeo == null) {
        final Map<String, String> localeToStoreGeo = {
          'en_US': 'us_us',
          'de_DE': 'eu_de',
          'fr_FR': 'eu_fr',
        };
        final String locale = await Devicelocale.currentLocale;
        AppDB().setStoreGeo(localeToStoreGeo[locale] ?? 'us_us');
      }

      FeedsAPI(); // force init

      if (appData.allowAnalytics == true) {
        _allowAnalytics();
      }
      yield AppInitBlocStateReady(appData.firstStart);
    } else if (event is AppInitBlocEventAllowAnalytics) {
      _db.setFirstStart(false);
      _db.setAllowAnalytics(event.allowAnalytics);
      if (event.allowAnalytics == true) {
        _allowAnalytics();
      }
      yield AppInitBlocStateDone();
    }
  }

  void _allowAnalytics() async {
    await FlutterMatomo.initializeTracker(
        'https://analytics.supergreenlab.com/piwik.php', 3);
    BlocSupervisor.delegate = AnalyticsBlocDelegate();
  }
}
