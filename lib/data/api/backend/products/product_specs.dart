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

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/data/api/backend/products/specs/accessories_specs.dart';
import 'package:super_green_app/data/api/backend/products/specs/complete_kit_specs.dart';
import 'package:super_green_app/data/api/backend/products/specs/electricity_specs.dart';
import 'package:super_green_app/data/api/backend/products/specs/fertilizer_specs.dart';
import 'package:super_green_app/data/api/backend/products/specs/furniture_specs.dart';
import 'package:super_green_app/data/api/backend/products/specs/irrigation_specs.dart';
import 'package:super_green_app/data/api/backend/products/specs/lighting_specs.dart';
import 'package:super_green_app/data/api/backend/products/specs/other_specs.dart';
import 'package:super_green_app/data/api/backend/products/specs/ph_ec_specs.dart';
import 'package:super_green_app/data/api/backend/products/specs/seed_specs.dart';
import 'package:super_green_app/data/api/backend/products/specs/seedling_specs.dart';
import 'package:super_green_app/data/api/backend/products/specs/sensors_specs.dart';
import 'package:super_green_app/data/api/backend/products/specs/substrat_specs.dart';
import 'package:super_green_app/data/api/backend/products/specs/ventilation_specs.dart';

abstract class ProductSpecs extends Equatable {
  ProductSpecs();

  factory ProductSpecs.fromMap(
      ProductCategoryID categoryID, Map<String, dynamic> map) {
    return productSpecsBuilders[categoryID].fromMap(map);
  }

  factory ProductSpecs.fromJSON(ProductCategoryID categoryID, String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    return ProductSpecs.fromMap(categoryID, map);
  }

  Map<String, dynamic> toMap();

  String toJSON() => JsonEncoder().convert(toMap());
}

class ProductSpecsBuilder {
  final ProductSpecs Function(String json) fromJSON;
  final ProductSpecs Function(Map<String, dynamic> map) fromMap;

  ProductSpecsBuilder({this.fromJSON, this.fromMap});
}

Map<ProductCategoryID, ProductSpecsBuilder> productSpecsBuilders = {
  ProductCategoryID.SEED: ProductSpecsBuilder(
      fromJSON: (String json) => SeedSpecs.fromJSON(json),
      fromMap: (Map<String, dynamic> map) => SeedSpecs.fromMap(map)),
  ProductCategoryID.COMPLETE_KIT: ProductSpecsBuilder(
      fromJSON: (String json) => CompleteKitSpecs.fromJSON(json),
      fromMap: (Map<String, dynamic> map) => CompleteKitSpecs.fromMap(map)),
  ProductCategoryID.VENTILATION: ProductSpecsBuilder(
      fromJSON: (String json) => VentilationSpecs.fromJSON(json),
      fromMap: (Map<String, dynamic> map) => VentilationSpecs.fromMap(map)),
  ProductCategoryID.LIGHTING: ProductSpecsBuilder(
      fromJSON: (String json) => LightingSpecs.fromJSON(json),
      fromMap: (Map<String, dynamic> map) => LightingSpecs.fromMap(map)),
  ProductCategoryID.SENSORS: ProductSpecsBuilder(
      fromJSON: (String json) => SensorsSpecs.fromJSON(json),
      fromMap: (Map<String, dynamic> map) => SensorsSpecs.fromMap(map)),
  ProductCategoryID.PH_EC: ProductSpecsBuilder(
      fromJSON: (String json) => PHECSpecs.fromJSON(json),
      fromMap: (Map<String, dynamic> map) => PHECSpecs.fromMap(map)),
  ProductCategoryID.SUBSTRAT: ProductSpecsBuilder(
      fromJSON: (String json) => SubstratSpecs.fromJSON(json),
      fromMap: (Map<String, dynamic> map) => SubstratSpecs.fromMap(map)),
  ProductCategoryID.FERTILIZER: ProductSpecsBuilder(
      fromJSON: (String json) => FertilizerSpecs.fromJSON(json),
      fromMap: (Map<String, dynamic> map) => FertilizerSpecs.fromMap(map)),
  ProductCategoryID.IRRIGATION: ProductSpecsBuilder(
      fromJSON: (String json) => IrrigationSpecs.fromJSON(json),
      fromMap: (Map<String, dynamic> map) => IrrigationSpecs.fromMap(map)),
  ProductCategoryID.FURNITURE: ProductSpecsBuilder(
      fromJSON: (String json) => FurnitureSpecs.fromJSON(json),
      fromMap: (Map<String, dynamic> map) => FurnitureSpecs.fromMap(map)),
  ProductCategoryID.SEEDLING: ProductSpecsBuilder(
      fromJSON: (String json) => SeedlingSpecs.fromJSON(json),
      fromMap: (Map<String, dynamic> map) => SeedlingSpecs.fromMap(map)),
  ProductCategoryID.ACCESSORIES: ProductSpecsBuilder(
      fromJSON: (String json) => AccessoriesSpecs.fromJSON(json),
      fromMap: (Map<String, dynamic> map) => AccessoriesSpecs.fromMap(map)),
  ProductCategoryID.ELECTRICITY: ProductSpecsBuilder(
      fromJSON: (String json) => ElectricitySpecs.fromJSON(json),
      fromMap: (Map<String, dynamic> map) => ElectricitySpecs.fromMap(map)),
  ProductCategoryID.OTHER: ProductSpecsBuilder(
      fromJSON: (String json) => OtherSpecs.fromJSON(json),
      fromMap: (Map<String, dynamic> map) => OtherSpecs.fromMap(map)),
};
