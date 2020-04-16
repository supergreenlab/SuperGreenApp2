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

class TowelieActionHelpCreatePlant extends TowelieActionHelp {
  
  static String get towelieHelperCreatePlant {
    return Intl.message(
      '''Hey man, **welcome to the plant creation process**, I\'ll be there to guide you through it.
First step is to **give your new plant a name**.''',
      name: 'towelieHelperCreatePlant',
      desc: 'Towelie Helper Create Plant',
      locale: SGLLocalizations.current.localeName,
    );
  }

  @override
  String get route => '/plant/new';

  @override
  Stream<TowelieBlocState> routeTrigger(TowelieBlocEventRoute event) async* {
    final bdb = RelDB.get().plantsDAO;
    int nPlants = await bdb.nPlants().getSingle();
    if (nPlants == 0) {
      yield TowelieBlocStateHelper(
          event.settings, TowelieActionHelpCreatePlant.towelieHelperCreatePlant);
    }
  }
}
