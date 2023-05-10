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
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/pages/feed_entries/common/comments/card/comments_card_page.dart';
import 'package:super_green_app/pages/feed_entries/common/social_bar/social_bar_page.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_ventilation.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/card/feed_ventilation_card_legacy.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/card/feed_ventilation_card_v3.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class FeedVentilationCardPage extends StatelessWidget {
  static String get feedVentilationCardPageTitle {
    return Intl.message(
      'Ventilation change',
      name: 'feedVentilationCardPageTitle',
      desc: 'Feed ventilation card title',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedVentilationBlowerCardPageTitle {
    return Intl.message(
      'Blower change',
      name: 'feedVentilationBlowerCardPageTitle',
      desc: 'Feed ventilation blower card title',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedVentilationFanCardPageTitle {
    return Intl.message(
      'Fan change',
      name: 'feedVentilationFanCardPageTitle',
      desc: 'Feed ventilation fan card title',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedVentilationCardPageUpgrade {
    return Intl.message(
      'Unknown reference source, you might need to upgrade the app.',
      name: 'feedVentilationCardPageUpgrade',
      desc: 'Feed ventilation card upgrade',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedVentilationCardPageLowTempSettings {
    return Intl.message(
      'Low temperature\nsettings',
      name: 'feedVentilationCardPageLowTempSettings',
      desc: 'Feed ventilation card low temperature settings',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedVentilationCardPageHighTempSettings {
    return Intl.message(
      'High temperature\nsettings',
      name: 'feedVentilationCardPageHighTempSettings',
      desc: 'Feed ventilation card high temperature settings',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedVentilationCardPageTemperatureMode {
    return Intl.message(
      'Temperature mode',
      name: 'feedVentilationCardPageTemperatureMode',
      desc: 'Feed ventilation card temperature mode',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedVentilationCardPageLowHumiSettings {
    return Intl.message(
      'Low humidity\nsettings',
      name: 'feedVentilationCardPageLowHumiSettings',
      desc: 'Feed ventilation card low humidity settings',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedVentilationCardPageHighHumiSettings {
    return Intl.message(
      'High humidity\nsettings',
      name: 'feedVentilationCardPageHighHumiSettings',
      desc: 'Feed ventilation card high humidity settings',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedVentilationCardPageHumidityMode {
    return Intl.message(
      'Humidity mode',
      name: 'feedVentilationCardPageHumidityMode',
      desc: 'Feed ventilation card humidity mode',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedVentilationCardPageNightSettings {
    return Intl.message(
      'Night settings',
      name: 'feedVentilationCardPageNightSettings',
      desc: 'Feed ventilation card night settings',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedVentilationCardPageDaySettings {
    return Intl.message(
      'Day settings',
      name: 'feedVentilationCardPageDaySettings',
      desc: 'Feed ventilation card day settings',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedVentilationCardPageTimerMode {
    return Intl.message(
      'Timer mode',
      name: 'feedVentilationCardPageTimerMode',
      desc: 'Feed ventilation card timer mode',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedVentilationCardPagePower {
    return Intl.message(
      'Power',
      name: 'feedVentilationCardPagePower',
      desc: 'Feed ventilation card power',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedVentilationCardPageManualMode {
    return Intl.message(
      'Manual mode',
      name: 'feedVentilationCardPageManualMode',
      desc: 'Feed ventilation card manual mode',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedVentilationCardPageDay {
    return Intl.message(
      'Day',
      name: 'feedVentilationCardPageDay',
      desc: 'Label for the "Day" power settings',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedVentilationCardPageNight {
    return Intl.message(
      'Night',
      name: 'feedVentilationCardPageNight',
      desc: 'Label for the "Night" power settings',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  final Animation<double> animation;
  final FeedState feedState;
  final FeedEntryState state;
  final List<Widget> Function(BuildContext context, FeedEntryState feedEntryState)? cardActions;

  const FeedVentilationCardPage(this.animation, this.feedState, this.state, {Key? key, this.cardActions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is FeedEntryStateLoaded) {
      return _renderLoaded(context, state as FeedEntryStateLoaded);
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
            FeedVentilationCardPage.feedVentilationCardPageTitle,
            state.synced,
            showSyncStatus: !state.isRemoteState,
            showControls: !state.isRemoteState,
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
    FeedVentilationParams params = state.params as FeedVentilationParams;
    Widget body;
    String title = FeedVentilationCardPage.feedVentilationCardPageTitle;
    String icon = 'assets/feed_card/icon_blower.svg';
    if (params.values.blowerRefSource == null && params.values.fanRefSource == null) {
      body = FeedVentilationCardLegacy(params: state.params as FeedVentilationParams);
    } else {
      FeedVentilationCardV3Values values;
      if (params.values.fanRefSource != null) {
        title = FeedVentilationCardPage.feedVentilationFanCardPageTitle;
        icon = 'assets/feed_card/icon_ventilation_fan.png';
        values = FeedVentilationCardV3Values('Fan', params.values.fanRefSource!, params.values.fanRefMin!,
            params.values.fanRefMax!, params.values.fanMin!, params.values.fanMax!);
      } else {
        title = FeedVentilationCardPage.feedVentilationBlowerCardPageTitle;
        icon = 'assets/feed_card/icon_ventilation_blower.svg';
        values = FeedVentilationCardV3Values('Blower', params.values.blowerRefSource!, params.values.blowerRefMin!,
            params.values.blowerRefMax!, params.values.blowerMin!, params.values.blowerMax!);
      }
      body = FeedVentilationCardV3(values: values);
    }
    return FeedCard(
      animation: animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedCardTitle(
              icon, title, state.synced,
              showSyncStatus: !state.isRemoteState, showControls: !state.isRemoteState, onDelete: () {
            BlocProvider.of<FeedBloc>(context).add(FeedBlocEventDeleteEntry(state));
          }, actions: cardActions != null ? cardActions!(context, state) : []),
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
}
