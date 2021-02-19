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

class TowelieActionHelpFormTakePic extends TowelieActionHelp {
  static String get towelieHelperFormTakePic {
    return Intl.message(
      'Welcome to the **take pic** page, this screen is to take picture of your plant **and note observations**. **You\'ll be glad you took pictures regularly during your next grow!**',
      name: 'towelieHelperFormTakePic',
      desc: 'Towelie Helper form take pic',
      locale: SGLLocalizations.current.localeName,
    );
  }

  @override
  String get route => '/feed/form/media';

  @override
  Stream<TowelieBlocState> routeTrigger(TowelieBlocEventRoute event) async* {
    int nPics = await RelDB.get().feedsDAO.getNFeedEntriesWithType('FE_MEDIA').getSingle();
    if (nPics == 0) {
      yield TowelieBlocStateHelper(event.settings, TowelieActionHelpFormTakePic.towelieHelperFormTakePic);
    }
  }
}
