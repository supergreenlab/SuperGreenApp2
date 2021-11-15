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

import 'package:intl/intl.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/towelie_action_help.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

class TowelieActionHelpWifi extends TowelieActionHelp {
  static String get towelieHelperDeviceWifi {
    return Intl.message(
      '''**While not mandatory**, connecting your controller to your home wifi has a few benefits:
- receive software **upgrade** and bug fixes
- remote **monitoring**
- remote **control**''',
      name: 'towelieHelperDeviceWifi',
      desc: 'Towelie Helper Device wifi',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  @override
  String get route => '/device/wifi';

  @override
  Stream<TowelieBlocState> routeTrigger(TowelieBlocEventRoute event) async* {
    final ddb = RelDB.get().devicesDAO;
    int nDevices = await ddb.nDevices().getSingle();
    if (nDevices == 1) {
      yield TowelieBlocStateHelper(event.settings, TowelieActionHelpWifi.towelieHelperDeviceWifi);
    }
  }
}
