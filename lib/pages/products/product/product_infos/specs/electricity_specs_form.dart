import 'package:flutter/material.dart';
import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/data/api/backend/products/specs/electricity_specs.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/widgets.dart';

class ElectricitySpecsForm extends StatefulWidget {
  @override
  _ElectricitySpecsFormState createState() => _ElectricitySpecsFormState();
}

class _ElectricitySpecsFormState extends SpecsFormState<ElectricitySpecsForm> {
  TextEditingController brandController = TextEditingController();

  @override
  List<Widget> formFields(BuildContext context) {
    return [
      SpecTextField(
        labelText: 'Brand',
        hintText: 'Ex: ...',
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
        specs: ElectricitySpecs(brand: brandController.text));
  }

  @override
  bool isValid() {
    return nameController.text != '' && brandController.text != '';
  }

  String get hintText => 'Ex: timer';
}
