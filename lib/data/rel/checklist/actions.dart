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
import 'package:super_green_app/data/assets/feed_entry.dart';

abstract class ChecklistAction extends Equatable {
  final String type;

  String get asSentence => '$type';
  String get statusString => '';
  bool get hasBody => false;

  ChecklistAction({required this.type});

  Map<String, dynamic> toMap() {
    return {
      'type': type,
    };
  }

  String toJSON() => json.encode(toMap());

  List<Object?> get props => [
        type,
      ];

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
      case 'card':
        return ChecklistActionCreateCard.fromMap(params);
      case 'buy_product':
        return ChecklistActionBuyProduct.fromMap(params);
      case 'message':
        return ChecklistActionMessage.fromMap(params);
      default:
        throw UnimplementedError('Action type $type is not implemented');
    }
  }

  static ChecklistAction fromJSON(String jsonStr) {
    return ChecklistAction.fromMap(json.decode(jsonStr));
  }
}

class ChecklistActionWebpage extends ChecklistAction {
  static const String TYPE = 'webpage';

  final String? url;
  final String? instructions;

  String get asSentence => 'Open webpage at ${Uri.parse(url!).host}';
  String get statusString => '';
  bool get hasBody => (instructions ?? '').length > 0;

  ChecklistActionWebpage({this.url, this.instructions}) : super(type: TYPE);

  bool get valid {
    if (url == null) {
      return false;
    }
    String u = this.url!;
    if (!url!.startsWith('http://') && !url!.startsWith('https://')) {
      u = 'https://$url';
    }
    Uri? p = Uri.tryParse(u);
    if (p == null) {
      return false;
    }
    List<String> h = p.host.split('.');
    if (h.length < 2 || h[1].length < 2) {
      return false;
    }
    return true;
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    String u = this.url!;
    if (!url!.startsWith('http://') && !url!.startsWith('https://')) {
      u = 'https://$url';
    }
    var params = {
      'url': u,
      'instructions': instructions,
    };
    map.addAll({
      'type': type,
      'params': json.encode(params),
    });
    return map;
  }

  List<Object?> get props => [...super.props, url];

  static ChecklistActionWebpage fromMap(Map<String, dynamic> map) {
    return ChecklistActionWebpage(
      url: map['url'],
      instructions: map['instructions'],
    );
  }

  ChecklistActionWebpage copyWith({
    String? url,
    String? instructions,
  }) {
    return ChecklistActionWebpage(
      url: url ?? this.url,
      instructions: instructions ?? this.instructions,
    );
  }
}

class ChecklistActionCreateCard extends ChecklistAction {
  static const String TYPE = 'card';

  final String? entryType;
  final String? instructions;

  String get asSentence => 'Create ${FeedEntryNames[entryType!]!} diary entry.';
  bool get hasBody => (instructions ?? '').length > 0;

  ChecklistActionCreateCard({this.entryType, this.instructions}) : super(type: TYPE);

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    var params = {
      'entryType': this.entryType,
      'instructions': this.instructions,
    };
    map.addAll({
      'type': type,
      'params': json.encode(params),
    });
    return map;
  }

  List<Object?> get props => [...super.props, entryType];

  static ChecklistActionCreateCard fromMap(Map<String, dynamic> map) {
    return ChecklistActionCreateCard(
      entryType: map['entryType'],
      instructions: map['instructions'],
    );
  }

  ChecklistActionCreateCard copyWith({
    String? entryType,
    String? instructions,
  }) {
    return ChecklistActionCreateCard(
      entryType: entryType ?? this.entryType,
      instructions: instructions ?? this.instructions,
    );
  }
}

class ChecklistActionBuyProduct extends ChecklistAction {
  static const String TYPE = 'buy_product';

  final String? name;
  final String? url;
  final String? instructions;

  String get asSentence => 'Get a ${name!} at ${Uri.parse(url!).host}';
  bool get hasBody => (instructions ?? '').length > 0;

  ChecklistActionBuyProduct({this.name, this.url, this.instructions}) : super(type: TYPE);

  bool get valid {
    if (url == null) {
      return false;
    }
    String u = this.url!;
    if (!url!.startsWith('http://') && !url!.startsWith('https://')) {
      u = 'https://$url';
    }
    Uri? p = Uri.tryParse(u);
    if (p == null) {
      return false;
    }
    List<String> h = p.host.split('.');
    if (h.length < 2 || h[1].length < 2) {
      return false;
    }
    return name != null;
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    String u = this.url!;
    if (!url!.startsWith('http://') && !url!.startsWith('https://')) {
      u = 'https://$url';
    }
    var params = {
      'name': name,
      'url': u,
      'instructions': instructions,
    };
    map.addAll({
      'type': type,
      'params': json.encode(params),
    });
    return map;
  }

  List<Object?> get props => [...super.props, url];

  static ChecklistActionBuyProduct fromMap(Map<String, dynamic> map) {
    return ChecklistActionBuyProduct(
      name: map['name'],
      url: map['url'],
      instructions: map['instructions'],
    );
  }

  ChecklistActionBuyProduct copyWith({
    String? name,
    String? url,
    String? instructions,
  }) {
    return ChecklistActionBuyProduct(
      name: name ?? this.name,
      url: url ?? this.url,
      instructions: instructions ?? this.instructions,
    );
  }
}

class ChecklistActionMessage extends ChecklistAction {
  static const String TYPE = 'message';

  final String? title;
  final String? instructions;

  String get asSentence => 'Show message: ${title!}';
  bool get hasBody => (instructions ?? '').length > 0;

  bool get valid {
    if (title == null) {
      return false;
    }
    return true;
  }

  ChecklistActionMessage({this.title, this.instructions}) : super(type: TYPE);

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    var params = {
      'title': this.title,
      'instructions': this.instructions,
    };
    map.addAll({
      'type': type,
      'params': json.encode(params),
    });
    return map;
  }

  List<Object?> get props => [...super.props, title];

  static ChecklistActionMessage fromMap(Map<String, dynamic> map) {
    return ChecklistActionMessage(
      title: map['title'],
      instructions: map['instructions'],
    );
  }

  ChecklistActionMessage copyWith({
    String? title,
    String? instructions,
  }) {
    return ChecklistActionMessage(
      title: title ?? this.title,
      instructions: instructions ?? this.instructions,
    );
  }
}
