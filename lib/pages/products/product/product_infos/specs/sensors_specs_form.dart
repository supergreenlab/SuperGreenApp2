import 'package:flutter/material.dart';
import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/data/api/backend/products/specs/sensors_specs.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/widgets.dart';

class SensorsSpecsForm extends StatefulWidget {
  @override
  _SensorsSpecsFormState createState() => _SensorsSpecsFormState();
}

class _SensorsSpecsFormState extends SpecsFormState<SensorsSpecsForm> {
  TextEditingController brandController = TextEditingController();

  @override
  List<Widget> formFields(BuildContext context) {
    return [
      SpecTextField(
        labelText: 'Brand',
        hintText: 'Ex: Blue labs',
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
        specs: SensorsSpecs(brand: brandController.text));
  }

  @override
  bool isValid() {
    return nameController.text != '' && brandController.text != '';
  }

  String get hintText => 'Ex: PH sensor';
}
