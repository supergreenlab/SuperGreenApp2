import 'package:flutter/material.dart';
import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/data/api/backend/products/specs/seed_specs.dart';
import 'package:super_green_app/pages/products/product/product_infos/specs_form.dart';
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
        controller: bankController,
        onChanged: (_) {
          setState(() {});
        },
      ),
    ];
  }

  @override
  Product createProduct() {
    return Product(
        name: nameController.text, specs: SeedSpecs(bank: bankController.text));
  }

  @override
  bool isValid() {
    return nameController.text != '' && bankController.text != '';
  }

  String get hintText => 'Ex: El Dorado OG';
}
