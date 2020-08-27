import 'package:flutter/material.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/specs_form.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs/widgets.dart';

class SeedsSpecsForm extends StatefulWidget {
  @override
  _SeedsSpecsFormState createState() => _SeedsSpecsFormState();
}

class _SeedsSpecsFormState extends SpecsFormState<SeedsSpecsForm> {
  TextEditingController bankController = TextEditingController();

  @override
  List<Widget> formFields(BuildContext context) {
    return [
      SpecTextField(
        labelText: 'Seedbank',
        hintText: 'Ex: Paradise Seeds',
      ),
    ];
  }
}
