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

import 'package:flutter/foundation.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/backend/products/models.dart';

class ProductsAPI {
  Future<String> createProduct(Product product) async {
    Map<String, dynamic> obj = product.toMap(json: true);
    obj.remove('supplier');
    String serverID = await BackendAPI().postPut('/product', obj);
    return serverID;
  }

  Future<String> createProductSupplier(ProductSupplier productSupplier) async {
    Map<String, dynamic> obj = productSupplier.toMap();
    String serverID = await BackendAPI().postPut('/productsupplier', obj);
    return serverID;
  }

  Future<List<Product>> searchProducts(String terms,
      {ProductCategoryID categoryID}) async {
    String url = '/products/search?terms=${Uri.encodeQueryComponent(terms)}';
    if (categoryID != null) {
      url += '&category=${describeEnum(categoryID)}';
    }
    Map<String, dynamic> productResults = await BackendAPI().get(url);
    List<dynamic> products = productResults['products'];
    return products
        .map<Product>((p) => Product.fromMap(p, json: true))
        .toList();
  }
}
