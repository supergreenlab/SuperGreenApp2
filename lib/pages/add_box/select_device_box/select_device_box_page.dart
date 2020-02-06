import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_box/select_device_box/select_device_box_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';

class SelectDeviceBoxPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SelectDeviceBoxPageState();
}

class SelectDeviceBoxPageState extends State<SelectDeviceBoxPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectDeviceBoxBloc, SelectDeviceBoxBlocState>(
        bloc: Provider.of<SelectDeviceBoxBloc>(context),
        builder: (context, state) => Scaffold(
            appBar: SGLAppBar('Device configuration'),
            body: Row(
              children: <Widget>[
                RaisedButton(
                  onPressed: () => _handleInput(context),
                  child: Text('CREATE BOX'),
                ),
              ],
            )));
  }

  void _handleInput(BuildContext context) {
    BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: 0));
  }
}
