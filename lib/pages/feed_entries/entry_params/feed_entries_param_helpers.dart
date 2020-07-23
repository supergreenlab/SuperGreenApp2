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

import 'package:super_green_app/pages/feed_entries/entry_params/feed_care.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_life_event.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_light.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_measure.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_media.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_products.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_schedule.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_towelie_info.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_unknown.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_ventilation.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_water.dart';

abstract class FeedEntriesParamHelpers {
  static Map<String, dynamic Function(String)> _params = {
    'FE_LIGHT': (json) => FeedLightParams.fromJSON(json),
    'FE_MEDIA': (json) => FeedMediaParams.fromJSON(json),
    'FE_MEASURE': (json) => FeedMeasureParams.fromJSON(json),
    'FE_SCHEDULE': (json) => FeedScheduleParams.fromJSON(json),
    'FE_TOPPING': (json) => FeedCareParams.fromJSON(json),
    'FE_DEFOLIATION': (json) => FeedCareParams.fromJSON(json),
    'FE_FIMMING': (json) => FeedCareParams.fromJSON(json),
    'FE_BENDING': (json) => FeedCareParams.fromJSON(json),
    'FE_TRANSPLANT': (json) => FeedCareParams.fromJSON(json),
    'FE_VENTILATION': (json) => FeedVentilationParams.fromJSON(json),
    'FE_WATER': (json) => FeedWaterParams.fromJSON(json),
    'FE_TOWELIE_INFO': (json) => FeedTowelieInfoParams.fromJSON(json),
    'FE_PRODUCTS': (json) => FeedProductsParams.fromJSON(json),
    'FE_LIFE_EVENT': (json) => FeedLifeEventParams.fromJSON(json),
  };

  static dynamic paramForFeedEntryType(String type, String json) {
    Function builder = _params[type];
    if (builder == null) {
      return FeedUnknownParams();
    }
    return builder(json);
  }
}
