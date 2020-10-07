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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/box_settings.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';

abstract class ProductsBlocEvent extends Equatable {}

class ProductsBlocEventInit extends ProductsBlocEvent {
  @override
  List<Object> get props => [];
}

class ProductsBlocEventLoaded extends ProductsBlocEvent {
  final List<Product> products;

  ProductsBlocEventLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class ProductsBlocEventUpdate extends ProductsBlocEvent {
  final List<Product> products;

  ProductsBlocEventUpdate(this.products);

  @override
  List<Object> get props => [products];
}

abstract class ProductsBlocState extends Equatable {}

class ProductsBlocStateLoading extends ProductsBlocState {
  @override
  List<Object> get props => [];
}

class ProductsBlocStateLoaded extends ProductsBlocState {
  final List<Product> products;

  ProductsBlocStateLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class ProductsBloc extends Bloc<ProductsBlocEvent, ProductsBlocState> {
  final ProductsBlocDelegate delegate;

  ProductsBloc(this.delegate) : super(ProductsBlocStateLoading()) {
    delegate.init(this.add);
    add(ProductsBlocEventInit());
  }

  @override
  Stream<ProductsBlocState> mapEventToState(ProductsBlocEvent event) async* {
    if (event is ProductsBlocEventInit) {
      delegate.loadProducts();
    } else if (event is ProductsBlocEventLoaded) {
      List<Product> products = event.products;
      products.sort((p1, p2) => p1.category.index - p2.category.index);
      yield ProductsBlocStateLoaded(products);
    } else if (event is ProductsBlocEventUpdate) {
      yield* delegate.updateProducts(event.products);
    }
  }

  @override
  Future<void> close() async {
    await delegate.close();
    return super.close();
  }
}

abstract class ProductsBlocDelegate {
  List<Product> products;
  Function(ProductsBlocEvent) add;

  void init(Function(ProductsBlocEvent) add) {
    this.add = add;
  }

  void productsLoaded(PlantSettings plantSettings, BoxSettings boxSettings) {
    List<Product> products = [];
    products.addAll(plantSettings.products);
    products.addAll(boxSettings.products);
    add(ProductsBlocEventLoaded(products));
  }

  void loadProducts();
  Stream<ProductsBlocState> updateProducts(List<Product> products);
  Future<void> close();
}
