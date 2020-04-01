import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/settings/devices/settings_devices_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class SettingsDevicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsDevicesBloc, SettingsDevicesBlocState>(
      listener: (BuildContext context, SettingsDevicesBlocState state) {},
      child: BlocBuilder<SettingsDevicesBloc, SettingsDevicesBlocState>(
        bloc: BlocProvider.of<SettingsDevicesBloc>(context),
        builder: (BuildContext context, SettingsDevicesBlocState state) {
          Widget body;

          if (state is SettingsDevicesBlocStateLoading) {
            body = FullscreenLoading(
              title: 'Loading..',
            );
          } else if (state is SettingsDevicesBlocStateNotEmptyBox) {
            body = Fullscreen(
              child: Icon(Icons.do_not_disturb, color: Colors.red, size: 100),
              title: 'Cannot delete box',
              subtitle: 'Move all plants to another box first.',
            );
          } else if (state is SettingsDevicesBlocStateLoaded) {
            body = ListView.builder(
              itemCount: state.devices.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: SizedBox(
                      width: 40,
                      height: 40,
                      child: SvgPicture.asset('assets/settings/icon_controller.svg')),
                  onLongPress: () {
                    _deleteBox(context, state.devices[index]);
                  },
                  title: Text('${index + 1}. ${state.devices[index].name}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Long tap to delete.'),
                );
              },
            );
          }
          return Scaffold(
              appBar: SGLAppBar(
                'Devices settings',
                backgroundColor: Colors.deepOrange,
                titleColor: Colors.white,
                iconColor: Colors.white,
                hideBackButton: !(state is SettingsDevicesBlocStateLoaded),
              ),
              body: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200), child: body));
        },
      ),
    );
  }

  void _deleteBox(BuildContext context, Device device) async {
    bool confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete box ${device.name}?'),
            content: Text('This can\'t be reverted. Continue?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('NO'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('YES'),
              ),
            ],
          );
        });
    if (confirm) {
      BlocProvider.of<SettingsDevicesBloc>(context)
          .add(SettingsDevicesBlocEventDeleteBox(device));
    }
  }
}
