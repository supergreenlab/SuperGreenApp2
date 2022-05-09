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

class TowelieActionHelpCreateLab extends TowelieActionHelp {
  static String get towelieHelperCreateLab {
    return Intl.message(
      '''Now we're creating our **first Lab**!
A lab is where you **simulate a tiny ecosystem**
with artificial **lights and ventilation**.''',
      name: 'towelieHelperCreateLab',
      desc: 'Towelie Helper create lab',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  @override
  String get route => '/plant/box';

  @override
  Stream<TowelieBlocState> routeTrigger(TowelieBlocEventRoute event) async* {
    final bdb = RelDB.get().plantsDAO;
    int nBoxes = await bdb.nBoxes().getSingle();
    if (nBoxes == 0) {
      yield TowelieBlocStateHelper(event.settings, TowelieActionHelpCreateLab.towelieHelperCreateLab);
    }
  }
}
