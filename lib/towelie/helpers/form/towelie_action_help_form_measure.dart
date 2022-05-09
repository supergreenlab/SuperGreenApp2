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

class TowelieActionHelpFormMeasure extends TowelieActionHelp {
  static String get towelieHelperFormMeasure {
    return Intl.message(
      'This is the **measuring tool**, while not perfectly accurate, it will still give you a **good hint for your next grow**. And as a **bonus feature**, it does **timelapses** of all the measures you\'ve taken!',
      name: 'towelieHelperFormMeasure',
      desc: 'Towelie Helper measure form 2',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get towelieHelperFormMeasure2 {
    return Intl.message(
      'It\'s the **first time** you\'re using it, so there is no "before" picture **to compare to**. Take a pic of what you **want to measure**, and take a measure again in **a few days** to have a **difference**.',
      name: 'towelieHelperFormMeasure2',
      desc: 'Towelie Helper measure form 2',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get towelieHelperFormMeasure3 {
    return Intl.message(
      'Looks like you **already took a measure**, you can select it in the **"Previous measures"** section, then press the **"Today\'s measure"** button to add a new measure. The previous one will be **displayed as a transparent overlay** for more accuracy.',
      name: 'towelieHelperFormMeasure3',
      desc: 'Towelie Helper measure form 3',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  @override
  String get route => '/feed/form/measure';

  @override
  Stream<TowelieBlocState> routeTrigger(TowelieBlocEventRoute event) async* {
    int nMeasures = await RelDB.get().feedsDAO.getNMeasures();
    if (nMeasures == 0) {
      yield TowelieBlocStateHelper(event.settings, TowelieActionHelpFormMeasure.towelieHelperFormMeasure,
          hasNext: true);
    } else if (nMeasures == 1) {
      yield TowelieBlocStateHelper(event.settings, TowelieActionHelpFormMeasure.towelieHelperFormMeasure3,
          hasNext: false);
    }
  }

  @override
  Stream<TowelieBlocState> getNext(TowelieBlocEventHelperNext event) async* {
    int nMeasures = await RelDB.get().feedsDAO.getNMeasures();
    if (nMeasures == 0) {
      yield TowelieBlocStateHelper(event.settings, TowelieActionHelpFormMeasure.towelieHelperFormMeasure2);
    }
  }
}
