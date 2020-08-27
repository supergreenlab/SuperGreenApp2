import 'package:flutter/material.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/widgets.dart';

class PHECSpecsForm extends StatefulWidget {
  @override
  _PHECSpecsFormState createState() => _PHECSpecsFormState();
}

class _PHECSpecsFormState extends SpecsFormState<PHECSpecsForm> {
  TextEditingController brandController = TextEditingController();

  @override
  List<Widget> formFields(BuildContext context) {
    return [
      SpecTextField(
        labelText: 'Brand',
        hintText: 'Ex: GHB',
      ),
    ];
  }
}
