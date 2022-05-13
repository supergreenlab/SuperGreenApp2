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
import 'package:flutter_svg/svg.dart';

List<String> cardTypes = [
  // TODO we really need a clean centralized place to put those
  'FE_LIGHT',
  'FE_MEDIA',
  'FE_MEASURE',
  'FE_SCHEDULE',
  'FE_TOPPING',
  'FE_DEFOLIATION',
  'FE_FIMMING',
  'FE_BENDING',
  'FE_TRANSPLANT',
  'FE_VENTILATION',
  'FE_WATER',
  'FE_TOWELIE_INFO',
  'FE_PRODUCTS',
  'FE_LIFE_EVENT',
  'FE_NUTRIENT_MIX',
  'FE_TIMELAPSE',
];

class PlantFeedFilterPage extends StatefulWidget {
  @override
  State<PlantFeedFilterPage> createState() => _PlantFeedFilterPageState();
}

class _PlantFeedFilterPageState extends State<PlantFeedFilterPage> {
  bool openned = false;

  Map<String, bool> filters = {};

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: 0,
      children: [
        ExpansionPanel(
            canTapOnHeader: true,
            backgroundColor: Colors.transparent,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
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
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
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
    );
  }

  Widget _renderSelectionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () => {
              setState(() {
                filters = {};
              })
            },
            child: Text(
              'Select all',
              style: TextStyle(
                fontSize: 18,
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
              })
            },
            child: Text(
              'Clear all',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderCardFilters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            children: [
              _renderCardfilter(context,
                  filterName: 'FE_MEDIA', icon: 'assets/feed_card/icon_media.svg', name: 'Grow log'),
              _renderCardfilter(context,
                  filterName: 'FE_MEASURE', icon: 'assets/feed_card/icon_measure.svg', name: 'Measure'),
              _renderCardfilter(context,
                  filterName: 'FE_NUTRIENT_MIX', icon: 'assets/feed_card/icon_nutrient_mix.svg', name: 'Nutrient M'),
              _renderCardfilter(context,
                  filterName: 'FE_WATER', icon: 'assets/feed_card/icon_watering.svg', name: 'Watering'),
              _renderCardfilter(context,
                  filterName: 'FE_TIMELAPSE', icon: 'assets/feed_card/icon_timelapse.svg', name: 'Timelapse'),
              _renderCardfilter(context,
                  filterName: 'FE_LIGHT', icon: 'assets/feed_card/icon_light.svg', name: 'Light'),
              _renderCardfilter(context,
                  filterName: 'FE_VENTILATION', icon: 'assets/feed_card/icon_blower.svg', name: 'Ventilation'),
              _renderCardfilter(context,
                  filterName: 'FE_SCHEDULE', icon: 'assets/feed_card/icon_schedule.svg', name: 'Schedule'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 18.0,
            ),
            child: Container(
              height: 2,
              color: Color(0xffdedede),
            ),
          ),
          Wrap(
            children: [
              _renderCardfilter(context,
                  filterName: 'FE_TRANSPLANT', icon: 'assets/feed_card/icon_transplant.svg', name: 'Transplant'),
              _renderCardfilter(context,
                  filterName: 'FE_BENDING', icon: 'assets/feed_card/icon_bending.svg', name: 'Bending'),
              _renderCardfilter(context,
                  filterName: 'FE_FIMMING', icon: 'assets/feed_card/icon_fimming.svg', name: 'Fimming'),
              _renderCardfilter(context,
                  filterName: 'FE_TOPPING', icon: 'assets/feed_card/icon_topping.svg', name: 'Topping'),
              _renderCardfilter(context,
                  filterName: 'FE_DEFOLIATION', icon: 'assets/feed_card/icon_defoliation.svg', name: 'Defoliation'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 18.0,
            ),
            child: Container(
              height: 2,
              color: Color(0xffdedede),
            ),
          ),
          Wrap(
            children: [
              _renderCardfilter(context,
                  filterName: 'FE_LIFE_EVENT',
                  icon: 'assets/plant_infos/icon_germination_date.svg',
                  name: 'Life events'),
              _renderCardfilter(
                context,
                filterName: 'FE_TOWELIE_INFO',
                icon: 'assets/feed_card/icon_towelie.png',
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
    required String icon,
    required String name,
  }) {
    bool checked = filters[filterName] ?? true;
    return InkWell(
      onTap: () {
        setState(() {
          filters[filterName] = !checked;
        });
      },
      child: Container(
        width: 95,
        height: 70,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xff555555),
                ),
              ),
            ),
            Row(
              children: [
                icon.indexOf('.svg') != -1
                    ? SvgPicture.asset(
                        icon,
                        height: 30,
                        width: 30,
                      )
                    : Image.asset(
                        icon,
                        height: 30,
                        width: 30,
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SvgPicture.asset(
                    'assets/feed_card/checkbox_${checked ? 'on' : 'off'}.svg',
                    height: 30,
                    width: 30,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
