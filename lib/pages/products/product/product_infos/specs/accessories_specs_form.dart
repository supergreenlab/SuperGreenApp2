import 'package:flutter/material.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/widgets.dart';

class AccessoriesSpecsForm extends StatefulWidget {
  @override
  _AccessoriesSpecsFormState createState() => _AccessoriesSpecsFormState();
}

class _AccessoriesSpecsFormState extends SpecsFormState<AccessoriesSpecsForm> {
  TextEditingController brandController = TextEditingController();

  @override
  List<Widget> formFields(BuildContext context) {
    return [
      SpecTextField(
        labelText: 'Brand',
        hintText: 'Ex: Royal Queen Seeds',
      ),
    ];
  }
}
