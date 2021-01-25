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
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:share_extend/share_extend.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/feed_page.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/plant_infos/plant_infos_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/plant_infos/plant_infos_page.dart';
import 'package:super_green_app/pages/feeds/home/common/products/products_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/products/products_page.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/remote/plant_infos_bloc_delegate.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/remote/public_plant_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/remote/remote_plant_feed_delegate.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/remote/remote_products_delegate.dart';

class PublicPlantPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PublicPlantBloc, PublicPlantBlocState>(
        cubit: BlocProvider.of<PublicPlantBloc>(context),
        builder: (BuildContext context, PublicPlantBlocState state) {
          return _renderFeed(context, state);
        },
      ),
    );
  }

  Widget _renderFeed(BuildContext context, PublicPlantBlocState state) {
    List<Widget Function(BuildContext, PublicPlantBlocState)> tabs = [
      _renderPlantInfos,
      _renderProducts,
    ];
    return BlocProvider(
      create: (context) => FeedBloc(
          RemotePlantFeedBlocDelegate(state.plantID, state.feedEntryID)),
      child: FeedPage(
        title: state.plantName ?? '',
        pinned: true,
        color: Colors.indigo,
        appBarHeight: 380,
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () async {
              await ShareExtend.share(
                  "https://supergreenlab.com/public/plant?id=${state.plantID}",
                  'text');
            },
          ),
        ],
        appBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 45.0),
            child: Swiper(
              itemCount: tabs.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return tabs[index](context, state);
              },
              pagination: SwiperPagination(
                builder: new DotSwiperPaginationBuilder(
                    color: Colors.white, activeColor: Color(0xff3bb30b)),
              ),
              loop: false,
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderPlantInfos(BuildContext context, PublicPlantBlocState state) {
    return BlocProvider(
        create: (context) =>
            PlantInfosBloc(RemotePlantInfosBlocDelegate(state.plantID)),
        child: PlantInfosPage());
  }

  Widget _renderProducts(BuildContext context, PublicPlantBlocState state) {
    return BlocProvider(
      create: (context) =>
          ProductsBloc(RemoteProductsBlocDelegate(state.plantID)),
      child: ProductsPage(
        editable: false,
      ),
    );
  }
}
