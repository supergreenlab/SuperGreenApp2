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

import 'package:super_green_app/misc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class QRCodeViewerBlocEvent extends Equatable {}

class QRCodeViewerBlocEventInit extends QRCodeViewerBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class QRCodeViewerBlocState extends Equatable {}

class QRCodeViewerBlocStateInit extends QRCodeViewerBlocState {
  final Plant plant;

  QRCodeViewerBlocStateInit(this.plant);

  @override
  List<Object> get props => [plant];
}

class QRCodeViewerBlocStateLoaded extends QRCodeViewerBlocState {
  final Plant plant;
  final Box box;

  QRCodeViewerBlocStateLoaded(this.plant, this.box);

  @override
  List<Object> get props => [plant, box];
}

class QRCodeViewerBloc extends LegacyBloc<QRCodeViewerBlocEvent, QRCodeViewerBlocState> {
  final MainNavigateToQRCodeViewer args;

  QRCodeViewerBloc(this.args) : super(QRCodeViewerBlocStateInit(args.plant)) {
    add(QRCodeViewerBlocEventInit());
  }

  @override
  Stream<QRCodeViewerBlocState> mapEventToState(QRCodeViewerBlocEvent event) async* {
    if (event is QRCodeViewerBlocEventInit) {
      Box box = await RelDB.get().plantsDAO.getBox(args.plant.box);
      yield QRCodeViewerBlocStateLoaded(args.plant, box);
    }
  }
}
