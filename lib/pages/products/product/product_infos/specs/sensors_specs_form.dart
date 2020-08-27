import 'package:flutter/material.dart';
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
      ),
    ];
  }
}
