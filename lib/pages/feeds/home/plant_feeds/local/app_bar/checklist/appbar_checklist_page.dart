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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/data/rel/checklist/actions.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/app_bar/checklist/actions/checklist_action_page.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/app_bar/checklist/appbar_checklist_bloc.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:tuple/tuple.dart';

class AppbarChecklistPage extends TraceableStatefulWidget {
  @override
  _AppbarChecklistPageState createState() => _AppbarChecklistPageState();
}

class _AppbarChecklistPageState extends State<AppbarChecklistPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AppbarChecklistBloc, AppbarChecklistBlocState>(
      listener: (BuildContext context, AppbarChecklistBlocState state) {
        if (state is AppbarChecklistBlocStateCreated) {
          BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToChecklist(state.checklist));
        }
      },
      child: BlocBuilder<AppbarChecklistBloc, AppbarChecklistBlocState>(
          bloc: BlocProvider.of<AppbarChecklistBloc>(context),
          builder: (context, state) {
            Widget body = FullscreenLoading(
              title: 'Loading..',
            );
            if (state is AppbarChecklistBlocStateInit) {
              body = FullscreenLoading();
            } else if (state is AppbarChecklistBlocStateLoaded) {
              if (state.checklist == null) {
                body = _renderCreateChecklist(context, state);
              } else if (state.activeSeeds!.length == 0) {
                body = _renderEmpty(context, state);
              } else {
                body = _renderLoaded(context, state);
              }
            }
            return body;
          }),
    );
  }

  Widget _renderEmpty(BuildContext context, AppbarChecklistBlocStateLoaded state) {
    return Column(
      children: [
        _checklistButton(context, state),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Nothing for today. 👌",
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18, color: Color(0xff454545)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _renderCreateChecklist(BuildContext context, AppbarChecklistBlocStateLoaded state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Your checklist is empty.\n\nPress the button below to start using it.",
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18, color: Color(0xff454545)),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: GreenButton(
            title: 'Create checklist',
            onPressed: () {
              if (state.checklist != null) {
                BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToChecklist(state.checklist!));
              } else {
                BlocProvider.of<AppbarChecklistBloc>(context).add(AppbarChecklistBlocEventCreate());
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _renderLoaded(BuildContext context, AppbarChecklistBlocStateLoaded state) {
    return Column(
      children: [
        _checklistButton(context, state),
        Expanded(
          child: Column(
            children: state.actions!.map((Tuple2<ChecklistSeed, ChecklistAction> action) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ChecklistActionPage(checklistSeed: action.item1, checklistAction: action.item2),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _checklistButton(BuildContext context, AppbarChecklistBlocStateLoaded state) {
    return InkWell(
      onTap: () {
        BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToChecklist(state.checklist!));
      },
      child: Row(
        children: [
          Expanded(child: Container()),
          SvgPicture.asset('assets/checklist/icon_checklist.svg'),
          Text('OPEN CHECKLIST', style: TextStyle(color: Color(0xff3bb30b), decoration: TextDecoration.underline)),
        ],
      ),
    );
  }

  /*   Widget _renderActions(BuildContext context, PlantQuickViewBlocStateLoaded state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: AppBarAction(
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
          ),
        ),
        AppBarAction(
          icon: FeedEntryIcons[FE_MEDIA]!,
          color: Color(0xFF617682),
          title: 'LAST GROWLOG',
          titleIcon: mediaAlert(state) ? Icon(Icons.warning, size: 20, color: Colors.red) : null,
          content: AutoSizeText(
            state.media != null
                ? DateRenderer.renderDuration(DateTime.now().difference(state.media!.date))
                : 'No grow log yet',
            maxLines: 1,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w300, color: mediaAlert(state) ? Colors.orange : Colors.green),
          ),
          action: _onAction(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedMediaFormEvent(
                  plant: state.plant, pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state))),
          actionIcon: SvgPicture.asset('assets/app_bar/icon_growlog.svg'),
        ),
      ],
    );
  } */
}
