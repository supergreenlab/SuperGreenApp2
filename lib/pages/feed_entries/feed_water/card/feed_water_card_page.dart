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
  final Animation animation;
  final FeedState feedState;
  final FeedEntryState state;

  const FeedWaterCardPage(this.animation, this.feedState, this.state, {Key key})
      : super(key: key);

  @override
  _FeedWaterCardPageState createState() => _FeedWaterCardPageState();
}

class _FeedWaterCardPageState extends State<FeedWaterCardPage> {
  bool editText = false;

  @override
  Widget build(BuildContext context) {
    if (widget.state is FeedEntryStateLoaded) {
      return _renderLoaded(context, widget.state);
    }
    return _renderLoading(context, widget.state);
  }

  Widget _renderLoading(BuildContext context, FeedEntryState state) {
    return FeedCard(
      animation: widget.animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedCardTitle(
              'assets/feed_card/icon_watering.svg', 'Watering', state.synced,
              showSyncStatus: !state.remoteState,
              showControls: !state.remoteState),
          Container(
            height: 100,
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
    FeedWaterParams params = state.params;
    List<Widget> cards = [
      renderCard(
          'assets/feed_form/icon_volume.svg',
          8,
          'Water quantity',
          Text('${params.volume} L',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25))),
    ];
    if (params.ph != null) {
      cards.add(renderCard(
          'assets/products/toolbox/icon_ph_ec.svg',
          0,
          'PH',
          Text('${params.ph}',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25))));
    }
    if (params.ec != null) {
      cards.add(renderCard(
          'assets/products/toolbox/icon_ph_ec.svg',
          0,
          'EC',
          Text('${params.ec} μS/cm',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25))));
    }
    if (params.tds != null) {
      cards.add(renderCard(
          'assets/products/toolbox/icon_ph_ec.svg',
          0,
          'TDS',
          Text('${params.tds} ppm',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25))));
    }

    return FeedCard(
      animation: widget.animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedCardTitle(
            'assets/feed_card/icon_watering.svg',
            'Watering',
            state.synced,
            showSyncStatus: !state.remoteState,
            showControls: !state.remoteState,
            onEdit: () {
              setState(() {
                editText = true;
              });
            },
            onDelete: () {
              BlocProvider.of<FeedBloc>(context)
                  .add(FeedBlocEventDeleteEntry(state));
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                params.tooDry != null
                    ? Text(
                        'Was dry: ${params.tooDry == true ? 'YES' : 'NO'}',
                        style: TextStyle(color: Color(0xffababab)),
                      )
                    : Container(),
                params.nutrient != null
                    ? Text(
                        'With nutes: ${params.nutrient == true ? 'YES' : 'NO'}',
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FeedCardDate(state, widget.feedState),
          ),
          (params.message ?? '') != '' || editText == true
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Observations', style: TextStyle()),
                )
              : Container(),
          (params.message ?? '') != '' || editText == true
              ? FeedCardText(
                  params.message ?? '',
                  edit: editText,
                  onEdited: (value) {
                    BlocProvider.of<FeedBloc>(context).add(
                        FeedBlocEventEditParams(state, params.copyWith(value)));
                    setState(() {
                      editText = false;
                    });
                  },
                )
              : Container(),
        ],
      ),
    );
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
}
