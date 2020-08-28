import 'package:flutter/material.dart';
import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/data/api/backend/products/specs/accessories_specs.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/widgets.dart';

class AccessoriesSpecsForm extends StatefulWidget {
  @override
  _AccessoriesSpecsFormState createState() => _AccessoriesSpecsFormState();
}

class _AccessoriesSpecsFormState extends SpecsFormState<AccessoriesSpecsForm> {
  TextEditingController brandController = TextEditingController();

  @override
  List<Widget> formFields(BuildContext context) {
    return [
      SpecTextField(
        labelText: 'Brand',
        hintText: 'Ex: Royal Queen Seeds',
      ),
    ];
  }

  @override
  Product createProduct() {
    return Product(
        name: nameController.text,
        specs: AccessoriesSpecs(brand: brandController.text));
  }
}
