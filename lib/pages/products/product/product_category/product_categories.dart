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
import 'package:super_green_app/data/api/backend/products/models.dart';

class ProductCategoryUI extends Equatable {
  final String name;
  final String icon;

  ProductCategoryUI(this.name, this.icon);

  @override
  List<Object> get props => [];
}

Map<ProductCategoryID, ProductCategoryUI> productCategories = {
  ProductCategoryID.SEED:
      ProductCategoryUI('Seeds', 'assets/products/toolbox/icon_seed.svg'),
  ProductCategoryID.COMPLETE_KIT: ProductCategoryUI(
      'Complete kit', 'assets/products/toolbox/icon_complete_kit.svg'),
  ProductCategoryID.VENTILATION: ProductCategoryUI(
      'Ventilation', 'assets/products/toolbox/icon_ventilation.svg'),
  ProductCategoryID.LIGHTING: ProductCategoryUI(
      'Lighting', 'assets/products/toolbox/icon_lighting.svg'),
  ProductCategoryID.SENSORS:
      ProductCategoryUI('Sensors', 'assets/products/toolbox/icon_sensors.svg'),
  ProductCategoryID.PH_EC:
      ProductCategoryUI('PH/EC', 'assets/products/toolbox/icon_ph_ec.svg'),
  ProductCategoryID.SUBSTRAT: ProductCategoryUI(
      'Substrat', 'assets/products/toolbox/icon_substrat.svg'),
  ProductCategoryID.FERTILIZER: ProductCategoryUI(
      'Fertilizer', 'assets/products/toolbox/icon_fertilizer.svg'),
  ProductCategoryID.IRRIGATION: ProductCategoryUI(
      'Irrigation', 'assets/products/toolbox/icon_irrigation.svg'),
  ProductCategoryID.FURNITURE: ProductCategoryUI(
      'Furniture', 'assets/products/toolbox/icon_furniture.svg'),
  ProductCategoryID.SEEDLING: ProductCategoryUI(
      'Seedling', 'assets/products/toolbox/icon_seedling.svg'),
  ProductCategoryID.ACCESSORIES: ProductCategoryUI(
      'Accessories', 'assets/products/toolbox/icon_accessories.svg'),
  ProductCategoryID.ELECTRICITY: ProductCategoryUI(
      'Electricity', 'assets/products/toolbox/icon_electricity.svg'),
  ProductCategoryID.OTHER:
      ProductCategoryUI('Other', 'assets/products/toolbox/icon_other.svg'),
};
