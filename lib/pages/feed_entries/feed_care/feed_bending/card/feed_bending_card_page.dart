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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/data/assets/feed_entry.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_care_common/card/feed_care_common_card_page.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';

class FeedBendingCardPage extends FeedCareCommonCardPage {
  static String get feedBendingCardPageTitle {
    return Intl.message(
      'Bending',
      name: 'feedBendingCardPageTitle',
      desc: 'Bending card title',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  FeedBendingCardPage(Animation<double> animation, FeedState feedState, FeedEntryState state,
      {Key? key, List<Widget> Function(BuildContext context, FeedEntryState feedEntryState)? cardActions})
      : super(animation, feedState, state, key: key, cardActions: cardActions);

  String iconPath() {
    return FeedEntryIcons[FE_BENDING]!;
  }

  @override
  String title() {
    return FeedBendingCardPage.feedBendingCardPageTitle;
  }
}
