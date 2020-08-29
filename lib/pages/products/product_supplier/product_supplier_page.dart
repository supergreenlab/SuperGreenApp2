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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/products/product/product_category/product_categories.dart';
import 'package:super_green_app/pages/products/product_supplier/product_supplier_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/red_button.dart';
import 'package:super_green_app/widgets/section_title.dart';

class ProductSupplierPage extends StatefulWidget {
  @override
  _ProductSupplierPageState createState() => _ProductSupplierPageState();
}

class _ProductSupplierPageState extends State<ProductSupplierPage> {
  List<Product> products = [];
  List<TextEditingController> urlControllers = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductSupplierBloc, ProductSupplierBlocState>(
      listener: (BuildContext context, ProductSupplierBlocState state) {
        if (state is ProductSupplierBlocStateLoaded) {
          setState(() {
            products = state.products;
            urlControllers = products
                .map<TextEditingController>((e) => TextEditingController())
                .toList();
          });
        }
      },
      child: BlocBuilder<ProductSupplierBloc, ProductSupplierBlocState>(
        builder: (BuildContext context, ProductSupplierBlocState state) {
          Widget body = Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SectionTitle(
                title: 'Where did you buy these items?\n(optional)',
                icon: 'assets/products/toolbox/icon_item_type.svg',
                iconPadding: 0,
              ),
            ),
            Expanded(
              child: ListView(
                children: this.products.map<Widget>((product) {
                  int i = this.products.indexOf(product);
                  final ProductCategoryUI categoryUI =
                      productCategories[product.category];
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(categoryUI.icon),
                            Text(categoryUI.name),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, left: 8, right: 8),
                                child: Text(product.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ),
                              renderTextField(
                                  context,
                                  'Link',
                                  'Ex: https://amazon.com/...',
                                  urlControllers[i]),
                            ]),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RedButton(
                    title: 'SKIP',
                    onPressed: () {
                      BlocProvider.of<MainNavigatorBloc>(context)
                          .add(MainNavigatorActionPop(param: products));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: GreenButton(
                      title: 'Ok',
                      onPressed: urlControllers.firstWhere((c) => c.text != '',
                                  orElse: () => null) !=
                              null
                          ? () {
                              List<Product> products = [];
                              for (int i = 0; i < this.products.length; ++i) {
                                products.add(this.products[i].copyWith(
                                    supplier: urlControllers[i].text != ''
                                        ? ProductSupplier(
                                            productID: this.products[i].id,
                                            url: urlControllers[i].text)
                                        : null));
                              }
                              BlocProvider.of<MainNavigatorBloc>(context)
                                  .add(MainNavigatorActionPop(param: products));
                            }
                          : null,
                    ),
                  ),
                ],
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
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: TextFormField(
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
