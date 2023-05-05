/*
 * Copyright (C) 2023  SuperGreenLab <towelie@supergreenlab.com>
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

class Config {
	late String name;
	late List<Keys> keys;

	Config({required this.name, required this.keys});

  Config.fromString(String config) : this.fromMap(jsonDecode(config));

	Config.fromMap(Map<String, dynamic> json) {
		name = json['name'];
		keys = <Keys>[];
		json['keys'].forEach((v) { keys.add(new Keys.fromMap(v)); });
	}

	Map<String, dynamic> toMap() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['name'] = this.name;
    data['keys'] = this.keys.map((v) => v.toMap()).toList();
		return data;
	}
}

class Keys {
	late bool core;
	late String name;
	late String type;
	late bool integer;
	late String capsName;
	late String module;
	late bool write;
	int? defaultValueInt;
	String? defaultValueString;
	Array? array;
	Indir? indir;
	String? helper;

	Keys({required this.core, required this.name, required this.type, required this.integer, required this.capsName, required this.module, required this.write, this.defaultValueInt, this.defaultValueString, this.array, this.indir, this.helper});

	Keys.fromMap(Map<String, dynamic> json) {
		core = json['core'];
		name = json['name'];
		type = json['type'];
		integer = json['integer'];
		capsName = json['caps_name'];
		module = json['module'];
		write = json['write'];
    if (integer) {
      defaultValueInt = json['default'];
    } else {
		  defaultValueString = json['default'];
    }
		array = json['array'] != null ? new Array.fromMap(json['array']) : null;
		indir = json['indir'] != null ? new Indir.fromMap(json['indir']) : null;
		helper = json['helper'];
	}

	Map<String, dynamic> toMap() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['core'] = this.core;
		data['name'] = this.name;
		data['type'] = this.type;
		data['integer'] = this.integer;
		data['caps_name'] = this.capsName;
		data['module'] = this.module;
		data['write'] = this.write;
    if (this.integer) {
		  data['default'] = this.defaultValueInt;
    } else {
      data['default'] = this.defaultValueString;
    }
		if (this.array != null) {
      data['array'] = this.array!.toMap();
    }
		if (this.indir != null) {
      data['indir'] = this.indir!.toMap();
    }
		data['helper'] = this.helper;
		return data;
	}
}

class Array {
	late String name;
	late int len;
	late int index;
	late String param;

	Array({required this.name, required this.len, required this.index, required this.param});

	Array.fromMap(Map<String, dynamic> json) {
		name = json['name'];
		len = json['len'];
		index = json['index'];
		param = json['param'];
	}

	Map<String, dynamic> toMap() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['name'] = this.name;
		data['len'] = this.len;
		data['index'] = this.index;
		data['param'] = this.param;
		return data;
	}
}

class Indir {
	late List<int> values;
	late List<String> helpers;

	Indir({required this.values, required this.helpers});

	Indir.fromMap(Map<String, dynamic> json) {
		values = json['values'].cast<int>();
		helpers = json['helpers'].cast<String>();
	}

	Map<String, dynamic> toMap() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['values'] = this.values;
		data['helpers'] = this.helpers;
		return data;
	}
}
