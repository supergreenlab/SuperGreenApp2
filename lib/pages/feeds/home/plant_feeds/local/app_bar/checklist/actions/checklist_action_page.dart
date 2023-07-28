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
import 'package:super_green_app/data/rel/checklist/actions.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class ChecklistActionPage extends StatelessWidget {

  final ChecklistSeed checklistSeed;
  final ChecklistAction checklistAction;

  const ChecklistActionPage({Key? key, required this.checklistSeed, required this.checklistAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('${checklistSeed.title} ${checklistAction.type}');

    /*return AppBarAction(
        icon: FeedEntryIcons[FE_WATER]!,
        color: Color(0xFF506EBA),
        title: 'LAST WATERING',
        titleIcon: wateringAlert(state) ? Icon(Icons.warning, size: 20, color: Colors.red) : null,
        content: AutoSizeText(
          state.watering.length != 0
              ? DateRenderer.renderDuration(DateTime.now().difference(state.watering[0].date))
              : 'No watering yet',
          maxLines: 1,
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w300,
              color: wateringAlert(state) ? Colors.orange : Colors.green),
        ),
        action: _onAction(
            context,
            ({pushAsReplacement = false}) => MainNavigateToFeedWaterFormEvent(state.plant,
                pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)),
            tipID: 'TIP_WATERING',
            tipPaths: [
              't/supergreenlab/SuperGreenTips/master/s/when_to_water_seedling/l/en',
              't/supergreenlab/SuperGreenTips/master/s/how_to_water/l/en'
            ]),
        actionIcon: SvgPicture.asset('assets/app_bar/icon_watering.svg'),
      );
                
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

      void Function(Future<dynamic>?) futureFn(BuildContext context, AppbarChecklistBlocStateLoaded state) {
        return (Future<dynamic>? future) async {
          dynamic feedEntry = await future;
          if (feedEntry != null && feedEntry is FeedEntry) {
            BlocProvider.of<TowelieBloc>(context).add(TowelieBlocEventFeedEntryCreated(state.plant, feedEntry));
          }
        };
      }*/
  }

}