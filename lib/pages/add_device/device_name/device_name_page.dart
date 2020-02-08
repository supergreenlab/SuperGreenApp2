import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/device_name/device_name_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class DeviceNamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DeviceNamePageState();
}

class DeviceNamePageState extends State<DeviceNamePage> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener(
        bloc: Provider.of<DeviceNameBloc>(context),
        listener: (BuildContext context, DeviceNameBlocState state) {
          if (state is DeviceNameBlocStateDone) {
            BlocProvider.of<MainNavigatorBloc>(context).add(
                MainNavigateToDeviceDoneEvent(state.device,
                    futureFn: (future) async {
              Device device = await future;
              if (device != null) {
                BlocProvider.of<MainNavigatorBloc>(context)
                    .add(MainNavigatorActionPop(param: device, mustPop: true));
              }
            }));
          }
        },
        child: BlocBuilder<DeviceNameBloc, DeviceNameBlocState>(
            bloc: Provider.of<DeviceNameBloc>(context),
            builder: (context, state) => Scaffold(
                appBar: SGLAppBar(
                  'Add device',
                  hideBackButton: true,
                ),
                body: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SectionTitle(
                          title: 'Set device\'s name',
                          icon: 'assets/box_setup/icon_controller.svg'),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SGLTextField(
                              hintText: 'ex: Bob',
                              controller: _nameController,
                              onChanged: (_) {
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GreenButton(
                          onPressed: () => _handleInput(context),
                          title: 'OK',
                        ),
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }

  void _handleInput(BuildContext context) {
    Provider.of<DeviceNameBloc>(context)
        .add(DeviceNameBlocEventSetName(
      _nameController.text,
    ));
  }

    @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
