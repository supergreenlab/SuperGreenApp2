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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/dashboard/dashboard_bloc.dart';
import 'package:super_green_app/pages/dashboard/tuto/tuto_bloc.dart';
import 'package:super_green_app/pages/dashboard/tuto/tuto_page.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/metrics/app_bar_metrics_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/controls/box_controls_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/controls/box_controls_page.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/environment/environments_page.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/app_bar/status/plant_quick_view_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/app_bar/status/plant_quick_view_page.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String search = '';
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardBloc, DashboardBlocState>(
      listener: (BuildContext context, DashboardBlocState state) {
        if (state is DashboardBlocStateLoaded) {}
      },
      child: BlocBuilder<DashboardBloc, DashboardBlocState>(
          bloc: BlocProvider.of<DashboardBloc>(context),
          builder: (context, state) {
            Widget body = _renderLoading(context, state);
            if (state is DashboardBlocStateLoaded) {
              body = _renderLoaded(context, state);
            }
            return Scaffold(
              appBar: SGLAppBar(
                '',
                backgroundColor: Colors.deepPurple,
                titleColor: Colors.yellow,
                iconColor: Colors.white,
                hideBackButton: true,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child:
                      SizedBox(width: 100, height: 100, child: SvgPicture.asset('assets/explorer/logo_sgl_white.svg')),
                ),
              ),
              body: body,
            );
          }),
    );
  }

  Widget _renderLoading(BuildContext context, DashboardBlocState state) {
    return FullscreenLoading();
  }

  Widget _renderLoaded(BuildContext context, DashboardBlocStateLoaded state) {
    if (state.plants.length == 0) {
      return _renderEmpty(context);
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _renderSearchField(context, state),
        ),
        Expanded(child: _renderList(context, state)),
      ],
    );
  }

  Widget _renderEmpty(BuildContext context) {
    return BlocProvider<TutoBloc>(
      create: (context) => TutoBloc(),
      child: TutoPage(),
    );
  }

  Widget _renderSearchField(BuildContext context, DashboardBlocStateLoaded state) {
    Widget trailing;
    if (searchController.text == '') {
      trailing = SvgPicture.asset('assets/explorer/icon_search.svg');
    } else {
      trailing = InkWell(
        child: Icon(Icons.clear),
        onTap: () {
          setState(() {
            searchController.text = '';
          });
        },
      );
    }
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Color(0xffe9e9e9),
        border: Border.all(width: 1, color: Color(0xffd8d8d8)),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(children: [
          Expanded(
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
            ),
          ),
          trailing,
        ]),
      ),
    );
  }

  Widget _renderList(BuildContext context, DashboardBlocStateLoaded state) {
    List<Widget Function(BuildContext, Plant, Box)> tabs = [
      _renderQuickView,
      _renderControls,
      (c, p, b) => EnvironmentsPage(b, plant: p, futureFn: futureFn(c, p)),
    ];

    return ListView(
      children: state.plants.where((p) {
        if (search == '') return true;
        Box box = state.boxes.firstWhere((b) => b.id == p.box);
        return box.name.toLowerCase().indexOf(search) != -1 ||
            p.name.toLowerCase().indexOf(search) != -1 ||
            p.settings.toLowerCase().indexOf(search) != -1;
      }).map<Widget>((p) {
        Box box = state.boxes.firstWhere((b) => b.id == p.box);
        List<Widget> body = [
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 20.0,
              top: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/settings/icon_plants.svg",
                      width: 35,
                      height: 35,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${p.name}",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "in",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              " ${box.name}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    child: Column(
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          color: Color(0xff3bb30b),
                        ),
                        Text("View"),
                      ],
                    ),
                    onTap: () {
                      BlocProvider.of<HomeNavigatorBloc>(context).add(HomeNavigateToPlantFeedEvent(p));
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Swiper(
                itemCount: tabs.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return tabs[index](context, p, box);
                },
                pagination: SwiperPagination(
                  builder: new DotSwiperPaginationBuilder(color: Color(0xffdedede), activeColor: Color(0xff3bb30b)),
                ),
                loop: false,
              ),
            ),
          ),
          p == state.plants.last ? Container() : Container(height: 2, color: Color(0xffdedede)),
        ];
        return Container(
          height: 430,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: body,
          ),
        );
      }).toList(),
    );
  }

  Widget _renderQuickView(BuildContext context, Plant plant, Box box) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlantQuickViewBloc>(create: (context) => PlantQuickViewBloc(plant, box)),
        BlocProvider<AppBarMetricsBloc>(create: (context) => AppBarMetricsBloc(plant)),
      ],
      child: PlantQuickViewPage(),
    );
  }

  Widget _renderControls(BuildContext context, Plant plant, Box box) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BoxControlsBloc>(create: (context) => BoxControlsBloc(plant, box)),
        BlocProvider<AppBarMetricsBloc>(create: (context) => AppBarMetricsBloc(plant)),
      ],
      child: BoxControlsPage(
        futureFn: futureFn(context, plant),
      ),
    );
  }

// TODO DRY this somewhere
  void Function(Future<dynamic>?) futureFn(BuildContext context, Plant plant) {
    return (Future<dynamic>? future) async {
      dynamic feedEntry = await future;
      if (feedEntry != null && feedEntry is FeedEntry) {
        BlocProvider.of<TowelieBloc>(context).add(TowelieBlocEventFeedEntryCreated(plant, feedEntry));
      }
    };
  }
}
