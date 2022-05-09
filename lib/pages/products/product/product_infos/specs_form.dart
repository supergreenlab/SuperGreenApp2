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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/accessories_specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/complete_kit_specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/electricity_specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/fertilizer_specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/furniture_specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/irrigation_specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/lighting_specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/other_specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/ph_ec_specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/seedling_specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/seeds_specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/sensors_specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/substrat_specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/ventilation_specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/widgets.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';

abstract class SpecsFormState<T extends StatefulWidget> extends State<T> {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
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
            SpecTextField(
              labelText: 'Name',
              hintText: this.hintText,
              controller: nameController,
              onChanged: (_) {
                setState(() {});
              },
            ),
            ...formFields(context),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: GreenButton(
            title: 'CREATE PRODUCT',
            onPressed: isValid()
                ? () {
                    Product product = createProduct();
                    BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: product));
                  }
                : null,
          ),
        ),
      ),
    ];
    return Column(children: children);
  }

  List<Widget> formFields(BuildContext context);
  Product createProduct();
  bool isValid();
  String get hintText;
}

Map<ProductCategoryID, Widget Function()> productSpecsForms = {
  ProductCategoryID.SEED: () => SeedsSpecsForm(),
  ProductCategoryID.COMPLETE_KIT: () => CompleteKitSpecsForm(),
  ProductCategoryID.VENTILATION: () => VentilationSpecsForm(),
  ProductCategoryID.LIGHTING: () => LightingSpecsForm(),
  ProductCategoryID.SENSORS: () => SensorsSpecsForm(),
  ProductCategoryID.PH_EC: () => PHECSpecsForm(),
  ProductCategoryID.SUBSTRAT: () => SubstratSpecsForm(),
  ProductCategoryID.FERTILIZER: () => FertilizerSpecsForm(),
  ProductCategoryID.IRRIGATION: () => IrrigationSpecsForm(),
  ProductCategoryID.FURNITURE: () => FurnitureSpecsForm(),
  ProductCategoryID.SEEDLING: () => SeedlingSpecsForm(),
  ProductCategoryID.ACCESSORIES: () => AccessoriesSpecsForm(),
  ProductCategoryID.ELECTRICITY: () => ElectricitySpecsForm(),
  ProductCategoryID.OTHER: () => OtherSpecsForm(),
};
