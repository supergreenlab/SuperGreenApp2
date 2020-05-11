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

class FeedTowelieInfoButton {
  final String id;
  final String title;

  final Map<String, dynamic> params;

  FeedTowelieInfoButton(this.id, this.title, this.params);

  static FeedTowelieInfoButton fromJSON(Map<String, dynamic> map) {
    return FeedTowelieInfoButton(map['id'], map['title'], map);
  }
}

class FeedTowelieInfoState {
  final String topPic;
  final String text;
  final List<FeedTowelieInfoButton> buttons;
  final FeedTowelieInfoButton selectedButton;

  FeedTowelieInfoState(
      this.topPic, this.text, this.buttons, this.selectedButton);

  static FeedTowelieInfoState fromJSON(Map<String, dynamic> map) {
    List<FeedTowelieInfoButton> buttons =
        (map['buttons'] ?? []).map((b) => FeedTowelieInfoButton.fromJSON(b));
    FeedTowelieInfoButton selectedButton = map['selectedButton'] == null
        ? null
        : FeedTowelieInfoButton.fromJSON(map['selectedButton']);
    return FeedTowelieInfoState(
      map['top_pic'],
      map['text'],
      buttons,
      selectedButton,
    );
  }
}
