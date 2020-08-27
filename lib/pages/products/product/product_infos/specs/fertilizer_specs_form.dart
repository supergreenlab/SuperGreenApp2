import 'package:flutter/material.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/widgets.dart';

class FertilizerSpecsForm extends StatefulWidget {
  @override
  _FertilizerSpecsFormState createState() => _FertilizerSpecsFormState();
}

class _FertilizerSpecsFormState extends SpecsFormState<FertilizerSpecsForm> {
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
