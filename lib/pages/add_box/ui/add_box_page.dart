import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/add_box/bloc/add_box_bloc.dart';

class NewBoxPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewBoxBloc, NewBoxBlocState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: Text('Add box')),
        body: Text('Add Box'),
        ),
      );
  }

}