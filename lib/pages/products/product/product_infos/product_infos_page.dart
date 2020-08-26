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
import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/products/product/product_infos/product_infos_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';

class ProductInfosPage extends StatefulWidget {
  @override
  _ProductInfosPageState createState() => _ProductInfosPageState();
}

class _ProductInfosPageState extends State<ProductInfosPage> {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductInfosBloc, ProductInfosBlocState>(
      listener: (BuildContext context, ProductInfosBlocState state) {},
      child: BlocBuilder<ProductInfosBloc, ProductInfosBlocState>(
        builder: (BuildContext context, ProductInfosBlocState state) {
          Widget body = Column(children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SectionTitle(
                      title: 'Product informations',
                      icon: 'assets/products/toolbox/icon_item_type.svg',
                      iconPadding: 0,
                    ),
                  ),
                  renderTextField(
                      context, 'Name', 'Ex: Megacrop', nameController),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: GreenButton(
                  title: 'CREATE PRODUCT',
                  onPressed: nameController.text == ''
                      ? null
                      : () {
                          Product product = Product(name: nameController.text);
                          BlocProvider.of<MainNavigatorBloc>(context)
                              .add(MainNavigatorActionPop(param: product));
                        },
                ),
              ),
            ),
          ]);
          return Scaffold(
              appBar: SGLAppBar(
                '🛠',
                fontSize: 40,
                backgroundColor: Color(0xff0EA9DA),
                titleColor: Colors.white,
                iconColor: Colors.white,
              ),
              backgroundColor: Colors.white,
              body: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200), child: body));
        },
      ),
    );
  }

  Widget renderTextField(BuildContext context, String labelText,
      String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8),
      child: TextFormField(
        autofocus: true,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black38),
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        ),
        style: TextStyle(color: Colors.black, decoration: TextDecoration.none),
        controller: controller,
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }
}
