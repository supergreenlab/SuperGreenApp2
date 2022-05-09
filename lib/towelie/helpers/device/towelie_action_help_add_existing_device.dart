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

class TowelieActionHelpAddExistingDevice extends TowelieActionHelp {
  static String get towelieHelperAddExistingDevice {
    return Intl.message(
      '''Ok, so your controller is **already running** and **connected to your home wifi**, let\'s search for it over the network!
Enter the **name you gave it last time** (default is **supergreencontroller**), if you can\'t remember it, you can also type its **IP address**.
The **IP address** can be easily found on your **router\'s home page**.
To **access your router's homepage**: take the **IP** address of your **mobile phone** or **laptop**, replace the last digit by **1** and **type that** in a browser.''',
      name: 'towelieHelperAddExistingDevice',
      desc: 'Towelie Helper Add existing device',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  @override
  String get route => '/device/existing';

  @override
  Stream<TowelieBlocState> routeTrigger(TowelieBlocEventRoute event) async* {
    final ddb = RelDB.get().devicesDAO;
    int nDevices = await ddb.nDevices().getSingle();
    if (nDevices == 0) {
      yield TowelieBlocStateHelper(event.settings, TowelieActionHelpAddExistingDevice.towelieHelperAddExistingDevice);
    }
  }
}
