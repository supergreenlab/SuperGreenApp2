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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/buttons/combo/towelie_button_push_route_measure.dart';
import 'package:super_green_app/towelie/towelie_action_help.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

class TowelieActionHelpMeasureAfterStretch extends TowelieActionHelp {
  static String get towelieHelperMeasureAfterStretch {
    return Intl.message(
      '**Hey**! it might be a good idea to **take a measure** of your plant to **monitor the stretch**.',
      name: 'towelieHelperMeasureAfterStretch',
      desc: 'Towelie Helper measure after stretch',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  @override
  String get feedEntryType => 'FE_LIGHT';

  @override
  Stream<TowelieBlocState> feedEntryTrigger(TowelieBlocEventFeedEntryCreated event) async* {
    yield TowelieBlocStateHelper(
      RouteSettings(name: '/feed/plant', arguments: null),
      TowelieActionHelpMeasureAfterStretch.towelieHelperMeasureAfterStretch,
      buttons: [
        TowelieButtonPushRouteMeasure.createButton('Take measure', event.plant.id),
      ],
    );
  }
}
