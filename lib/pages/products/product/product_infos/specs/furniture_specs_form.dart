import 'package:flutter/material.dart';
import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/data/api/backend/products/specs/furniture_specs.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/widgets.dart';

class FurnitureSpecsForm extends StatefulWidget {
  @override
  _FurnitureSpecsFormState createState() => _FurnitureSpecsFormState();
}

class _FurnitureSpecsFormState extends SpecsFormState<FurnitureSpecsForm> {
  TextEditingController brandController = TextEditingController();

  @override
  List<Widget> formFields(BuildContext context) {
    return [
      SpecTextField(
        labelText: 'Brand',
        hintText: 'Ex: Ikea',
        controller: brandController,
        onChanged: (_) {
          setState(() {});
        },
      ),
    ];
  }

  @override
  Product createProduct() {
    return Product(
        name: nameController.text,
        specs: FurnitureSpecs(brand: brandController.text));
  }

  @override
  bool isValid() {
    return nameController.text != '' && brandController.text != '';
  }

  String get hintText => 'Ex: Eket';
}
