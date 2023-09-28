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
import 'package:super_green_app/data/assets/feed_entry.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';

import 'icon_checkbox.dart';

List<String> cardTypes = [
  // TODO we really need a clean centralized place to put those
  FE_LIGHT,
  FE_MEDIA,
  FE_MEASURE,
  FE_SCHEDULE,
  FE_TOPPING,
  FE_DEFOLIATION,
  FE_CLONING,
  FE_FIMMING,
  FE_BENDING,
  FE_TRANSPLANT,
  FE_VENTILATION,
  FE_WATER,
  FE_TOWELIE_INFO,
  FE_LIFE_EVENT,
  FE_NUTRIENT_MIX,
  FE_TIMELAPSE,
];

class PlantFeedFilterPage extends StatefulWidget {
  final Function(List<String>) onSaveFilters;
  final List<String> filters;

  const PlantFeedFilterPage({Key? key, required this.onSaveFilters, required this.filters}) : super(key: key);

  @override
  State<PlantFeedFilterPage> createState() => _PlantFeedFilterPageState();
}

class _PlantFeedFilterPageState extends State<PlantFeedFilterPage> {
  bool openned = false;

  Map<String, bool> filters = {};

  @override
  void initState() {
    if (widget.filters.length > 0) {
      cardTypes.forEach((f) {
        this.filters[f] = false;
      });

      widget.filters.forEach((f) {
        this.filters[f] = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedBloc, FeedBlocState>(
      bloc: BlocProvider.of<FeedBloc>(context),
      listener: (BuildContext context, FeedBlocState state) {
        if (state is FeedBlocStateFeedLoaded) {}
      },
      child: ExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.all(0.0),
        elevation: 0,
        children: [
          ExpansionPanel(
              canTapOnHeader: true,
              backgroundColor: Colors.transparent,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Padding(
                  padding: const EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/feed_card/icon_filter.svg',
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text('Filter',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              color: Color(0xff454545),
                            )),
                      ),
                    ],
                  ),
                );
              },
              isExpanded: openned,
              body: Column(
                children: [
                  _renderSelectionButton(context),
                  _renderCardFilters(context),
                ],
              )),
        ],
        expansionCallback: (int item, bool status) {
          setState(() {
            openned = !openned;
          });
        },
      ),
    );
  }

  Widget _renderSelectionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, right: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () => {
              setState(() {
                filters = {};
                BlocProvider.of<FeedBloc>(context).add(FeedBlocEventSetFilters(null));
                widget.onSaveFilters([]);
              })
            },
            child: Text(
              'Select all',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Container(width: 10),
          InkWell(
            onTap: () => {
              setState(() {
                cardTypes.forEach((f) {
                  filters[f] = false;
                });
                List<String> f = cardTypes.where((ct) => filters[ct] ?? true).toList();
                BlocProvider.of<FeedBloc>(context).add(FeedBlocEventSetFilters(f));
                widget.onSaveFilters(f);
              })
            },
            child: Text(
              'Clear all',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static double filterSidePadding=16.0;

  Widget _renderCardFilters(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: filterSidePadding, right: filterSidePadding, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.start,
            children: [
              _renderCardfilter(context,
                  filterName: 'FE_MEDIA', name: 'Grow log'),
              _renderCardfilter(context,
                  filterName: 'FE_MEASURE', name: 'Measure'),
              _renderCardfilter(context,
                  filterName: 'FE_TRANSPLANT', name: 'Transplant'),
              _renderCardfilter(context,
                  filterName: 'FE_BENDING', name: 'Bending'),
              _renderCardfilter(context,
                  filterName: 'FE_CLONING', name: 'Cloning'),
              _renderCardfilter(context,
                  filterName: 'FE_FIMMING', name: 'Fimming'),
              _renderCardfilter(context,
                  filterName: 'FE_TOPPING', name: 'Topping'),
              _renderCardfilter(context,
                  filterName: 'FE_DEFOLIATION', name: 'Defoliation'),
              _renderCardfilter(context,
                  filterName: 'FE_TIMELAPSE', name: 'Timelapse'),
            ],
          ),
          CardSeparator(),
          Wrap(
            alignment: WrapAlignment.start,
            children: [
              _renderCardfilter(context,
                  filterName: 'FE_NUTRIENT_MIX', name: 'Nutrient M'),
              _renderCardfilter(context,
                  filterName: 'FE_WATER', name: 'Watering'),
              _renderCardfilter(context,
                  filterName: 'FE_LIGHT', name: 'Light'),
              _renderCardfilter(context,
                  filterName: 'FE_VENTILATION', name: 'Ventilation'),
              _renderCardfilter(context,
                  filterName: 'FE_SCHEDULE', name: 'Schedule'),
            ],
          ),
          CardSeparator(),
          Wrap(
            alignment: WrapAlignment.start,
            children: [
              _renderCardfilter(context,
                filterName: 'FE_LIFE_EVENT',
                name: 'Life events'
              ),
              _renderCardfilter(
                context,
                filterName: 'FE_TOWELIE_INFO',
                name: 'Towelie',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _renderCardfilter(
    BuildContext context, {
    required String filterName,
    required String name,
  }) {
    bool checked = filters[filterName] ?? true;
    Size size = MediaQuery.of(context).size;
    double width = (size.width - filterSidePadding*2) / 4;
    if (width < 85) {
      width = (size.width - filterSidePadding*2) / 3;
    }
    return InkWell(
      onTap: () {
        setState(() {
          filters[filterName] = !checked;
          List<String> f = cardTypes.where((ct) => filters[ct] ?? true).toList();
          BlocProvider.of<FeedBloc>(context).add(FeedBlocEventSetFilters(f));
          widget.onSaveFilters(f);
        });
      },
      child: Container(
        width: width,
        height: 85,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xff555555),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: IconCheckbox(icon: FeedEntryIcons[filterName]!, checked: checked, size: 30.0),
            )
          ],
        ),
      ),
    );
  }
}

class CardSeparator extends StatelessWidget {
  const CardSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 18.0,
      ),
      child: Container(
        height: 2,
        color: Color(0xffdedede),
      ),
    );
  }
}
