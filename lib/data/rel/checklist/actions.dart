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

import 'package:equatable/equatable.dart';

abstract class ChecklistAction extends Equatable {
  final String type;

  ChecklistAction({required this.type});

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'params': toJSON(),
    };
  }

  String toJSON() => json.encode(toMap());

  List<Object?> get props => [type,];

  bool get valid => !props.contains(null) && !props.contains('');

  static List<ChecklistAction> fromMapArray(List<dynamic> maps) {
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
  static const String TYPE = 'webpage';

  final String? url;

  ChecklistActionWebpage({this.url}) : super(type: TYPE);

  @override
  Map<String, dynamic> toMap() {
    var map = this.toMap();
    var params = {'url': this.url};
    map.addAll({
      'params': json.encode(params),
    });
    return map;
  }

  List<Object?> get props => [...super.props, url];

  static ChecklistActionWebpage fromMap(Map<String, dynamic> map) {
    return ChecklistActionWebpage(url: map['url']);
  }

  ChecklistActionWebpage copyWith({
    String? url,
  }) {
    return ChecklistActionWebpage(
      url: url ?? this.url,
    );
  }
}

class ChecklistActionCreateCard extends ChecklistAction {
  static const String TYPE = 'card';

  final String? entryType;

  ChecklistActionCreateCard({this.entryType}) : super(type: TYPE);

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    var params = {'entryType': this.entryType};
    map.addAll({
      'params': params,
    });
    return map;
  }

  List<Object?> get props => [...super.props, entryType];

  static ChecklistActionCreateCard fromMap(Map<String, dynamic> map) {
    return ChecklistActionCreateCard(entryType: map['entryType']);
  }

  ChecklistActionCreateCard copyWith({
    String? entryType,
  }) {
    return ChecklistActionCreateCard(
      entryType: entryType ?? this.entryType,
    );
  }
}
