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
import 'package:super_green_app/pages/feed_entries/common/feed_entry_assets.dart';
import 'package:super_green_app/pages/feed_entries/common/social_bar/social_bar_page.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_water.dart';
import 'package:super_green_app/pages/feed_entries/feed_water/card/feed_water_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_text.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/section_title.dart';

class FeedWaterCardPage extends StatefulWidget {
  static String get feedWateringCardPageTitle {
    return Intl.message(
      'Watering',
      name: 'feedWateringCardPageTitle',
      desc: 'Feed watering card title',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedWateringCardPageVolume {
    return Intl.message(
      'Water quantity',
      name: 'feedWateringCardPageVolume',
      desc: 'Feed watering card volume',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String feedWateringCardPageWasDry(String yesNo) {
    return Intl.message(
      'Was dry: $yesNo',
      args: [yesNo],
      name: 'feedWateringCardPageWasDry',
      desc: 'Feed watering card was dry',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String feedWateringCardPageWithNutes(String yesNo) {
    return Intl.message(
      'With nutes: $yesNo',
      args: [yesNo],
      name: 'feedWateringCardPageWithNutes',
      desc: 'Feed watering card with nutes',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedWateringCardPageObservations {
    return Intl.message(
      'Observations',
      name: 'feedWateringCardPageObservations',
      desc: 'Feed watering observations label',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  final Animation<double> animation;
  final FeedState feedState;
  final FeedEntryState state;
  final List<Widget> Function(BuildContext context, FeedEntryState feedEntryState)? cardActions;

  const FeedWaterCardPage(this.animation, this.feedState, this.state, {Key? key, this.cardActions}) : super(key: key);

  @override
  _FeedWaterCardPageState createState() => _FeedWaterCardPageState();
}

class _FeedWaterCardPageState extends State<FeedWaterCardPage> {
  bool editText = false;

  @override
  Widget build(BuildContext context) {
    if (widget.state is FeedEntryStateLoaded) {
      return _renderLoaded(context, widget.state as FeedWaterState);
    }
    return _renderLoading(context, widget.state);
  }

  Widget _renderLoading(BuildContext context, FeedEntryState state) {
    return FeedCard(
      animation: widget.animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedCardTitle(FeedEntryIcons[FE_WATER]!, FeedWaterCardPage.feedWateringCardPageTitle, state.synced,
              showSyncStatus: !state.isRemoteState, showControls: !state.isRemoteState),
          Container(
            height: 200,
            alignment: Alignment.center,
            child: FullscreenLoading(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FeedCardDate(state, widget.feedState),
          ),
        ],
      ),
    );
  }

  Widget _renderLoaded(BuildContext context, FeedWaterState state) {
    FeedWaterParams params = state.params as FeedWaterParams;
    List<Widget> cards = [
      renderCard('assets/feed_form/icon_volume.svg', 8, FeedWaterCardPage.feedWateringCardPageVolume,
          Text('${params.volume} L', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25))),
    ];
    if (params.ph != null) {
      cards.add(renderCard('assets/products/toolbox/icon_ph_ec.svg', 0, 'PH',
          Text('${params.ph}', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25))));
    }
    if (params.ec != null) {
      cards.add(renderCard('assets/products/toolbox/icon_ph_ec.svg', 0, 'EC',
          Text('${params.ec} μS/cm', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25))));
    }
    if (params.tds != null) {
      cards.add(renderCard('assets/products/toolbox/icon_ph_ec.svg', 0, 'TDS',
          Text('${params.tds} ppm', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25))));
    }

    return FeedCard(
      animation: widget.animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedCardTitle(FeedEntryIcons[FE_WATER]!, FeedWaterCardPage.feedWateringCardPageTitle, state.synced,
              showSyncStatus: !state.isRemoteState, showControls: !state.isRemoteState, onEdit: () {
            setState(() {
              editText = true;
            });
          }, onDelete: () {
            BlocProvider.of<FeedBloc>(context).add(FeedBlocEventDeleteEntry(state));
          }, actions: widget.cardActions != null ? widget.cardActions!(context, state) : []),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                params.tooDry != null
                    ? Text(
                        FeedWaterCardPage.feedWateringCardPageWasDry(params.tooDry == true ? 'YES' : 'NO'),
                        style: TextStyle(color: Color(0xffababab)),
                      )
                    : Container(),
                params.nutrient != null
                    ? Text(
                        FeedWaterCardPage.feedWateringCardPageWithNutes(params.nutrient == true ? 'YES' : 'NO'),
                        style: TextStyle(color: Color(0xffababab)),
                      )
                    : Container(),
              ],
            ),
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
          ),
          SocialBarPage(
            state: state,
            feedState: widget.feedState,
          ),
          (params.message ?? '') != '' || editText == true
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(FeedWaterCardPage.feedWateringCardPageObservations, style: TextStyle()),
                )
              : Container(),
          (params.message ?? '') != '' || editText == true
              ? FeedCardText(
                  params.message ?? '',
                  edit: editText,
                  onEdited: (value) {
                    BlocProvider.of<FeedBloc>(context).add(FeedBlocEventEditParams(state, params.copyWith(value)));
                    setState(() {
                      editText = false;
                    });
                  },
                )
              : Container(),
          CommentsCardPage(
            state: state,
            feedState: widget.feedState,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FeedCardDate(state, widget.feedState),
          ),
        ],
      ),
    );
  }

  Widget renderCard(String icon, double iconPadding, String title, Widget child) {
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
}
