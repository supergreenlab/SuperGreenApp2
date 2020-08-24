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

enum ProductTypeName {
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

class ProductType extends Equatable {
  final String name;
  final String icon;

  ProductType(this.name, this.icon);

  @override
  List<Object> get props => [];
}

Map<ProductTypeName, ProductType> productTypes = {
  ProductTypeName.COMPLETE_KIT: ProductType(
      'Complete kit', 'assets/products/toolbox/icon_complete_kit.svg'),
  ProductTypeName.VENTILATION: ProductType(
      'Ventilation', 'assets/products/toolbox/icon_ventilation.svg'),
  ProductTypeName.LIGHTING:
      ProductType('Lighting', 'assets/products/toolbox/icon_lighting.svg'),
  ProductTypeName.SENSORS:
      ProductType('Sensors', 'assets/products/toolbox/icon_sensors.svg'),
  ProductTypeName.PH_EC:
      ProductType('PH/EC', 'assets/products/toolbox/icon_ph_ec.svg'),
  ProductTypeName.SUBSTRAT:
      ProductType('Substrat', 'assets/products/toolbox/icon_substrat.svg'),
  ProductTypeName.FERTILIZER:
      ProductType('Fertilizer', 'assets/products/toolbox/icon_fertilizer.svg'),
  ProductTypeName.IRRIGATION:
      ProductType('Irrigation', 'assets/products/toolbox/icon_irrigation.svg'),
  ProductTypeName.FURNITURE:
      ProductType('Furniture', 'assets/products/toolbox/icon_furniture.svg'),
  ProductTypeName.SEEDLING:
      ProductType('Seedling', 'assets/products/toolbox/icon_seedling.svg'),
  ProductTypeName.ACCESSORIES: ProductType(
      'Accessories', 'assets/products/toolbox/icon_accessories.svg'),
  ProductTypeName.ELECTRICITY: ProductType(
      'Electricity', 'assets/products/toolbox/icon_electricity.svg'),
  ProductTypeName.OTHER:
      ProductType('Other', 'assets/products/toolbox/icon_other.svg'),
};
