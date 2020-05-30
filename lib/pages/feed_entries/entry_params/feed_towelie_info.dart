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

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_entry_params.dart';

class FeedTowelieParamsButton extends Equatable {
  final String id;
  final String title;

  final Map<String, dynamic> params;

  FeedTowelieParamsButton(this.id, this.title, this.params);

  static FeedTowelieParamsButton fromMap(Map<String, dynamic> map) {
    return FeedTowelieParamsButton(map['id'], map['title'], map);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'params': params,
    };
  }

  @override
  List<Object> get props => [id, title];
}

class FeedTowelieInfoParams extends FeedEntryParams {
  final String topPic;
  final String text;
  final List<FeedTowelieParamsButton> buttons;
  final FeedTowelieParamsButton selectedButton;

  FeedTowelieInfoParams(this.topPic, this.text, this.buttons, this.selectedButton);

  static FeedTowelieInfoParams fromJSON(String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    List<FeedTowelieParamsButton> buttons = (map['buttons'] ?? [])
        .map<FeedTowelieParamsButton>(
            (b) => FeedTowelieParamsButton.fromMap(b)).toList();
    FeedTowelieParamsButton selectedButton = map['selectedButton'] == null
        ? null
        : FeedTowelieParamsButton.fromMap(map['selectedButton']);
    return FeedTowelieInfoParams(
      map['top_pic'],
      map['text'],
      buttons,
      selectedButton,
    );
  }

  @override
  String toJSON() {
    return JsonEncoder().convert({
      'top_pic': topPic,
      'text': text,
      'buttons': buttons
          .map<Map<String, dynamic>>((b) => b.toMap()),
      'selectedButton': selectedButton.toMap(),
    });
  }

  @override
  List<Object> get props => [topPic, text, buttons, selectedButton];
}
