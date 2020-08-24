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

class Product extends Equatable {
  final String name;
  final String url;

  Product(this.name, this.url);

  @override
  List<Object> get props => [name, url];
}

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
      yield ProductsBlocStateLoaded(event.products);
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

  void loadProducts();
  Stream<ProductsBlocState> updateProducts(List<Product> products);
  Future<void> close();
}
