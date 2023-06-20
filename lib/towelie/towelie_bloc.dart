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

import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/notifications/notifications.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';
import 'package:super_green_app/towelie/buttons/combo/towelie_button_push_route_feed_media.dart';
import 'package:super_green_app/towelie/buttons/combo/towelie_button_push_route_measure.dart';
import 'package:super_green_app/towelie/buttons/misc/towelie_button_create_account.dart';
import 'package:super_green_app/towelie/buttons/misc/towelie_button_show_tip.dart';
import 'package:super_green_app/towelie/buttons/plant/towelie_button_plant_germinate.dart';
import 'package:super_green_app/towelie/buttons/plant/towelie_button_plant_phase.dart';
import 'package:super_green_app/towelie/buttons/plant/towelie_button_plant_start_seedling.dart';
import 'package:super_green_app/towelie/buttons/plant/towelie_button_plant_type.dart';
import 'package:super_green_app/towelie/buttons/reminder/towelie_button_reminder.dart';
import 'package:super_green_app/towelie/helpers/combo/towelie_action_help_measure_after_stretch.dart';
import 'package:super_green_app/towelie/helpers/device/towelie_action_help_add_device.dart';
import 'package:super_green_app/towelie/helpers/device/towelie_action_help_add_existing_device.dart';
import 'package:super_green_app/towelie/helpers/device/towelie_action_help_select_device.dart';
import 'package:super_green_app/towelie/helpers/device/towelie_action_help_select_new_plant_device.dart';
import 'package:super_green_app/towelie/helpers/device/towelie_action_help_select_plant_device_box.dart';
import 'package:super_green_app/towelie/helpers/device/towelie_action_help_test_device.dart';
import 'package:super_green_app/towelie/helpers/device/towelie_action_help_wifi.dart';
import 'package:super_green_app/towelie/helpers/form/towelie_action_help_form_measure.dart';
import 'package:super_green_app/towelie/helpers/form/towelie_action_help_take_pic.dart';
import 'package:super_green_app/towelie/helpers/misc/towelie_action_help_notification.dart';
import 'package:super_green_app/towelie/helpers/plant/towelie_action_help_create_lab.dart';
import 'package:super_green_app/towelie/helpers/plant/towelie_action_help_create_plant.dart';
import 'package:super_green_app/towelie/helpers/reminders/towelie_action_help_measure_reminder.dart';
import 'package:super_green_app/towelie/helpers/reminders/towelie_action_help_water_reminder.dart';
import 'package:super_green_app/towelie/towelie_action.dart';
import 'package:super_green_app/towelie/towelie_button.dart';

abstract class TowelieBlocEvent extends Equatable {}

class TowelieBlocEventAppInit extends TowelieBlocEvent {
  TowelieBlocEventAppInit();

  @override
  List<Object> get props => [];
}

class TowelieBlocEventHelperNext extends TowelieBlocEvent {
  final int rand = Random().nextInt(1 << 32);
  final RouteSettings settings;

  TowelieBlocEventHelperNext(this.settings);

  @override
  List<Object> get props => [rand, settings];
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

class TowelieBlocEventPlantCreated extends TowelieBlocEvent {
  final Plant plant;

  TowelieBlocEventPlantCreated(this.plant);

  @override
  List<Object> get props => [plant];
}

class TowelieBlocEventFeedEntryCreated extends TowelieBlocEvent {
  final Plant plant;
  final FeedEntry feedEntry;

  TowelieBlocEventFeedEntryCreated(this.plant, this.feedEntry);

  @override
  List<Object> get props => [plant];
}

class TowelieBlocEventTrigger extends TowelieBlocEvent {
  final String currentRoute;
  final String triggerID;
  final dynamic parameters;

  TowelieBlocEventTrigger(this.triggerID, this.parameters, this.currentRoute);

  @override
  List<Object> get props => [triggerID, parameters];
}

class TowelieBlocEventButtonPressed extends TowelieBlocEvent {
  final int rand = Random().nextInt(1 << 32);
  final Map<String, dynamic> params;
  final dynamic feed;
  final dynamic feedEntry;

  TowelieBlocEventButtonPressed(this.params, {this.feed, this.feedEntry});

  @override
  List<Object> get props => [rand, params, feed, feedEntry];
}

class TowelieBlocState extends Equatable {
  @override
  List<Object?> get props => [];
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

class TowelieBlocStateLocalNotification extends TowelieBlocState {
  final int rand = Random().nextInt(1 << 32);
  final NotificationsBlocEventReminder localNotificationBlocEventReminder;

  TowelieBlocStateLocalNotification(this.localNotificationBlocEventReminder);

  @override
  List<Object> get props => [rand, localNotificationBlocEventReminder];
}

class TowelieBlocStateHelper extends TowelieBlocState {
  final int rand = Random().nextInt(1 << 32);
  final RouteSettings settings;
  final String text;
  final bool hasNext;
  final List<Map<String, dynamic>>? buttons;

  TowelieBlocStateHelper(this.settings, this.text, {this.hasNext = false, this.buttons});

  @override
  List<Object?> get props => [rand, settings, text, hasNext, buttons];
}

class TowelieBlocStateHelperPop extends TowelieBlocState {
  final int rand = Random().nextInt(1 << 32);
  final RouteSettings settings;

  TowelieBlocStateHelperPop(this.settings);

  @override
  List<Object> get props => [rand, settings];
}

class TowelieBloc extends LegacyBloc<TowelieBlocEvent, TowelieBlocState> {
  static List<TowelieAction> actions = [
    TowelieActionHelpCreatePlant(),
    TowelieActionHelpCreateLab(),
    TowelieActionHelpSelectDevice(),
    TowelieActionHelpAddDevice(),
    TowelieActionHelpAddExistingDevice(),
    TowelieActionHelpSelectNewPlantDevice(),
    TowelieActionHelpSelectPlantDeviceBox(),
    TowelieActionHelpTestDevice(),
    TowelieActionHelpWifi(),
    TowelieActionHelpFormMeasure(),
    TowelieActionHelpFormTakePic(),
    TowelieActionHelpMeasureReminder(),
    TowelieActionHelpWaterReminder(),
    TowelieActionHelpMeasureAfterStretch(),
    TowelieActionHelpNotification(),
  ];

  static List<TowelieButton> buttons = [
    // Plant onboarding
    TowelieButtonPlantSeedPhase(),
    TowelieButtonPlantSeedlingPhase(),
    TowelieButtonPlantVegPhase(),
    TowelieButtonPlantBloomPhase(),
    TowelieButtonPlantAuto(),
    TowelieButtonPlantPhoto(),
    TowelieButtonStartSeedling(),
    TowelieButtonPlantGerminate(),
    TowelieButtonShowTip(),

    // Push routes
    TowelieButtonPushRouteFeedMedia(),
    TowelieButtonPushRouteMeasure(),

    // Reminder
    TowelieButtonReminder(),

    // Misc
    TowelieButtonCreateAccount(),
  ];

  TowelieBloc() : super(TowelieBlocState());

  @override
  Stream<TowelieBlocState> mapEventToState(TowelieBlocEvent event) async* {
    if (event is TowelieBlocEventButtonPressed) {
      for (int i = 0; i < buttons.length; ++i) {
        if (buttons[i].id == event.params['id']) {
          yield* buttons[i].buttonPressed(event);
        }
      }
    } else {
      for (int i = 0; i < actions.length; ++i) {
        yield* actions[i].eventReceived(event);
      }
    }
  }
}
