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

import 'package:equatable/equatable.dart';

enum ProductTypeID {
  VENTILATION,
  LIGHTING,
  COMPLETE_KIT,
  SENSORS,
  PH_EC,
  SUBSTRAT,
  FERTILIZER,
  IRRIGATION,
  FURNITURE,
  SEEDLING,
  ACCESSORIES,
  ELECTRICITY,
  OTHER,
}

class Product extends Equatable {
  final String id;
  final String name;
  final ProductTypeID type;
  final ProductSupplier supplier;

  Product({this.id, this.name, this.type, this.supplier});

  @override
  List<Object> get props => [id, name, type, supplier];
}

class ProductSupplier extends Equatable {
  final String id;
  final String url;

  ProductSupplier({this.id, this.url});

  @override
  List<Object> get props => [id, url];
}
