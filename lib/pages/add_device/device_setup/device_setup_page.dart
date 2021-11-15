/*
 * Copyright (C) 2018  SuperGreenLab <towelie@supergreenlab.com>
 * Author: Constantin Clauzel <constantin.clauzel@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/device_setup/device_setup_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class DeviceSetupPage extends TraceableStatefulWidget {
  static String settingsDeviceSetupPagePasswordInstructions() {
    return Intl.message(
      'This controller is password protected, please enter the login/password below.',
      name: 'settingsDeviceSetupPagePasswordInstructions',
      desc: 'Password protection instructions',
      locale: SGLLocalizations.current!.localeName,
    );
  }

  @override
  _DeviceSetupPageState createState() => _DeviceSetupPageState();
}

class _DeviceSetupPageState extends State<DeviceSetupPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<DeviceSetupBloc>(context),
      listener: (BuildContext context, DeviceSetupBlocState state) async {
        if (state is DeviceSetupBlocStateDone) {
          Device device = state.device;
          if (state.requiresInititalSetup) {
            FutureFn ff1 = BlocProvider.of<MainNavigatorBloc>(context).futureFn();
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigateToDeviceNameEvent(device, futureFn: ff1.futureFn));
            device = await ff1.future;
          }

          FutureFn ff2 = BlocProvider.of<MainNavigatorBloc>(context).futureFn();
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigateToDevicePairingEvent(device, futureFn: ff2.futureFn));
          device = await ff2.future;

          if (state.requiresWifiSetup) {
            FutureFn ff2 = BlocProvider.of<MainNavigatorBloc>(context).futureFn();
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigateToDeviceWifiEvent(device, futureFn: ff2.futureFn));
            device = await ff2.future;
          }
          BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: device, mustPop: true));
        }
      },
      child: BlocBuilder<DeviceSetupBloc, DeviceSetupBlocState>(
          bloc: Provider.of<DeviceSetupBloc>(context),
          builder: (context, state) {
            bool canGoBack = state is DeviceSetupBlocStateAlreadyExists || state is DeviceSetupBlocStateLoadingError;
            Widget body;
            if (state is DeviceSetupBlocStateAlreadyExists) {
              body = _renderAlreadyAdded(context);
            } else if (state is DeviceSetupBlocStateLoadingError) {
              if (state.requiresAuth) {
                body = _renderAuthForm(context);
              } else {
                body = _renderLoadingError(context);
              }
            } else {
              body = _renderLoading(context, state);
            }
            return WillPopScope(
              onWillPop: () async => canGoBack,
              child: Scaffold(
                appBar: SGLAppBar(
                  'Add controller',
                  hideBackButton: !canGoBack,
                  backgroundColor: Color(0xff0b6ab3),
                  titleColor: Colors.white,
                  iconColor: Colors.white,
                ),
                body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body),
              ),
            );
          }),
    );
  }

  Widget _renderLoadingError(BuildContext context) {
    return Fullscreen(
        title: 'Oops looks like the controller is unreachable!',
        child: Icon(Icons.warning, color: Color(0xff3bb30b), size: 100));
  }

  Widget _renderAlreadyAdded(BuildContext context) {
    return Fullscreen(
        title: 'This controller is already added!', child: Icon(Icons.warning, color: Color(0xff3bb30b), size: 100));
  }

  Widget _renderAuthForm(BuildContext context) {
    return ListView(children: <Widget>[
      SectionTitle(
        title: 'Controller is password protected',
        icon: 'assets/settings/icon_lock.svg',
        backgroundColor: Color(0xff0b6ab3),
        titleColor: Colors.white,
        elevation: 5,
      ),
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: MarkdownBody(
                fitContent: true,
                data: DeviceSetupPage.settingsDeviceSetupPagePasswordInstructions(),
                styleSheet: MarkdownStyleSheet(p: TextStyle(color: Colors.black, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text('Username',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SGLTextField(
            hintText: 'Ex: stant',
            controller: _usernameController,
            textCapitalization: TextCapitalization.none,
            onChanged: (_) {
              setState(() {});
            }),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
        child: Text('Password',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SGLTextField(
            hintText: '***',
            controller: _passwordController,
            obscureText: true,
            onChanged: (_) {
              setState(() {});
            }),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GreenButton(
              onPressed: isValid()
                  ? () {
                      BlocProvider.of<DeviceSetupBloc>(context).add(DeviceSetupBlocEventStartSetup(
                        username: _usernameController.text,
                        password: _passwordController.text,
                      ));
                    }
                  : null,
              title: 'SET CREDENTIALS',
            ),
          ),
        ],
      ),
    ]);
  }

  Widget _renderLoading(BuildContext context, DeviceSetupBlocState state) {
    return Column(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: 50,
          color: Color(0xff0b6ab3),
        ),
        SectionTitle(
          title: 'Loading controller params',
          icon: 'assets/box_setup/icon_controller.svg',
          backgroundColor: Color(0xff0b6ab3),
          titleColor: Colors.white,
          large: true,
          elevation: 5,
        ),
        Expanded(child: FullscreenLoading(title: 'Loading please wait..', percent: state.percent)),
      ],
    );
  }

  bool isValid() {
    return _usernameController.text.length >= 4 && _passwordController.text.length >= 4;
  }
}
