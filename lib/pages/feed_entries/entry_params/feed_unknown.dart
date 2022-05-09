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

import 'dart:convert';

import 'package:super_green_app/pages/feed_entries/entry_params/feed_entry_params.dart';

class FeedUnknownParams extends FeedEntryParams {
  FeedUnknownParams();

  factory FeedUnknownParams.fromJSON(String json) {
    return FeedUnknownParams();
  }

  @override
  String toJSON() {
    return JsonEncoder().convert({});
  }

  @override
  List<Object> get props => [];
}
