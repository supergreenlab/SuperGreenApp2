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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/device_daemon/device_daemon_bloc.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/pages/settings/devices/auth_modal/auth_modal_bloc.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/textfield.dart';

class AuthModalPage extends TraceableStatefulWidget {
  static String get authModalButton {
    return Intl.message(
      'NOTIFY ME',
      name: 'authModalButton',
      desc: 'Notification request button',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String authModalTitle(String name) {
    return Intl.message(
      'Controller $name requires authentication!',
      args: [name],
      name: 'authModalTitle',
      desc: 'Device auth modal form title',
      locale: SGLLocalizations.current.localeName,
    );
  }

  @override
  _AuthModalPageState createState() => _AuthModalPageState();
}

class _AuthModalPageState extends State<AuthModalPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthModalBloc, AuthModalBlocState>(
      listener: (BuildContext context, AuthModalBlocState state) {
        if (state is AuthModalBlocStateDone) {
          BlocProvider.of<DeviceDaemonBloc>(context).add(DeviceDaemonBlocEventLoggedIn(state.device));
        }
      },
      child: BlocBuilder<AuthModalBloc, AuthModalBlocState>(
        builder: (BuildContext context, AuthModalBlocState state) {
          if (state is AuthModalBlocStateInit) {
            return Container(height: 345, child: FullscreenLoading());
          } else if (state is AuthModalBlocStateDone) {
            return Container(
              height: 345,
              child: Fullscreen(
                title: 'Done',
                child: Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 100,
                ),
              ),
            );
          }
          return renderForm(context, state);
        },
      ),
    );
  }

  Widget renderForm(BuildContext context, AuthModalBlocStateLoaded state) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: 345,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 4.0,
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: SvgPicture.asset(
                          'assets/settings/icon_password.svg',
                          width: 40,
                          height: 40,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          AuthModalPage.authModalTitle(state.device.name),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                                BlocProvider.of<AuthModalBloc>(context).add(AuthModalBlocEventAuth(
                                    username: _usernameController.text, password: _passwordController.text));
                              }
                            : null,
                        title: 'LOGIN',
                      ),
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }

  bool isValid() {
    return _usernameController.text.length >= 4 && _passwordController.text.length >= 4;
  }
}
