import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_box/select_device_box/select_device_box_bloc.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';

class SelectDeviceBoxPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SelectDeviceBoxPageState();
}

class SelectDeviceBoxPageState extends State<SelectDeviceBoxPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: Provider.of<SelectDeviceBoxBloc>(context),
      listener: (BuildContext context, SelectDeviceBoxBlocState state) {
        if (state is SelectDeviceBoxBlocStateDone) {
          HomeNavigatorBloc.eventBus.fire(HomeNavigateToBoxFeedEvent(state.box));
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop());
        }
      },
      child: BlocBuilder<SelectDeviceBoxBloc, SelectDeviceBoxBlocState>(
          bloc: Provider.of<SelectDeviceBoxBloc>(context),
          builder: (context, state) => Scaffold(
              appBar: SGLAppBar('New Box device box'),
              body: Row(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () => _handleInput(context),
                    child: Text('CREATE BOX'),
                  ),
                ],
              ))),
    );
  }

  void _handleInput(BuildContext context) {
    Provider.of<SelectDeviceBoxBloc>(context, listen: false)
        .add(SelectDeviceBoxBlocEventSetDeviceBox(0));
  }
}
