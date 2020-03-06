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

import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_create_box.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_dont_want_to_buy.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_got_sgl_bundle.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_i_ordered_one.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_i_want_one.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_no_sgl_bundle.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_not_received.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_view_box.dart';
import 'package:super_green_app/towelie/buttons/towelie_button_yes_received.dart';
import 'package:super_green_app/towelie/feed/towelie_action_box_created.dart';
import 'package:super_green_app/towelie/feed/towelie_appinit.dart';
import 'package:super_green_app/towelie/helpers/towelie_action_help_add_device.dart';
import 'package:super_green_app/towelie/helpers/towelie_action_help_add_existing_device.dart';
import 'package:super_green_app/towelie/helpers/towelie_action_help_create_box.dart';
import 'package:super_green_app/towelie/helpers/towelie_action_help_select_device.dart';
import 'package:super_green_app/towelie/helpers/towelie_action_help_test_device.dart';
import 'package:super_green_app/towelie/helpers/towelie_action_help_wifi.dart';
import 'package:super_green_app/towelie/towelie_action.dart';
import 'package:super_green_app/towelie/towelie_button.dart';

abstract class TowelieBlocEvent extends Equatable {}

class TowelieBlocEventAppInit extends TowelieBlocEvent {
  TowelieBlocEventAppInit();

  @override
  List<Object> get props => [];
}

class TowelieBlocEventRoute extends TowelieBlocEvent {
  final int rand = Random().nextInt(1 << 32);
  final RouteSettings settings;

  TowelieBlocEventRoute(this.settings);

  @override
  List<Object> get props => [rand, settings];
}

class TowelieBlocEventRoutePop extends TowelieBlocEvent {
  final int rand = Random().nextInt(1 << 32);
  final RouteSettings settings;

  TowelieBlocEventRoutePop(this.settings);

  @override
  List<Object> get props => [rand, settings];
}

class TowelieBlocEventBoxCreated extends TowelieBlocEvent {
  final Box box;

  TowelieBlocEventBoxCreated(this.box);

  @override
  List<Object> get props => [box];
}

class TowelieBlocEventCardButtonPressed extends TowelieBlocEvent {
  final int rand = Random().nextInt(1 << 32);
  final Map<String, dynamic> params;
  final Feed feed;
  final FeedEntry feedEntry;

  TowelieBlocEventCardButtonPressed(this.params, this.feed, this.feedEntry);

  @override
  List<Object> get props => [rand, params, feed, feedEntry];
}

class TowelieBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class TowelieBlocStateMainNavigation extends TowelieBlocState {
  final int rand = Random().nextInt(1 << 32);
  final MainNavigatorEvent mainNavigatorEvent;

  TowelieBlocStateMainNavigation(this.mainNavigatorEvent);

  @override
  List<Object> get props => [rand, mainNavigatorEvent];
}

class TowelieBlocStateHomeNavigation extends TowelieBlocState {
  final int rand = Random().nextInt(1 << 32);
  final HomeNavigatorEvent homeNavigatorEvent;

  TowelieBlocStateHomeNavigation(this.homeNavigatorEvent);

  @override
  List<Object> get props => [rand, homeNavigatorEvent];
}

class TowelieBlocStateHelper extends TowelieBlocState {
  final int rand = Random().nextInt(1 << 32);
  final RouteSettings settings;
  final String text;

  TowelieBlocStateHelper(this.settings, this.text);

  @override
  List<Object> get props => [rand, settings, text];
}

class TowelieBlocStateHelperPop extends TowelieBlocState {
  final int rand = Random().nextInt(1 << 32);
  final RouteSettings settings;

  TowelieBlocStateHelperPop(this.settings);

  @override
  List<Object> get props => [rand, settings];
}

class TowelieBloc extends Bloc<TowelieBlocEvent, TowelieBlocState> {
  static List<TowelieAction> actions = [
    TowelieActionAppInit(),
    TowelieActionBoxCreated(),
    TowelieActionHelpCreateBox(),
    TowelieActionHelpSelectDevice(),
    TowelieActionHelpAddDevice(),
    TowelieActionHelpAddExistingDevice(),
    TowelieActionHelpTestDevice(),
    TowelieActionHelpWifi(),
  ];
  static List<TowelieButton> buttons = [
    TowelieButtonGotSGLBundle(),
    TowelieButtonNoSGLBundle(),
    TowelieButtonYesReceived(),
    TowelieButtonNotReceived(),
    TowelieButtonIWantOne(),
    TowelieButtonIOrderedOne(),
    TowelieButtonDontWantToBuy(),
    TowelieButtonCreateBox(),
    TowelieButtonViewBox(),
  ];

  @override
  TowelieBlocState get initialState => TowelieBlocState();

  @override
  Stream<TowelieBlocState> mapEventToState(TowelieBlocEvent event) async* {
    if (event is TowelieBlocEventCardButtonPressed) {
      for (int i = 0; i < buttons.length; ++i) {
        yield* buttons[i].buttonPressed(event);
      }
    } else {
      for (int i = 0; i < actions.length; ++i) {
        yield* actions[i].eventReceived(event);
      }
    }
  }
}
