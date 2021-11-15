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

import 'package:super_green_app/towelie/towelie_action.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

abstract class TowelieActionHelp extends TowelieAction {
  String? get route => null;
  String? get feedEntryType => null;
  String? get triggerID => null;

  Stream<TowelieBlocState> idTrigger(TowelieBlocEventTrigger event) async* {}
  Stream<TowelieBlocState> routeTrigger(TowelieBlocEventRoute event) async* {}
  Stream<TowelieBlocState> feedEntryTrigger(TowelieBlocEventFeedEntryCreated event) async* {}
  Stream<TowelieBlocState> getNext(TowelieBlocEventHelperNext event) async* {}

  @override
  Stream<TowelieBlocState> eventReceived(TowelieBlocEvent event) async* {
    if (event is TowelieBlocEventHelperNext && event.settings.name == route) {
      yield* getNext(event);
    } else if (event is TowelieBlocEventRoute && event.settings.name == route) {
      yield* routeTrigger(event);
    } else if (event is TowelieBlocEventFeedEntryCreated && event.feedEntry.type == feedEntryType) {
      yield* feedEntryTrigger(event);
    } else if (event is TowelieBlocEventTrigger) {
      yield* idTrigger(event);
    } else if (event is TowelieBlocEventRoutePop && event.settings.name == route) {
      yield TowelieBlocStateHelperPop(event.settings);
    }
  }
}
