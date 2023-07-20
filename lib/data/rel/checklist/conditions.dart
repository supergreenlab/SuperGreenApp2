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

abstract class ChecklistAction {
  String type;

  ChecklistAction({required this.type});

  Map<String, dynamic> toMap() {
    return {
      'type': type,
    };
  }

  String toJSON() => json.encode(toMap());

  static List<ChecklistAction> fromMapArray(List<Map<String, dynamic>> maps) {
    return maps.map<ChecklistAction>((m) => ChecklistAction.fromMap(m)).toList();
  }

  static ChecklistAction fromMap(Map<String, dynamic> map) {
    var type = map['type'] as String;
    var params = jsonDecode(map['params']) as Map<String, dynamic>;

    switch (type) {
      case 'webpage':
        return ChecklistActionWebpage.fromMap(params);
      case 'create_card':
        return ChecklistActionCreateCard.fromMap(params);
      default:
        throw UnimplementedError('Action type $type is not implemented');
    }
  }
}

class ChecklistActionWebpage extends ChecklistAction {
  String url;

  ChecklistActionWebpage({required this.url}) : super(type: 'webpage');

  @override
  Map<String, dynamic> toMap() {
    var map = this.toMap();
    var params = {'url': this.url};
    map.addAll({
      'params': json.encode(params),
    });
    return map;
  }

  static ChecklistActionWebpage fromMap(Map<String, dynamic> map) {
    return ChecklistActionWebpage(url: map['url']);
  }
}

class ChecklistActionCreateCard extends ChecklistAction {
  String entryType;

  ChecklistActionCreateCard({required this.entryType}) : super(type: 'card');

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    var params = {'entryType': this.entryType};
    map.addAll({
      'params': params,
    });
    return map;
  }

  static ChecklistActionCreateCard fromMap(Map<String, dynamic> map) {
    return ChecklistActionCreateCard(entryType: map['entryType']);
  }
}
