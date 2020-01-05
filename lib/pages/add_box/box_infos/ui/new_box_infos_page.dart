import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_box/box_infos/bloc/new_box_infos_bloc.dart';

class NewBoxInfosPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewBoxInfosPageState();
}

class NewBoxInfosPageState extends State<NewBoxInfosPage> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: Provider.of<NewBoxInfosBloc>(context),
      listener: (BuildContext context, NewBoxInfosBlocState state) {
        if (state is NewBoxInfosBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigateToSelectBoxDeviceEvent(state.box));
        }
      },
      child: BlocBuilder<NewBoxInfosBloc, NewBoxInfosBlocState>(
          bloc: Provider.of<NewBoxInfosBloc>(context),
          builder: (context, state) => Scaffold(
              appBar: AppBar(title: Text('New Box infos')),
              body: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    controller: _nameController,
                  )),
                  RaisedButton(
                    onPressed: () => _handleInput(context),
                    child: Text('CREATE BOX'),
                  ),
                ],
              ))),
    );
  }

  void _handleInput(BuildContext context) {
    Provider.of<NewBoxInfosBloc>(context)
        .add(NewBoxInfosBlocEventCreateBox(_nameController.text));
  }
}
