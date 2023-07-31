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

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/checklist/actions.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/data/assets/feed_entry.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/widgets/app_bar_action.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

class ChecklistActionPage extends StatelessWidget {
  final Plant plant;
  final ChecklistSeed checklistSeed;
  final ChecklistAction checklistAction;

  const ChecklistActionPage({Key? key, required this.plant, required this.checklistSeed, required this.checklistAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: AppBarAction(
        icon: FeedEntryIcons[FE_WATER]!,
        color: Color(0xFF506EBA),
        title: checklistSeed.title,
        titleIcon: Icon(Icons.warning, size: 20, color: Colors.red),
        content: AutoSizeText(
          'Water plant',
          maxLines: 1,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w300,
            color: Colors.green,
          ),
        ),
        action: _onAction(
            context,
            ({pushAsReplacement = false}) => MainNavigateToFeedWaterFormEvent(plant,
                pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, plant)),
            tipID: 'TIP_WATERING',
            tipPaths: [
              't/supergreenlab/SuperGreenTips/master/s/when_to_water_seedling/l/en',
              't/supergreenlab/SuperGreenTips/master/s/how_to_water/l/en'
            ]),
        actionIcon: SvgPicture.asset('assets/app_bar/icon_watering.svg'),
      ),
    );
  }

  // TODO DRY this with plant_feed_page
  void Function() _onAction(BuildContext context, MainNavigatorEvent Function({bool pushAsReplacement}) navigatorEvent,
      {String? tipID, List<String>? tipPaths}) {
    return () {
      if (tipPaths != null && !AppDB().isTipDone(tipID!)) {
        BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToTipEvent(
            tipID, tipPaths, navigatorEvent(pushAsReplacement: true) as MainNavigateToFeedFormEvent));
      } else {
        BlocProvider.of<MainNavigatorBloc>(context).add(navigatorEvent());
      }
    };
  }

  void Function(Future<dynamic>?) futureFn(BuildContext context, Plant plant) {
    return (Future<dynamic>? future) async {
      dynamic feedEntry = await future;
      if (feedEntry != null && feedEntry is FeedEntry) {
        BlocProvider.of<TowelieBloc>(context).add(TowelieBlocEventFeedEntryCreated(plant, feedEntry));
      }
    };
  }
}
