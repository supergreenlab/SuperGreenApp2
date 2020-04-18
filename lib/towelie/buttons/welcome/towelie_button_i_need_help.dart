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

import 'package:super_green_app/towelie/cards/welcome/card_create_plant.dart';
import 'package:super_green_app/towelie/cards/welcome/card_products_intro.dart';
import 'package:super_green_app/towelie/towelie_button.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

const _needHelpID = 'PLANT_I_NEED_HELP';

class TowelieButtonINeedHelp extends TowelieButton {
  @override
  String get id => _needHelpID;

  static Map<String, dynamic> createButton() =>
      TowelieButton.createButton(_needHelpID, {
        'title': 'Yes I want help!',
      });

  @override
  Stream<TowelieBlocState> buttonPressed(
      TowelieBlocEventButtonPressed event) async* {
    await CardProductsIntro.createProductsIntro(event.feed);
    await removeButtons(event.feedEntry, selectedButtonID: id);
  }
}

const _dontNeedHelpID = 'PLANT_I_DONT_NEED_HELP';

class TowelieButtonIDontNeedHelp extends TowelieButton {
  @override
  String get id => _dontNeedHelpID;

  static Map<String, dynamic> createButton() =>
      TowelieButton.createButton(_dontNeedHelpID, {
        'title': 'Nope already got it all.',
      });

  @override
  Stream<TowelieBlocState> buttonPressed(
      TowelieBlocEventButtonPressed event) async* {
    await CardCreatePlant.createCreatePlantCard(event.feed);
    await removeButtons(event.feedEntry, selectedButtonID: id);
  }
}
