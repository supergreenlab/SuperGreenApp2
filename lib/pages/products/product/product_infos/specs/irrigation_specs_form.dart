import 'package:flutter/material.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/widgets.dart';

class IrrigationSpecsForm extends StatefulWidget {
  @override
  _IrrigationSpecsFormState createState() => _IrrigationSpecsFormState();
}

class _IrrigationSpecsFormState extends SpecsFormState<IrrigationSpecsForm> {
  TextEditingController brandController = TextEditingController();

  @override
  List<Widget> formFields(BuildContext context) {
    return [
      SpecTextField(
        labelText: 'Brand',
        hintText: 'Ex: Floraflex',
      ),
    ];
  }
}
