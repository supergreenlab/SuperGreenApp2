/*
 * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
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

import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/misc/bloc.dart';

abstract class PlantQuickViewBlocEvent extends Equatable {}

class PlantQuickViewBlocEventInit extends PlantQuickViewBlocEvent {
  @override
  List<Object?> get props => [];
}

class PlantQuickViewBlocEventLoaded extends PlantQuickViewBlocEvent {
  final PlantQuickViewBlocStateLoaded state;

  PlantQuickViewBlocEventLoaded(this.state);

  @override
  List<Object?> get props => [state];
}

abstract class PlantQuickViewBlocState extends Equatable {}

class PlantQuickViewBlocStateInit extends PlantQuickViewBlocState {
  final Plant plant;

  PlantQuickViewBlocStateInit(this.plant);

  @override
  List<Object?> get props => [plant];
}

class PlantQuickViewBlocStateLoaded extends PlantQuickViewBlocState {
  final Plant plant;

  final List<FeedEntry> watering;
  final FeedEntry? media;

  PlantQuickViewBlocStateLoaded(this.plant, this.watering, this.media);

  @override
  List<Object?> get props => [this.plant, this.watering, this.media];
}

class PlantQuickViewBloc extends LegacyBloc<PlantQuickViewBlocEvent, PlantQuickViewBlocState> {
  final Plant plant;
  Device? device;
  late Box box;

  late List<FeedEntry> watering;
  FeedEntry? media;

  late StreamSubscription wateringSub;
  late StreamSubscription mediaSub;

  PlantQuickViewBloc(this.plant) : super(PlantQuickViewBlocStateInit(plant)) {
    add(PlantQuickViewBlocEventInit());
  }

  @override
  Stream<PlantQuickViewBlocState> mapEventToState(PlantQuickViewBlocEvent event) async* {
    if (event is PlantQuickViewBlocEventInit) {
      final db = RelDB.get();
      watering = await db.feedsDAO.getFeedEntriesForFeedWithType(plant.feed, 'FE_WATER');
      media = await db.feedsDAO.getLastFeedEntryForFeedWithType(plant.feed, 'FE_MEDIA');
      wateringSub = db.feedsDAO.watchFeedEntriesForFeedWithType(plant.feed, 'FE_WATER').listen(onWateringChange);
      mediaSub = db.feedsDAO.watchLastFeedEntryForFeedWithType(plant.feed, 'FE_MEDIA').listen(onMediaChange);
      yield PlantQuickViewBlocStateLoaded(plant, watering, media);
    } else if (event is PlantQuickViewBlocEventLoaded) {
      yield event.state;
    }
  }

  void onWateringChange(List<FeedEntry> value) {
    watering = value;
    add(PlantQuickViewBlocEventLoaded(PlantQuickViewBlocStateLoaded(plant, watering, media)));
  }

  void onMediaChange(FeedEntry? value) {
    media = value;
    add(PlantQuickViewBlocEventLoaded(PlantQuickViewBlocStateLoaded(plant, watering, media)));
  }

  @override
  Future<void> close() async {
    await wateringSub.cancel();
    await mediaSub.cancel();
    return super.close();
  }
}
