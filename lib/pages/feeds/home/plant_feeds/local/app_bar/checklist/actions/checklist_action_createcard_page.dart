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
import 'package:super_green_app/data/assets/feed_entry.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/data/rel/checklist/actions.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/widgets/app_bar_action.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/app_bar/checklist/actions/checklist_action_page.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

class ChecklistActionCreateCardButton extends ChecklistActionButton {
  ChecklistActionCreateCardButton(
      {required Plant plant,
      required Box box,
      required ChecklistSeed checklistSeed,
      required ChecklistAction checklistAction})
      : super(plant: plant, box: box, checklistSeed: checklistSeed, checklistAction: checklistAction);

  @override
  Widget build(BuildContext context) {
    Map<String, void Function() Function(BuildContext)> onActions = {
      FE_MEDIA: (BuildContext context) => _onAction(
            context,
            ({pushAsReplacement = false}) => MainNavigateToFeedMediaFormEvent(
                plant: plant, pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, plant)),
          ),
      FE_MEASURE: (BuildContext context) => _onAction(
            context,
            ({pushAsReplacement = false}) => MainNavigateToFeedMeasureFormEvent(plant,
                pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, plant)),
          ),
      FE_TRANSPLANT: (BuildContext context) => _onAction(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedTransplantFormEvent(plant,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, plant)),
              tipID: 'TIP_TRANSPLANT',
              tipPaths: [
                't/supergreenlab/SuperGreenTips/master/s/when_to_repot_your_seedling/l/en',
                't/supergreenlab/SuperGreenTips/master/s/how_to_transplant_your_seedling/l/en'
              ]),
      FE_BENDING: (BuildContext context) => _onAction(
          context,
          ({pushAsReplacement = false}) => MainNavigateToFeedBendingFormEvent(plant,
              pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, plant)),
          tipID: 'TIP_BENDING',
          tipPaths: ['t/supergreenlab/SuperGreenTips/master/s/how_to_low_stress_training_LST/l/en']),
      FE_FIMMING: (BuildContext context) => _onAction(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedFimmingFormEvent(plant,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, plant)),
              tipID: 'TIP_FIMMING',
              tipPaths: [
                't/supergreenlab/SuperGreenTips/master/s/when_to_top/l/en',
                't/supergreenlab/SuperGreenTips/master/s/how_to_top/l/en'
              ]),
      FE_TOPPING: (BuildContext context) => _onAction(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedToppingFormEvent(plant,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, plant)),
              tipID: 'TIP_TOPPING',
              tipPaths: [
                't/supergreenlab/SuperGreenTips/master/s/when_to_top/l/en',
                't/supergreenlab/SuperGreenTips/master/s/how_to_top/l/en'
              ]),
      FE_DEFOLIATION: (BuildContext context) => _onAction(
          context,
          ({pushAsReplacement = false}) => MainNavigateToFeedDefoliationFormEvent(plant,
              pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, plant)),
          tipID: 'TIP_DEFOLIATION',
          tipPaths: ['t/supergreenlab/SuperGreenTips/master/s/how_to_defoliate/l/en']),
      FE_TIMELAPSE: (BuildContext context) {
        return () {};
      },
      FE_NUTRIENT_MIX: (BuildContext context) => _onAction(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedNutrientMixFormEvent(plant,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, plant)),
              tipID: 'TIP_WATERING',
              tipPaths: [
                't/supergreenlab/SuperGreenTips/master/s/when_to_start_adding_nutrients/l/en',
                't/supergreenlab/SuperGreenTips/master/s/how_to_prepare_nutrients/l/en'
              ]),
      FE_WATER: (BuildContext context) => _onAction(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedWaterFormEvent(plant,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, plant)),
              tipID: 'TIP_WATERING',
              tipPaths: [
                't/supergreenlab/SuperGreenTips/master/s/when_to_water_seedling/l/en',
                't/supergreenlab/SuperGreenTips/master/s/how_to_water/l/en'
              ]),
      FE_LIGHT: (BuildContext context) => _onAction(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedLightFormEvent(box,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, plant)),
              tipID: 'TIP_STRETCH',
              tipPaths: [
                't/supergreenlab/SuperGreenTips/master/s/when_to_control_stretch_in_seedling/l/en',
                't/supergreenlab/SuperGreenTips/master/s/how_to_control_stretch_in_seedling/l/en',
              ]),
      FE_VENTILATION: (BuildContext context) => _onAction(
            context,
            ({pushAsReplacement = false}) => MainNavigateToFeedVentilationFormEvent(box,
                pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, plant)),
          ),
      FE_SCHEDULE: (BuildContext context) => _onAction(
          context,
          ({pushAsReplacement = false}) => MainNavigateToFeedScheduleFormEvent(box,
              pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, plant)),
          tipID: 'TIP_BLOOM',
          tipPaths: ['t/supergreenlab/SuperGreenTips/master/s/when_to_switch_to_bloom/l/en']),
      FE_SCHEDULE_VEG: (BuildContext context) => _onAction(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedScheduleFormEvent(box,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, plant)),),
      FE_SCHEDULE_BLOOM: (BuildContext context) => _onAction(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedScheduleFormEvent(box,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, plant)),),
      FE_SCHEDULE_AUTO: (BuildContext context) => _onAction(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedScheduleFormEvent(box,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, plant)),),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: AppBarAction(
        icon: FeedEntryIcons[(checklistAction as ChecklistActionCreateCard).entryType]!,
        color: FeedEntryColors[(checklistAction as ChecklistActionCreateCard).entryType]!,
        title: checklistSeed.title,
        content: AutoSizeText(
          'Create ${FeedEntryNames[(checklistAction as ChecklistActionCreateCard).entryType]!} card',
          maxLines: 1,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w300,
            color: Color(0xff454545),
          ),
        ),
        action: onActions[(checklistAction as ChecklistActionCreateCard).entryType]!(context),
        actionIcon: SvgPicture.asset(FeedEntryActionIcons[(checklistAction as ChecklistActionCreateCard).entryType]!),
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
