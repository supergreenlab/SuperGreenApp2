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
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/products/products_bloc.dart';

abstract class SelectNewProductBlocEvent extends Equatable {}

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

abstract class SelectNewProductBlocState extends Equatable {}

class SelectNewProductBlocStateInit extends SelectNewProductBlocState {
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

class SelectNewProductBlocStateDone extends SelectNewProductBlocState {
  final Product product;

  SelectNewProductBlocStateDone(this.product);

  @override
  List<Object> get props => [product];
}

class SelectNewProductBloc
    extends Bloc<SelectNewProductBlocEvent, SelectNewProductBlocState> {
  final MainNavigateToSelectNewProductEvent args;

  SelectNewProductBloc(this.args) : super(SelectNewProductBlocStateInit());

  @override
  Stream<SelectNewProductBlocState> mapEventToState(
      SelectNewProductBlocEvent event) async* {
    if (event is SelectNewProductBlocEventSearchTerms) {
    } else if (event is SelectNewProductBlocEventCreateProduct) {
      yield SelectNewProductBlocStateCreatingProduct();
      await Future.delayed(Duration(seconds: 1));
      yield SelectNewProductBlocStateDone(event.product);
    }
  }
}
