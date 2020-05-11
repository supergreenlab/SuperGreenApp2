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


import 'package:flutter/material.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_care_common/card/feed_care_common_card_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_defoliation/card/feed_defoliation_card_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc_entry_state.dart';

class FeedDefoliationCardPage extends FeedCareCommonCardPage<FeedDefoliationCardBloc> {

  FeedDefoliationCardPage(Animation animation, FeedEntryState state, {Key key}) : super(animation, state, key: key);

  String iconPath() {
    return 'assets/feed_card/icon_defoliation.svg';
  }

  @override
  String title() {
    return "Defoliation";
  }

}
