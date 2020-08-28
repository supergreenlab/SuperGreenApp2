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

import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:super_green_app/data/api/backend/products/product_specs.dart';

enum ProductCategoryID {
  SEED,
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

List<ProductCategoryID> plantProductCategories = [
  ProductCategoryID.SEED,
  ProductCategoryID.SUBSTRAT,
  ProductCategoryID.FERTILIZER,
  ProductCategoryID.SEEDLING,
];

class Product extends Equatable {
  final String id;
  final String name;
  final ProductSpecs specs;
  final ProductCategoryID category;
  final ProductSupplier supplier;

  Product({this.id, this.name, this.specs, this.category, this.supplier});

  @override
  List<Object> get props => [id, name, specs, category, supplier];

  static Product fromMap(Map<String, dynamic> map, {bool json = false}) {
    List<dynamic> categories;
    if (json) {
      categories = JsonDecoder().convert(map['categories']);
    } else {
      categories = map['categories'] ?? [];
    }
    ProductCategoryID categoryID;
    if (categories.length > 0) {
      categoryID =
          EnumToString.fromString(ProductCategoryID.values, categories[0]);
    }
    ProductSupplier productSupplier;
    if (map['supplier'] != null) {
      productSupplier = ProductSupplier.fromMap(map['supplier']);
    }

    ProductSpecs specs;
    if (categoryID != null && map['specs'] != null) {
      if (json) {
        specs = productSpecsBuilders[categoryID].fromJSON(map[specs]);
      } else {
        specs = productSpecsBuilders[categoryID].fromMap(map[specs]);
      }
    }
    return Product(
      id: map['id'],
      name: map['name'],
      specs: specs,
      category: categoryID,
      supplier: productSupplier,
    );
  }

  Map<String, dynamic> toMap({bool json = false}) {
    List<String> categories = [];
    if (category != null) {
      categories = [describeEnum(category)];
    }
    return {
      'id': id,
      'name': name,
      'specs': json ? specs.toJSON() : specs.toMap(),
      'categories': json ? JsonEncoder().convert(categories) : categories,
      'supplier': supplier != null ? supplier.toMap() : null,
    };
  }

  Product copyWith(
      {String id,
      String name,
      ProductSpecs specs,
      ProductCategoryID category,
      ProductSupplier supplier}) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      specs: specs ?? this.specs,
      category: category ?? this.category,
      supplier: supplier ?? this.supplier,
    );
  }
}

class ProductSupplier extends Equatable {
  final String id;
  final String productID;
  final String url;

  ProductSupplier({this.id, this.productID, this.url});

  @override
  List<Object> get props => [id, productID, url];

  static ProductSupplier fromMap(Map<String, dynamic> map) {
    return ProductSupplier(
      id: map['id'],
      productID: map['productID'],
      url: map['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productID': productID,
      'url': url,
    };
  }

  ProductSupplier copyWith({String id, String productID, String url}) {
    return ProductSupplier(
      id: id ?? this.id,
      productID: productID ?? this.productID,
      url: url ?? this.url,
    );
  }
}
