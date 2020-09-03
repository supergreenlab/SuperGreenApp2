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
import 'package:super_green_app/pages/feed_entries/entry_params/feed_nutrient_mix.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/section_title.dart';

class FeedNutrientMixCardPage extends StatelessWidget {
  final Animation animation;
  final FeedState feedState;
  final FeedEntryState state;

  const FeedNutrientMixCardPage(this.animation, this.feedState, this.state,
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
            'assets/feed_card/icon_nutrient_mix.svg',
            'Nutrient mix',
            state.synced,
            showSyncStatus: !state.remoteState,
            showControls: !state.remoteState,
          ),
          Container(
            height: 140,
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
    FeedNutrientMixParams params = state.params;
    List<Widget> cards = [
      renderCard(
          'assets/feed_form/icon_volume.svg',
          'Water quantity',
          Text('${params.volume} L',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25))),
    ];
    if (params.ph != null) {
      cards.add(renderCard(
          'assets/products/toolbox/icon_ph_ec.svg',
          'PH',
          Text('${params.ph}',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25))));
    }
    if (params.tds != null) {
      cards.add(renderCard(
          'assets/products/toolbox/icon_ph_ec.svg',
          'TDS',
          Text('${params.tds} ppm',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25))));
    }
    cards.addAll(params.nutrientProducts
        .map((np) => renderNutrientProduct(np))
        .toList());
    return FeedCard(
      animation: animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedCardTitle(
            'assets/feed_card/icon_nutrient_mix.svg',
            'Nutrient mix',
            state.synced,
            showSyncStatus: !state.remoteState,
            showControls: !state.remoteState,
            onDelete: () {
              BlocProvider.of<FeedBloc>(context)
                  .add(FeedBlocEventDeleteEntry(state));
            },
          ),
          Container(
            height: 115,
            alignment: Alignment.center,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: cards,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FeedCardDate(state, feedState),
          ),
        ],
      ),
    );
  }

  Widget renderNutrientProduct(NutrientProduct nutrientProduct) {
    return renderCard(
        'assets/products/toolbox/icon_fertilizer.svg',
        nutrientProduct.product.name,
        Text('${nutrientProduct.quantity} ${nutrientProduct.unit}',
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25)));
  }

  Widget renderCard(String icon, String title, Widget child) {
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
              SectionTitle(icon: icon, title: title),
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
