import 'package:flutter/material.dart';
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
      ),
    ];
  }
}
