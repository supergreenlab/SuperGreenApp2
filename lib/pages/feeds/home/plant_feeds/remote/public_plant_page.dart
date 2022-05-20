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
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:share_extend/share_extend.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/feed_page.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/app_bar/plant_infos/plant_infos_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/app_bar/plant_infos/plant_infos_page.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/products/products_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/products/products_page.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/widgets/plant_feed_filter_page.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/widgets/single_feed_entry.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/remote/plant_infos_bloc_delegate.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/remote/public_plant_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/remote/remote_plant_feed_delegate.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/remote/remote_products_delegate.dart';

class PublicPlantPage extends TraceableStatefulWidget {
  static String get publicPlantPageSingleEntry {
    return Intl.message(
      'Viewing single log entry',
      name: 'publicPlantPageSingleEntry',
      desc: 'Label for the button that shows the complete diary when looking at a single feed entry',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get publicPlantPageSingleEntryButton {
    return Intl.message(
      'View complete diary',
      name: 'publicPlantPageSingleEntryButton',
      desc: 'Button that shows the complete diary when looking at a single feed entry',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  @override
  State<PublicPlantPage> createState() => _PublicPlantPageState();
}

class _PublicPlantPageState extends State<PublicPlantPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublicPlantBloc, PublicPlantBlocState>(
      bloc: BlocProvider.of<PublicPlantBloc>(context),
      builder: (BuildContext context, PublicPlantBlocState state) {
        return Scaffold(body: _renderFeed(context, state));
      },
    );
  }

  List<String> filters = [];

  @override
  void initState() {
    filters = AppDB().getAppData().filters ?? [];
    super.initState();
  }

  Widget _renderFeed(BuildContext context, PublicPlantBlocState state) {
    List<Widget Function(BuildContext, PublicPlantBlocState)> tabs = [
      _renderPlantInfos,
      _renderProducts,
    ];
    Widget? bottom;
    if (state.feedEntryID != null) {
      bottom = SingleFeedEntry(
        title: PublicPlantPage.publicPlantPageSingleEntry,
        button: PublicPlantPage.publicPlantPageSingleEntryButton,
        onTap: () {
          BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToPublicPlant(
            state.plantID,
          ));
        },
      );
    }
    List<Widget> actions = [
      IconButton(
        icon: Icon(
          Icons.share,
          color: Colors.white,
        ),
        onPressed: () async {
          await ShareExtend.share("https://supergreenlab.com/public/plant?id=${state.plantID}", 'text');
        },
      ),
    ];
    if (state.follows != null) {
      actions.insert(
          0,
          InkWell(
            highlightColor: Colors.transparent,
            onTap: () {
              if (BackendAPI().usersAPI.loggedIn) {
                BlocProvider.of<PublicPlantBloc>(context).add(PublicPlantBlocEventFollowPlant());
              } else {
                _login(context);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Color(0xff3bb30b),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                    child: Text(state.follows! ? 'Following (${state.nFollows})' : 'Follow'),
                  ),
                ),
              ],
            ),
          ));
    }
    return BlocProvider(
      create: (context) => FeedBloc(
          RemotePlantFeedBlocDelegate(
            state.plantID,
            state.feedEntryID,
            state.commentID,
            state.replyTo,
          ),
          filters: filters),
      child: FeedPage(
          automaticallyImplyLeading: true,
          title: state.plantName ?? '',
          pinned: true,
          color: Colors.indigo,
          appBarHeight: 380,
          actions: actions,
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
                  builder: new DotSwiperPaginationBuilder(color: Colors.white, activeColor: Color(0xff3bb30b)),
                ),
                loop: false,
              ),
            ),
          ),
          firstItem: bottom != null
              ? null
              : PlantFeedFilterPage(
                  filters: filters,
                  onSaveFilters: (f) {
                    filters = f;
                    AppDB().setFilters(filters);
                  },
                ),
          bottom: bottom),
    );
  }

  Widget _renderPlantInfos(BuildContext context, PublicPlantBlocState state) {
    return BlocProvider(
        create: (context) => PlantInfosBloc(RemotePlantInfosBlocDelegate(state.plantID)), child: PlantInfosPage());
  }

  Widget _renderProducts(BuildContext context, PublicPlantBlocState state) {
    return BlocProvider(
      create: (context) => ProductsBloc(RemoteProductsBlocDelegate(state.plantID)),
      child: ProductsPage(
        editable: false,
      ),
    );
  }

  void _login(BuildContext context) async {
    bool? confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(CommonL10N.loginRequiredDialogTitle),
            content: Text(CommonL10N.loginRequiredDialogBody),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(CommonL10N.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(CommonL10N.loginCreateAccount),
              ),
            ],
          );
        });
    if (confirm ?? false) {
      BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSettingsAuth());
    }
  }
}
