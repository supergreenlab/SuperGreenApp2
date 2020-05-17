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

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_matomo/flutter_matomo.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_products.dart';
import 'package:super_green_app/pages/feed_entries/feed_products/feed_products_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_state.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_text.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:url_launcher/url_launcher.dart';

const _storeGeoNames = {
  'us_us': 'US',
  'eu_de': 'German',
  'eu_fr': 'French',
};

class FeedProductsCardPage extends StatelessWidget {
  final Animation animation;
  final FeedState feedState;
  final FeedEntryState state;

  const FeedProductsCardPage(this.animation, this.feedState, this.state,
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
          FeedCardTitle('assets/feed_card/icon_schedule.svg', 'Schedule change',
              state.synced),
          Container(
            height: 100,
            alignment: Alignment.center,
            child: FullscreenLoading(),
          ),
        ],
      ),
    );
  }

  Widget _renderLoaded(BuildContext context, FeedProductsState state) {
    FeedProductsParams params = state.params;
    List<Widget> content = [
      FeedCardTitle(
        'assets/feed_card/icon_towelie.png',
        'Towelie',
        state.synced,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 24.0),
        child: _renderBody(context, state),
      ),
    ];
    if (params.selectedButton != null) {
      content.add(_renderSelectedButton(context, params.selectedButton));
    } else if (params.buttons != null && params.buttons.length > 0) {
      content.add(_renderButtonBar(context, params.buttons));
    }
    return FeedCard(
        animation: animation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: content,
        ));
  }

  Widget _renderBody(BuildContext context, FeedProductsState cardState) {
    FeedProductsParams params = state.params;
    final body = <Widget>[
      FeedCardText(params.text),
    ];
    if (params.topPic != null) {
      body.insert(
          0,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: SvgPicture.asset(params.topPic),
          ));
    }
    body.add(_renderStoreGeos(context, cardState));
    body.addAll(params.products
        .where((p) => p.geo == feedState.storeGeo)
        .map<Widget>((dynamic p) {
      Map<String, dynamic> product = p;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
              width: 70, height: 70, child: Image.asset(product['picture'])),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      product['title'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  MarkdownBody(
                      data: product['description'],
                      styleSheet: MarkdownStyleSheet(
                          strong: TextStyle(),
                          p: TextStyle(color: Colors.black, fontSize: 14))),
                ],
              ),
            ),
          ),
          ButtonTheme(
            padding: EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 16.0), //adds padding inside the button
            materialTapTargetSize: MaterialTapTargetSize
                .shrinkWrap, //limits the touch area to the button area
            minWidth: 0, //wraps child's width
            height: 0,
            child: FlatButton(
              child: Column(
                children: <Widget>[
                  Text(
                    product['price'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                  Text('View', style: TextStyle(color: Colors.blue)),
                ],
              ),
              onPressed: () async {
                if (AppDB().getAppData().allowAnalytics == true) {
                  await FlutterMatomo.trackScreenWithName(
                      'FeedProductsCardPage', 'product_clicked');
                }
                launch(product['link']['data']);
              },
            ),
          ),
        ]),
      );
    }));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: body,
    );
  }

  Widget _renderStoreGeos(BuildContext context, FeedProductsState state) {
    FeedProductsParams params = state.params;
    List<String> storeGeos = params.products
        .map<String>((dynamic p) {
          Map<String, dynamic> product = p;
          return product['geo'] as String;
        })
        .toSet()
        .toList();
    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: storeGeos.map<Widget>((sg) {
          bool selected = sg == feedState.storeGeo;
          return FlatButton(
            child: Text(_storeGeoNames[sg],
                style: TextStyle(
                    color:
                        sg == feedState.storeGeo ? Colors.black : Colors.blue)),
            onPressed: selected
                ? null
                : () async {
                    //BlocProvider.of<FeedProductsCardBloc>(context)
                    //    .add(FeedProductsCardBlocEventSetStoreGeo(sg));
                  },
          );
        }).toList(),
      ),
    );
  }

  // TODO maybe DRY with FeedTowelieInfoCardPage ?
  ButtonBar _renderButtonBar(BuildContext context, List buttons) {
    return ButtonBar(
      alignment: MainAxisAlignment.start,
      buttonPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
      children: buttons.map((b) => _renderButton(context, b)).toList(),
    );
  }

  Widget _renderButton(BuildContext context, FeedProductsButtonParams button) {
    return FlatButton(
      child: Text(button.title.toUpperCase(),
          style: TextStyle(color: Colors.blue, fontSize: 12)),
      onPressed: () {
        BlocProvider.of<TowelieBloc>(context).add(TowelieBlocEventButtonPressed(
            button.params,
            feed: state.feedID,
            feedEntry: state.id));
      },
    );
  }

  Widget _renderSelectedButton(
      BuildContext context, FeedProductsButtonParams button) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, bottom: 24),
      child: Text('➡️ ${button.title.toUpperCase()}',
          style: TextStyle(
              color: Color(0xff565656),
              fontSize: 12,
              fontWeight: FontWeight.bold)),
    );
  }
}
