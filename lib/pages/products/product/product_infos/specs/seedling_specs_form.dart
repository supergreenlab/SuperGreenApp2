import 'package:flutter/material.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/widgets.dart';

class SeedlingSpecsForm extends StatefulWidget {
  @override
  _SeedlingSpecsFormState createState() => _SeedlingSpecsFormState();
}

class _SeedlingSpecsFormState extends SpecsFormState<SeedlingSpecsForm> {
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
