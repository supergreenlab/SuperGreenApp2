import 'package:flutter/material.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/widgets.dart';

class LightingSpecsForm extends StatefulWidget {
  @override
  _LightingSpecsFormState createState() => _LightingSpecsFormState();
}

class _LightingSpecsFormState extends SpecsFormState<LightingSpecsForm> {
  TextEditingController brandController = TextEditingController();

  @override
  List<Widget> formFields(BuildContext context) {
    return [
      SpecTextField(
        labelText: 'Brand',
        hintText: 'Ex: Vivosun',
      ),
    ];
  }
}
