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
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/widgets/app_bar_action.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/metrics/app_bar_metrics_page.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/widgets/app_bar_tab.dart';
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
        _renderStatus(context, state),
        _renderActions(context, state),
      ],
    );
  }

  Widget _renderStatus(BuildContext context, PlantQuickViewBlocStateLoaded state) {
    return Column(
      children: [
        Text('Quick view', style: TextStyle(color: Color(0xFF494949), fontWeight: FontWeight.bold, fontSize: 25)),
        Container(height: 2, color: Color(0xFF777777)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('01/02/2022', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('Blooming - 3rd week', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        AppBarBoxMetricsPage(),
      ],
    );
  }

  Widget _renderActions(BuildContext context, PlantQuickViewBlocStateLoaded state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: AppBarAction(
              icon: 'assets/feed_card/icon_watering.svg',
              color: Color(0xFF506EBA),
              title: 'LAST WATERING',
              titleIcon: Icon(Icons.warning, size: 20, color: Colors.red),
              content: Text(
                state.watering != null
                    ? _renderDuration(DateTime.now().difference(state.watering!.date))
                    : 'No watering yet',
                style: TextStyle(fontSize: 18),
              ),
              action: InkWell(
                onTap: _onAction(
                    context,
                    ({pushAsReplacement = false}) => MainNavigateToFeedWaterFormEvent(state.plant,
                        pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)),
                    tipID: 'TIP_WATERING',
                    tipPaths: [
                      't/supergreenlab/SuperGreenTips/master/s/when_to_water_seedling/l/en',
                      't/supergreenlab/SuperGreenTips/master/s/how_to_water/l/en'
                    ]),
                child: SvgPicture.asset('assets/app_bar/icon_watering.svg'),
              )),
        ),
        AppBarAction(
            icon: 'assets/feed_card/icon_media.svg',
            color: Color(0xFF617682),
            title: 'LAST GROWLOG',
            content: Text(
              state.media != null ? _renderDuration(DateTime.now().difference(state.media!.date)) : 'No grow log yet',
              style: TextStyle(fontSize: 18),
            ),
            action: InkWell(
              onTap: _onAction(
                  context,
                  ({pushAsReplacement = false}) => MainNavigateToFeedMediaFormEvent(
                      plant: state.plant, pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state))),
              child: SvgPicture.asset('assets/app_bar/icon_growlog.svg'),
            )),
      ],
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

  void Function(Future<dynamic>?) futureFn(BuildContext context, PlantQuickViewBlocStateLoaded state) {
    return (Future<dynamic>? future) async {
      dynamic feedEntry = await future;
      if (feedEntry != null && feedEntry is FeedEntry) {
        BlocProvider.of<TowelieBloc>(context).add(TowelieBlocEventFeedEntryCreated(state.plant, feedEntry));
      }
    };
  }

  String _renderDuration(Duration diff, {suffix = ' ago'}) {
    int minuteDiff = diff.inMinutes;
    int hourDiff = diff.inHours;
    int dayDiff = diff.inDays;
    String format;
    if (minuteDiff < 1) {
      format = 'few seconds$suffix';
    } else if (minuteDiff < 60) {
      format = '$minuteDiff minute${minuteDiff > 1 ? 's' : ''}$suffix';
    } else if (hourDiff < 24) {
      format = '$hourDiff hour${hourDiff > 1 ? 's' : ''} ${minuteDiff % 60}min$suffix';
    } else {
      format = '$dayDiff day${dayDiff > 1 ? 's' : ''}$suffix';
    }
    return format;
  }
}
