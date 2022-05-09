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

import 'package:equatable/equatable.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class ProductSupplierBlocEvent extends Equatable {}

class ProductSupplierBlocEventInit extends ProductSupplierBlocEvent {
  ProductSupplierBlocEventInit();

  @override
  List<Object> get props => [];
}

abstract class ProductSupplierBlocState extends Equatable {}

class ProductSupplierBlocStateInit extends ProductSupplierBlocState {
  ProductSupplierBlocStateInit();

  @override
  List<Object> get props => [];
}

class ProductSupplierBlocStateLoaded extends ProductSupplierBlocState {
  final List<Product> products;

  ProductSupplierBlocStateLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class ProductSupplierBloc extends LegacyBloc<ProductSupplierBlocEvent, ProductSupplierBlocState> {
  final MainNavigateToProductSupplierEvent args;

  ProductSupplierBloc(this.args) : super(ProductSupplierBlocStateInit()) {
    add(ProductSupplierBlocEventInit());
  }

  @override
  Stream<ProductSupplierBlocState> mapEventToState(ProductSupplierBlocEvent event) async* {
    if (event is ProductSupplierBlocEventInit) {
      yield ProductSupplierBlocStateLoaded(args.products);
    }
  }
}
