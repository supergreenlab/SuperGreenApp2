import 'package:flutter/material.dart';
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
        hintText: 'Ex: AD Infinity',
      ),
    ];
  }
}
