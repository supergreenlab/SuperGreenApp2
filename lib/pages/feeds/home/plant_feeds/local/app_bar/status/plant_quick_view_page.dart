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
import 'package:intl/intl.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/metrics/app_bar_metrics_page.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/widgets/app_bar_tab.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/widgets/app_bar_title.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/app_bar/checklist/appbar_checklist_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/app_bar/checklist/appbar_checklist_page.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/app_bar/status/plant_quick_view_bloc.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class PlantQuickViewPage extends StatelessWidget {
  static String get plantQuickViewPageLoadingPlantData {
    return Intl.message(
      'Loading plant data',
      name: 'productsPageLoadingPlantData',
      desc: 'Products page loading plant data',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlantQuickViewBloc, PlantQuickViewBlocState>(
      listener: (BuildContext context, PlantQuickViewBlocState state) {
        if (state is PlantQuickViewBlocStateLoaded) {}
      },
      child: BlocBuilder<PlantQuickViewBloc, PlantQuickViewBlocState>(
          bloc: BlocProvider.of<PlantQuickViewBloc>(context),
          builder: (BuildContext context, PlantQuickViewBlocState state) {
            if (state is PlantQuickViewBlocStateInit) {
              return AppBarTab(child: _renderLoading(context, state));
            }
            return AppBarTab(child: _renderLoaded(context, state as PlantQuickViewBlocStateLoaded));
          }),
    );
  }

  Widget _renderLoading(BuildContext context, PlantQuickViewBlocStateInit state) {
    return FullscreenLoading(
      title: PlantQuickViewPage.plantQuickViewPageLoadingPlantData,
    );
  }

  Widget _renderLoaded(BuildContext context, PlantQuickViewBlocStateLoaded state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppBarTitle(title: 'Quick view', plant: state.plant, body: AppBarBoxMetricsPage()),
        Expanded(child: _renderActions(context, state)),
      ],
    );
  }

  Widget _renderActions(BuildContext context, PlantQuickViewBlocStateLoaded state) {
    return BlocProvider(
      create: (BuildContext context) => AppbarChecklistBloc(state.plant),
      child: AppbarChecklistPage(),
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

  bool wateringAlert(PlantQuickViewBlocStateLoaded state) {
    Duration period = Duration(days: 8);
    if (state.watering.length == 0) {
      return true;
    }
    if (state.watering.length >= 2) {
      period = state.watering[0].date.difference(state.watering[1].date);
    }
    return DateTime.now().difference(state.watering[0].date).inSeconds > period.inSeconds * 0.85;
  }

  bool mediaAlert(PlantQuickViewBlocStateLoaded state) {
    if (state.media == null) {
      return true;
    }
    Duration period = Duration(days: 3);
    return DateTime.now().difference(state.media!.date).inSeconds > period.inSeconds;
  }

  void Function(Future<dynamic>?) futureFn(BuildContext context, PlantQuickViewBlocStateLoaded state) {
    return (Future<dynamic>? future) async {
      dynamic feedEntry = await future;
      if (feedEntry != null && feedEntry is FeedEntry) {
        BlocProvider.of<TowelieBloc>(context).add(TowelieBlocEventFeedEntryCreated(state.plant, feedEntry));
      }
    };
  }
}
