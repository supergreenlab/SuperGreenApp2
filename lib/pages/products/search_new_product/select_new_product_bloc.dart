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
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SelectNewProductBlocEvent extends Equatable {}

class SelectNewProductBlocEventInit extends SelectNewProductBlocEvent {
  SelectNewProductBlocEventInit();

  @override
  List<Object> get props => [];
}

class SelectNewProductBlocEventSearchTerms extends SelectNewProductBlocEvent {
  final String searchTerms;

  SelectNewProductBlocEventSearchTerms(this.searchTerms);

  @override
  List<Object> get props => [searchTerms];
}

class SelectNewProductBlocEventCreateProduct extends SelectNewProductBlocEvent {
  final Product product;

  SelectNewProductBlocEventCreateProduct(this.product);

  @override
  List<Object> get props => [product];
}

class SelectNewProductBlocEventCreateProductSuppliers
    extends SelectNewProductBlocEvent {
  final List<Product> products;

  SelectNewProductBlocEventCreateProductSuppliers(this.products);

  @override
  List<Object> get props => [products];
}

abstract class SelectNewProductBlocState extends Equatable {}

class SelectNewProductBlocStateInit extends SelectNewProductBlocState {
  @override
  List<Object> get props => [];
}

class SelectNewProductBlocStateSelectedProducts
    extends SelectNewProductBlocState {
  final List<Product> selectedProducts;

  SelectNewProductBlocStateSelectedProducts(this.selectedProducts);

  @override
  List<Object> get props => [selectedProducts];
}

class SelectNewProductBlocStateLoading extends SelectNewProductBlocState {
  @override
  List<Object> get props => [];
}

class SelectNewProductBlocStateLoaded extends SelectNewProductBlocState {
  final List<Product> products;

  SelectNewProductBlocStateLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class SelectNewProductBlocStateCreatingProduct
    extends SelectNewProductBlocState {
  @override
  List<Object> get props => [];
}

class SelectNewProductBlocStateCreatingProductSuppliers
    extends SelectNewProductBlocState {
  @override
  List<Object> get props => [];
}

class SelectNewProductBlocStateCreateProductDone
    extends SelectNewProductBlocState {
  final Product product;

  SelectNewProductBlocStateCreateProductDone(this.product);

  @override
  List<Object> get props => [product];
}

class SelectNewProductBlocStateDone extends SelectNewProductBlocState {
  final List<Product> products;

  SelectNewProductBlocStateDone(this.products);

  @override
  List<Object> get props => [products];
}

class SelectNewProductBloc
    extends Bloc<SelectNewProductBlocEvent, SelectNewProductBlocState> {
  final MainNavigateToSelectNewProductEvent args;

  SelectNewProductBloc(this.args) : super(SelectNewProductBlocStateInit()) {
    add(SelectNewProductBlocEventInit());
  }

  @override
  Stream<SelectNewProductBlocState> mapEventToState(
      SelectNewProductBlocEvent event) async* {
    if (event is SelectNewProductBlocEventInit) {
      yield SelectNewProductBlocStateSelectedProducts(args.selectedProducts);
    } else if (event is SelectNewProductBlocEventSearchTerms) {
      yield SelectNewProductBlocStateLoading();
      try {
        List<Product> products = await BackendAPI()
            .productsAPI
            .searchProducts(event.searchTerms, categoryID: args.categoryID);
        yield SelectNewProductBlocStateLoaded(products);
      } catch (e) {
        yield SelectNewProductBlocStateLoaded([]);
      }
    } else if (event is SelectNewProductBlocEventCreateProduct) {
      yield SelectNewProductBlocStateCreatingProduct();
      String productID =
          await BackendAPI().productsAPI.createProduct(event.product);
      Product product = event.product.copyWith(id: productID);
      yield SelectNewProductBlocStateCreateProductDone(product);
    } else if (event is SelectNewProductBlocEventCreateProductSuppliers) {
      yield SelectNewProductBlocStateCreatingProductSuppliers();
      List<Product> products = [];
      for (Product product in event.products) {
        if (product.supplier != null) {
          String productSupplierID = await BackendAPI()
              .productsAPI
              .createProductSupplier(product.supplier);
          products.add(product.copyWith(
              supplier: product.supplier.copyWith(id: productSupplierID)));
        } else {
          products.add(product);
        }
      }
      yield SelectNewProductBlocStateDone(products);
    }
  }
}
