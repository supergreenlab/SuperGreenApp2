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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/pages/products/product/product_infos/product_infos_bloc.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs_form.dart';
import 'package:super_green_app/widgets/appbar.dart';

class ProductInfosPage extends TraceableStatefulWidget {
  @override
  _ProductInfosPageState createState() => _ProductInfosPageState();
}

class _ProductInfosPageState extends State<ProductInfosPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductInfosBloc, ProductInfosBlocState>(
      listener: (BuildContext context, ProductInfosBlocState state) {},
      child: BlocBuilder<ProductInfosBloc, ProductInfosBlocState>(
        builder: (BuildContext context, ProductInfosBlocState state) {
          Widget body = productSpecsForms[state.productCategoryID]!();
          return Scaffold(
              appBar: SGLAppBar(
                '🛠',
                fontSize: 40,
                backgroundColor: Color(0xff0EA9DA),
                titleColor: Colors.white,
                iconColor: Colors.white,
              ),
              backgroundColor: Colors.white,
              body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body));
        },
      ),
    );
  }
}
