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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/pages/feed_entries/common/comments/card/comments_card_page.dart';
import 'package:super_green_app/pages/feed_entries/common/social_bar/social_bar_page.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_ventilation.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/form/feed_ventilation_form_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/section_title.dart';

class FeedVentilationCardPage extends StatelessWidget {
  final Animation animation;
  final FeedState feedState;
  final FeedEntryState state;

  const FeedVentilationCardPage(this.animation, this.feedState, this.state,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is FeedEntryStateLoaded) {
      return _renderLoaded(context, state);
    }
    return _renderLoading(context);
  }

  Widget _renderLoading(BuildContext context) {
    return FeedCard(
      animation: animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedCardTitle(
            'assets/feed_card/icon_blower.svg',
            'Ventilation change',
            state.synced,
            showSyncStatus: !state.remoteState,
            showControls: !state.remoteState,
          ),
          Container(
            height: 120,
            alignment: Alignment.center,
            child: FullscreenLoading(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FeedCardDate(state, feedState),
          ),
        ],
      ),
    );
  }

  Widget _renderLoaded(BuildContext context, FeedEntryStateLoaded state) {
    FeedVentilationParams params = state.params;
    Widget body;
    if (params.values.blowerRefSource == null) {
      body = _renderLegacy();
    } else {
      body = _renderV3();
    }
    return FeedCard(
      animation: animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedCardTitle(
            'assets/feed_card/icon_blower.svg',
            'Ventilation change',
            state.synced,
            showSyncStatus: !state.remoteState,
            showControls: !state.remoteState,
            onDelete: () {
              BlocProvider.of<FeedBloc>(context)
                  .add(FeedBlocEventDeleteEntry(state));
            },
          ),
          body,
          SocialBarPage(
            state: state,
            feedState: feedState,
          ),
          CommentsCardPage(
            state: state,
            feedState: feedState,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FeedCardDate(state, feedState),
          ),
        ],
      ),
    );
  }

  Widget _renderV3() {
    FeedVentilationParams params = state.params;
    if (isTempSource(params.values.blowerRefSource)) {
      return _renderTemperatureMode();
    } else if (isTimerSource(params.values.blowerRefSource)) {
      return _renderTimerMode();
    } else if (params.values.blowerRefSource == 0) {
      return _renderManualMode();
    }
    return Fullscreen(
      child: Icon(Icons.upgrade),
      title:
          'Unknown blower reference source, you might need to upgrade the app.',
    );
  }

  Widget _renderTemperatureMode() {
    FeedVentilationParams params = state.params;
    String unit = AppDB().getAppData().freedomUnits == true ? '°F' : '°C';
    List<Widget> cards = [
      renderCard(
          'assets/feed_card/icon_blower.svg',
          8,
          'Low temperature\nsettings',
          Column(
            children: [
              Text('${params.values.blowerMin}%',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 30,
                      color: Colors.lightBlue)),
              Text(
                  'at ${_tempUnit(params.values.blowerRefMin.toDouble())}$unit',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),
            ],
          )),
      renderCard(
          'assets/feed_card/icon_blower.svg',
          8,
          'High temperature\nsettings',
          Column(
            children: [
              Text('${params.values.blowerMax}%',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 30,
                      color: Colors.red)),
              Text(
                  'at ${_tempUnit(params.values.blowerRefMax.toDouble())}$unit',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),
            ],
          )),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Text('Temperature mode',
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      Container(
        height: 155,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: cards,
          ),
        ),
      )
    ]);
  }

  Widget _renderTimerMode() {
    FeedVentilationParams params = state.params;
    List<Widget> cards = [
      renderCard(
          'assets/feed_card/icon_blower.svg',
          8,
          'Night settings',
          Column(
            children: [
              Text('${params.values.blowerMin}%',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 30,
                      color: Colors.blue)),
            ],
          )),
      renderCard(
          'assets/feed_card/icon_blower.svg',
          8,
          'Day settings',
          Column(
            children: [
              Text('${params.values.blowerMax}%',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 30,
                      color: Colors.orange)),
            ],
          )),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child:
            Text('Timer mode', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      Container(
        height: 130,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: cards,
          ),
        ),
      )
    ]);
  }

  Widget _renderManualMode() {
    FeedVentilationParams params = state.params;
    List<Widget> cards = [
      renderCard(
          'assets/feed_card/icon_blower.svg',
          8,
          'Blower power',
          Column(
            children: [
              Text('${params.values.blowerMin}%',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 30,
                      color: Colors.grey)),
            ],
          )),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child:
            Text('Manual mode', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      Container(
        height: 130,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: cards,
          ),
        ),
      )
    ]);
  }

  Widget _renderLegacy() {
    FeedVentilationParams params = state.params;
    return Container(
      height: 120,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _renderValues(
            [params.values.blowerDay, params.values.blowerNight],
            [params.initialValues.blowerDay, params.initialValues.blowerNight]),
      ),
    );
  }

  List<Widget> _renderValues(
      List<dynamic> values, List<dynamic> initialValues) {
    int i = 0;
    return values
        .map<Map<String, int>>((v) {
          return {
            'i': i,
            'from': initialValues[i++],
            'to': v,
          };
        })
        .where((v) => v['from'] != v['to'])
        .map<Widget>((v) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('${v['i'] == 0 ? 'Day' : 'Night'}',
                        style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('${v['from']}%',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w300)),
                    Icon(Icons.arrow_forward, size: 18),
                    Text('${v['to']}%',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Colors.green)),
                  ],
                ),
              ],
            ),
          );
        })
        .toList();
  }

  Widget renderCard(
      String icon, double iconPadding, String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
          width: 200,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xffdedede), width: 1),
              color: Colors.white,
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              SectionTitle(
                icon: icon,
                iconPadding: iconPadding,
                title: title,
                backgroundColor: Colors.transparent,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: child,
                ),
              )
            ],
          )),
    );
  }

  double _tempUnit(double temp) {
    if (AppDB().getAppData().freedomUnits == true) {
      return temp * 9 / 5 + 32;
    }
    return temp;
  }
}
