import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/explorer/explorer_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';

class ExplorerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExplorerBloc, ExplorerBlocState>(
          bloc: BlocProvider.of<ExplorerBloc>(context),
          builder: (context, state) => Scaffold(
              appBar: SGLAppBar('Explorer'),
              body: Text('pouet')));
  }
}
