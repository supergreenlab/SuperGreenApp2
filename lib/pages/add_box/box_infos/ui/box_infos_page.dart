import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_box/box_infos/bloc/box_infos_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';

class BoxInfosPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BoxInfosPageState();
}

class BoxInfosPageState extends State<BoxInfosPage> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: Provider.of<BoxInfosBloc>(context),
      listener: (BuildContext context, BoxInfosBlocState state) {
        if (state is BoxInfosBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigateToSelectBoxDeviceEvent(state.box));
        }
      },
      child: BlocBuilder<BoxInfosBloc, BoxInfosBlocState>(
          bloc: Provider.of<BoxInfosBloc>(context),
          builder: (context, state) => Scaffold(
              appBar: SGLAppBar('New Box infos'),
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
    Provider.of<BoxInfosBloc>(context, listen: false)
        .add(BoxInfosBlocEventCreateBox(_nameController.text));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
