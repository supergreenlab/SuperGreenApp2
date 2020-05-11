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

class FeedProductsButton {
  final String id;
  final String title;

  final Map<String, dynamic> params;

  FeedProductsButton(this.id, this.title, this.params);

  static FeedProductsButton fromJSON(Map<String, dynamic> map) {
    return FeedProductsButton(map['id'], map['title'], map);
  }
}

class FeedProductsLink {
  final String type;
  final String data;

  FeedProductsLink(this.type, this.data);

  static FeedProductsLink fromJSON(Map<String, dynamic> map) {
    return FeedProductsLink(map['type'], map['data']);
  }
}

class FeedProductsItem {
  final String title;
  final String description;
  final String picture;
  final String price;
  final String geo;
  final FeedProductsLink link;

  FeedProductsItem(this.title, this.description, this.picture, this.price, this.geo, this.link);

  static FeedProductsItem fromJSON(Map<String, dynamic> map) {
    return FeedProductsItem(
      map['title'],
      map['description'],
      map['picture'],
      map['price'],
      map['geo'],
      FeedProductsLink.fromJSON(map['link']),
    );
  }
}

class FeedProductsState {
  String storeGeo;

  final String topPic;
  final String text;
  final List<FeedProductsItem> items;
  final List<FeedProductsButton> buttons;
  final FeedProductsButton selectedButton;

  FeedProductsState(this.topPic, this.text, this.items, this.buttons, this.selectedButton);

  static FeedProductsState fromJSON(Map<String, dynamic> map) {
    List<FeedProductsItem> items = map['products'].map((p) => FeedProductsItem.fromJSON(p));
    List<FeedProductsButton> buttons =
        (map['buttons'] ?? []).map((b) => FeedProductsButton.fromJSON(b));
    FeedProductsButton selectedButton = map['selectedButton'] == null
        ? null
        : FeedProductsButton.fromJSON(map['selectedButton']);
    return FeedProductsState(
      map['top_pic'],
      map['text'],
      items,
      buttons,
      selectedButton,
    );
  }
}
