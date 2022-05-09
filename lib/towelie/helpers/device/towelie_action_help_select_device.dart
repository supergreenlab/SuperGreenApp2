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

import 'package:intl/intl.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/towelie/towelie_action_help.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

class TowelieActionHelpSelectDevice extends TowelieActionHelp {
  static String get towelieHelperSelectDevice {
    return Intl.message(
      '''Alright, now that your plant has a name we can **start its configuration**:)
If you own a **SuperGreenLab bundle**, you need to tell the app **which controller will control the plant's lights, ventilation and sensors**.
Because it\'s all brand new, let\'s first **setup a new controller**.
If you don\'t own a bundle, you can skip this by pressing "NO SGL DEVICE".''',
      name: 'towelieHelperSelectDevice',
      desc: 'Towelie Helper Select plant device',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  @override
  String get route => '/plant/device';

  @override
  Stream<TowelieBlocState> routeTrigger(TowelieBlocEventRoute event) async* {
    final ddb = RelDB.get().devicesDAO;
    int nDevices = await ddb.nDevices().getSingle();
    if (nDevices == 0) {
      yield TowelieBlocStateHelper(event.settings, TowelieActionHelpSelectDevice.towelieHelperSelectDevice);
    }
  }
}
