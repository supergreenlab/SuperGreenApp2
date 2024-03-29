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

import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_entry_params.dart';

enum NutrientMixPhase {
  EARLY_VEG,
  MID_VEG,
  LATE_VEG,
  EARLY_BLOOM,
  MID_BLOOM,
  LATE_BLOOM,
}

class NutrientProduct extends Equatable {
  final double? quantity;
  final String unit;
  final Product product;

  NutrientProduct({required this.product, this.quantity, required this.unit});

  factory NutrientProduct.fromMap(Map<String, dynamic> map) {
    return NutrientProduct(
      quantity: map['quantity'],
      unit: map['unit'],
      product: Product.fromMap(map['product']),
    );
  }

  Map<String, dynamic> toMap() {
    return {'quantity': quantity, 'unit': unit, 'product': product.toMap()};
  }

  @override
  List<Object?> get props => [product, quantity, unit];

  NutrientProduct copyWith({Product? product, double? quantity, String? unit}) {
    return NutrientProduct(
        product: product ?? this.product, quantity: quantity ?? this.quantity, unit: unit ?? this.unit);
  }
}

class FeedNutrientMixParams extends FeedEntryParams {
  final String? name;
  final double volume;
  final double? ph;
  final double? ec;
  final double? tds;
  final List<NutrientProduct> nutrientProducts;
  final String? message;
  final NutrientMixPhase? phase;
  final String? basedOn;

  FeedNutrientMixParams({
    required this.name,
    required this.volume,
    required this.ph,
    required this.ec,
    required this.tds,
    required this.nutrientProducts,
    required this.message,
    this.phase,
    required this.basedOn,
  });

  FeedNutrientMixParams copyWith({String? name, String? message}) => FeedNutrientMixParams(
      name: name ?? this.name,
      volume: this.volume,
      ph: this.ph,
      ec: this.ec,
      tds: this.tds,
      nutrientProducts: this.nutrientProducts,
      message: message ?? this.message,
      phase: this.phase,
      basedOn: this.basedOn);

  factory FeedNutrientMixParams.fromJSON(String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    List<dynamic>? nps = map['nutrientProducts'];
    return FeedNutrientMixParams(
      name: map['name'],
      volume: map['volume'],
      ph: map['ph'],
      ec: map['ec'],
      tds: map['tds'],
      nutrientProducts: (nps ?? []).map((np) => NutrientProduct.fromMap(np)).toList(),
      message: map['message'],
      phase: map['phase'] == null ? null : EnumToString.fromString(NutrientMixPhase.values, map['phase'] as String),
      basedOn: map['basedOn'],
    );
  }

  @override
  String toJSON() {
    return JsonEncoder().convert({
      'name': name,
      'volume': volume,
      'ph': ph,
      'ec': ec,
      'tds': tds,
      'nutrientProducts': (nutrientProducts).map((np) => np.toMap()).toList(),
      'message': message,
      'phase': this.phase == null ? null : EnumToString.convertToString(this.phase),
      'basedOn': basedOn,
    });
  }

  @override
  List<Object?> get props => [name, volume, ph, ec, tds, nutrientProducts, message];
}
