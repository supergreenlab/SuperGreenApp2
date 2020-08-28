import 'package:flutter/material.dart';
import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/data/api/backend/products/specs/ventilation_specs.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/widgets.dart';

class VentilationSpecsForm extends StatefulWidget {
  @override
  _VentilationSpecsFormState createState() => _VentilationSpecsFormState();
}

class _VentilationSpecsFormState extends SpecsFormState<VentilationSpecsForm> {
  TextEditingController brandController = TextEditingController();

  @override
  List<Widget> formFields(BuildContext context) {
    return [
      SpecTextField(
        labelText: 'Brand',
        hintText: 'Ex: AC Infinity',
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
        specs: VentilationSpecs(brand: brandController.text));
  }

  @override
  bool isValid() {
    return nameController.text != '' && brandController.text != '';
  }

  String get hintText => 'Ex: Cloudline T4';
}
