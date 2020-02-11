import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/new_device/new_device_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';

class NewDevicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<NewDeviceBloc>(context),
      listener: (BuildContext context, NewDeviceBlocState state) {
        if (state is NewDeviceBlocStateConnectionToSSIDSuccess) {
          BlocProvider.of<MainNavigatorBloc>(context).add(
              MainNavigateToDeviceSetupEvent('192.168.4.1',
                  futureFn: (future) async {
            Device device = await future;
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop(param: device));
          }));
        }
      },
      child: BlocBuilder<NewDeviceBloc, NewDeviceBlocState>(
          bloc: BlocProvider.of<NewDeviceBloc>(context),
          builder: (context, state) {
            Widget body;
            if (state is NewDeviceBlocStateConnectingToSSID) {
              body = _renderLoading();
            } else if (state is NewDeviceBlocStateConnectionToSSIDFailed) {
              body = _renderFailed(context);
            } else {
              body = _renderLoading();
            }
            return Scaffold(
              appBar: SGLAppBar('Add device'),
              body: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SectionTitle(
                        title: 'Connecting to controller\'s wifi',
                        icon: 'assets/box_setup/icon_search.svg'),
                    body,
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _renderFailed(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                'Couldn\'t connect to the 🤖🍁 wifi! Please go to your mobile phone settings to connect manually with the following credentials:'),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'SSID: 🤖🍁\nPassword: multipass',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Then press the DONE button below'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: GreenButton(
                title: 'DONE',
                onPressed: () {
                  BlocProvider.of<MainNavigatorBloc>(context)
                      .add(MainNavigateToDeviceSetupEvent('192.168.4.1'));
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _renderLoading() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              value: null,
              strokeWidth: 4.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Trying to connect\nautomatically',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
