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

class FeedProductsButtonParams extends Equatable {
  final String id;
  final String title;

  final Map<String, dynamic> params;

  FeedProductsButtonParams(this.id, this.title, this.params);

  static FeedProductsButtonParams fromMap(Map<String, dynamic> map) {
    return FeedProductsButtonParams(map['id'], map['title'], map);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  @override
  List<Object> get props => [id, title];
}

class FeedProductsLinkParams extends Equatable {
  final String type;
  final String data;

  FeedProductsLinkParams(this.type, this.data);

  static FeedProductsLinkParams fromMap(Map<String, dynamic> map) {
    return FeedProductsLinkParams(map['type'], map['data']);
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'data': data,
    };
  }

  @override
  List<Object> get props => [type, data];
}

class FeedProductsItemParams extends Equatable {
  final String title;
  final String description;
  final String picture;
  final String price;
  final String geo;
  final FeedProductsLinkParams link;

  FeedProductsItemParams(this.title, this.description, this.picture, this.price,
      this.geo, this.link);

  static FeedProductsItemParams fromMap(Map<String, dynamic> map) {
    return FeedProductsItemParams(
      map['title'],
      map['description'],
      map['picture'],
      map['price'],
      map['geo'],
      FeedProductsLinkParams.fromMap(map['link']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'picture': picture,
      'price': price,
      'geo': geo,
      'link': link.toMap(),
    };
  }

  @override
  List<Object> get props => [title, description, picture, price, geo, link];
}

class FeedProductsParams extends Equatable {
  final String topPic;
  final String text;
  final List<FeedProductsItemParams> products;
  final List<FeedProductsButtonParams> buttons;
  final FeedProductsButtonParams selectedButton;

  FeedProductsParams(
      this.topPic, this.text, this.products, this.buttons, this.selectedButton);

  static FeedProductsParams fromJSON(String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    List<FeedProductsItemParams> items =
        map['products'].map((p) => FeedProductsItemParams.fromMap(p));
    List<FeedProductsButtonParams> buttons =
        (map['buttons'] ?? []).map((b) => FeedProductsButtonParams.fromMap(b));
    FeedProductsButtonParams selectedButton = map['selectedButton'] == null
        ? null
        : FeedProductsButtonParams.fromMap(map['selectedButton']);
    return FeedProductsParams(
      map['top_pic'],
      map['text'],
      items,
      buttons,
      selectedButton,
    );
  }

  String toJSON() {
    return JsonEncoder().convert({
      'top_pic': topPic,
      'text': text,
      'products': products.map<Map<String, dynamic>>((p) => p.toMap()),
      'buttons': buttons.map<Map<String, dynamic>>((b) => b.toMap()),
      'selectedButton': selectedButton.toMap(),
    });
  }

  @override
  List<Object> get props => [topPic, text, products, buttons, selectedButton];
}
