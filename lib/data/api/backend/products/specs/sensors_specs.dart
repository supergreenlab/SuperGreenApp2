/*
 * Copyright (C) 2020  SuperGreenLab <towelie@supergreenlab.com>
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

import 'package:super_green_app/data/api/backend/products/product_specs.dart';

class SensorsSpecs extends ProductSpecs {
  final String brand;

  SensorsSpecs({this.brand});

  @override
  List<Object> get props => [brand];

  @override
  Map<String, dynamic> toMap() {
    return {'brand': brand};
  }

  factory SensorsSpecs.fromMap(Map<String, dynamic> map) {
    return SensorsSpecs(brand: map['brand']);
  }

  factory SensorsSpecs.fromJSON(String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    return SensorsSpecs.fromMap(map);
  }

  @override
  String get by => brand;
}
