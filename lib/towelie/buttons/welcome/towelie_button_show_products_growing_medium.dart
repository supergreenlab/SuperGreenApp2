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
import 'package:super_green_app/towelie/cards/welcome/card_products_growing_medium.dart';
import 'package:super_green_app/towelie/towelie_button.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

const _showProductsID = 'SHOW_PRODUCTS_GROWING_MEDIUM';

class TowelieButtonShowProductsGrowingMedium extends TowelieButton {
  static String get towelieButtonShowGrowingMedium {
    return Intl.message(
      '''Next''',
      name: 'towelieButtonShowGrowingMedium',
      desc: 'Towelie button go to products growing medium',
      locale: SGLLocalizations.current.localeName,
    );
  }

  @override
  String get id => _showProductsID;

  static Map<String, dynamic> createButton() =>
      TowelieButton.createButton(_showProductsID, {
        'title': TowelieButtonShowProductsGrowingMedium
            .towelieButtonShowGrowingMedium,
      });

  @override
  Stream<TowelieBlocState> buttonPressed(
      TowelieBlocEventButtonPressed event) async* {
    Feed feed = await RelDB.get().feedsDAO.getFeed(event.feed);
    FeedEntry feedEntry = await RelDB.get().feedsDAO.getFeedEntry(event.feedEntry);
    await CardProductsGrowingMedium.createProductsGrowingMedium(feed);
    await selectButtons(feedEntry, selectedButtonID: id);
  }
}
