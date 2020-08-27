import 'package:flutter/material.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/widgets.dart';

class CompleteKitSpecsForm extends StatefulWidget {
  @override
  _CompleteKitSpecsFormState createState() => _CompleteKitSpecsFormState();
}

class _CompleteKitSpecsFormState extends SpecsFormState<CompleteKitSpecsForm> {
  TextEditingController brandController = TextEditingController();

  @override
  List<Widget> formFields(BuildContext context) {
    return [
      SpecTextField(
        labelText: 'Brand',
        hintText: 'Ex: SuperGreenLab',
      ),
    ];
  }
}
