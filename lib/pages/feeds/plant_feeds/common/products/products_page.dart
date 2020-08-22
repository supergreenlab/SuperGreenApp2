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
import 'package:super_green_app/pages/feeds/plant_feeds/common/products/products_bloc.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsBlocState>(
        cubit: BlocProvider.of<ProductsBloc>(context),
        builder: (BuildContext context, ProductsBlocState state) {
          if (state is ProductsBlocStateLoading) {
            return _renderLoading(context, state);
          }
          return _renderLoaded(context, state);
        });
  }

  Widget _renderLoading(BuildContext context, ProductsBlocStateLoading state) {
    return FullscreenLoading(
      title: "Loading plant data",
    );
  }

  Widget _renderLoaded(BuildContext context, ProductsBlocStateLoaded state) {
    return Container(
      child: ListView(
        children: [
          _renderList(context, [], 'Box Build'),
          _renderList(context, [], 'Seed'),
          _renderList(context, [], 'Medium'),
          _renderList(context, [], 'Watering'),
        ],
      ),
    );
  }

  Widget _renderList(
      BuildContext context, List<Product> products, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [Text('pouet', style: TextStyle(color: Colors.white))],
          ),
        ],
      ),
    );
  }
}
