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

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/box_settings.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';

class PlantInfos extends Equatable {
  final String name;
  final String? filePath;
  final String? thumbnailPath;
  final BoxSettings? boxSettings;
  final PlantSettings? plantSettings;
  final bool editable;

  PlantInfos(this.name, this.filePath, this.thumbnailPath, this.boxSettings, this.plantSettings, this.editable);

  @override
  List<Object?> get props => [name, filePath, thumbnailPath, boxSettings, plantSettings, editable];

  PlantInfos copyWith({
    String? name,
    String? filePath,
    String? thumbnailPath,
    BoxSettings? boxSettings,
    PlantSettings? plantSettings,
    bool? editable,
  }) =>
      PlantInfos(
        name ?? this.name,
        filePath ?? this.filePath,
        thumbnailPath ?? this.thumbnailPath,
        boxSettings ?? this.boxSettings,
        plantSettings ?? this.plantSettings,
        editable ?? this.editable,
      );
}

abstract class PlantInfosBlocEvent extends Equatable {}

class PlantInfosEventLoad extends PlantInfosBlocEvent {
  @override
  List<Object> get props => [];
}

class PlantInfosEventLoaded extends PlantInfosBlocEvent {
  final PlantInfos plantInfos;

  PlantInfosEventLoaded(this.plantInfos);

  @override
  List<Object> get props => [plantInfos];
}

class PlantInfosEventUpdate extends PlantInfosBlocEvent {
  final PlantInfos plantInfos;

  PlantInfosEventUpdate(this.plantInfos);

  @override
  List<Object> get props => [plantInfos];
}

class PlantInfosEventUpdatePhase extends PlantInfosBlocEvent {
  final PlantPhases phase;
  final DateTime date;

  PlantInfosEventUpdatePhase(this.phase, this.date);

  @override
  List<Object> get props => [phase, date];
}

abstract class PlantInfosBlocState extends Equatable {}

class PlantInfosBlocStateLoading extends PlantInfosBlocState {
  @override
  List<Object> get props => [];
}

class PlantInfosBlocStateLoaded extends PlantInfosBlocState {
  final PlantInfos plantInfos;

  PlantInfosBlocStateLoaded(this.plantInfos);

  @override
  List<Object> get props => [plantInfos];
}

class PlantInfosBloc extends Bloc<PlantInfosBlocEvent, PlantInfosBlocState> {
  final PlantInfosBlocDelegate delegate;

  PlantInfosBloc(this.delegate) : super(PlantInfosBlocStateLoading()) {
    delegate.init(add);
    add(PlantInfosEventLoad());
  }

  @override
  Stream<PlantInfosBlocState> mapEventToState(PlantInfosBlocEvent event) async* {
    if (event is PlantInfosEventLoad) {
      delegate.loadPlant();
    } else if (event is PlantInfosEventLoaded) {
      yield PlantInfosBlocStateLoaded(event.plantInfos);
    } else if (event is PlantInfosEventUpdate) {
      yield* delegate.updateSettings(event.plantInfos);
    } else if (event is PlantInfosEventUpdatePhase) {
      yield* delegate.updatePhase(event.phase, event.date);
    }
  }

  @override
  Future<void> close() async {
    await delegate.close();
    return super.close();
  }
}

abstract class PlantInfosBlocDelegate {
  PlantInfos? plantInfos;
  late Function(PlantInfosBlocEvent) add;

  void init(Function(PlantInfosBlocEvent) add) {
    this.add = add;
  }

  void loadPlant();
  Stream<PlantInfosBlocState> updateSettings(PlantInfos plantInfos);
  Stream<PlantInfosBlocState> updatePhase(PlantPhases phase, DateTime date);
  Future<void> close();

  void plantInfosLoaded(PlantInfos plantInfos) {
    this.plantInfos = plantInfos;
    add(PlantInfosEventLoaded(this.plantInfos!));
  }
}
