import 'package:flutter/material.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/widgets.dart';

class SubstratSpecsForm extends StatefulWidget {
  @override
  _SubstratSpecsFormState createState() => _SubstratSpecsFormState();
}

class _SubstratSpecsFormState extends SpecsFormState<SubstratSpecsForm> {
  TextEditingController brandController = TextEditingController();

  @override
  List<Widget> formFields(BuildContext context) {
    return [
      SpecTextField(
        labelText: 'Brand',
        hintText: 'Ex: Monkey Soil',
      ),
    ];
  }
}
