import 'package:flutter/material.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/widgets.dart';

class OtherSpecsForm extends StatefulWidget {
  @override
  _OtherSpecsFormState createState() => _OtherSpecsFormState();
}

class _OtherSpecsFormState extends SpecsFormState<OtherSpecsForm> {
  TextEditingController brandController = TextEditingController();

  @override
  List<Widget> formFields(BuildContext context) {
    return [
      SpecTextField(
        labelText: 'Brand',
        hintText: 'Ex: ...',
      ),
    ];
  }
}
