/*
 * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/misc/screen_lock.dart';
import 'package:super_green_app/pages/settings/settings_bloc.dart';
import 'package:super_green_app/theme.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:package_info/package_info.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String version = '';
  String buildNumber = '';

  @override
  void initState() {
    super.initState();
    initPackageInfo();
  }

  Future<void> initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
      Logger.log('APP VERSION: $version ($buildNumber)');
    });
  }

  void _createPinLock({bool isEdited = false }) {
    screenLockCreate(
      context: context,
      config: screenLockConfig,
      keyPadConfig: screenLockKeyPadConfig,
      cancelButton: const Icon(Icons.close, size: 36),
      title: isEdited
        ? const Text('Let\'s create a new PIN code')
        : const Text('Please enter PIN'),
      confirmTitle: Text('Great! Now confirm it'),
      onConfirmed: (value) {
        BlocProvider.of<SettingsBloc>(context).add(SettingsBlocEventSetPinLock(value));
        Navigator.of(context).pop();

        showSnackBar(context, isEdited
          ? 'All done! You can now use your new PIN code'
          : 'All done! The app is now protected with your PIN code'
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsBlocState>(
        bloc: BlocProvider.of<SettingsBloc>(context),
        builder: (context, state) => Scaffold(
            appBar: SGLAppBar(
              'Settings',
              backgroundColor: Colors.deepOrange,
              titleColor: Colors.white,
              iconColor: Colors.white,
              elevation: 10,
              hideBackButton: true,
            ),
            body: ListView(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    BlocProvider.of<SettingsBloc>(context).add(SettingsBlocEventSetFreedomUnit(!state.freedomUnits));
                  },
                  leading: SizedBox(
                      width: 40,
                      height: 40,
                      child: SvgPicture.asset(state.freedomUnits
                          ? 'assets/settings/icon_imperial.svg'
                          : 'assets/settings/icon_metric.svg')),
                  title: Text(state.freedomUnits ? 'Imperial unit system' : 'Metric unit system',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Tap to change to ${state.freedomUnits ? 'metric' : 'imperial'}'),
                ),
                ListTile(
                  onTap: () {
                    BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSettingsAuth());
                  },
                  leading: SizedBox(width: 40, height: 40, child: SvgPicture.asset('assets/settings/icon_account.svg')),
                  title: Text('SGL Account', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Enable backups, remote control, sharing, etc..'),
                ),
                ListTile(
                  onTap: () {
                    if (state.pinLock.isEmpty) {
                      _createPinLock(isEdited: false);
                      return;
                    }

                    screenLock(
                      context: context,
                      config: screenLockConfig,
                      keyPadConfig: screenLockKeyPadConfig,
                      cancelButton: const Icon(Icons.close, size: 36),
                      title: const Text('Please enter PIN'),
                      correctString: state.pinLock,
                      onUnlocked: () {
                        Navigator.of(context).pop();

                        final blocProvider = BlocProvider.of<SettingsBloc>(context);

                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: false,
                          useSafeArea: true,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: kPadding16,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SglFilledGreenButton(
                                    title: 'Change PIN code',
                                    expanded: true,
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _createPinLock(isEdited: true);
                                    },
                                  ),
                                  context.vBox16,
                                  SglOutlinedRedButton(
                                    title: 'Remove PIN lock',
                                    expanded: true,
                                    onPressed: () {
                                      Navigator.pop(context);
                                      blocProvider.add(SettingsBlocEventSetPinLock(''));

                                      showSnackBar(context, 'All done! PIN lock removed');
                                    },
                                  )
                                ],
                              ),
                            );
                          }
                        );
                      },
                    );
                  },
                  leading: SizedBox(width: 40, height: 40, child: SvgPicture.asset('assets/settings/icon_lock.svg')),
                  title: Text('PIN lock', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Set up or change PIN lock'),
                ),
                ListTile(
                  onTap: () {
                    BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSettingsPlants());
                  },
                  leading: SizedBox(width: 40, height: 40, child: SvgPicture.asset('assets/settings/icon_plants.svg')),
                  title: Text('Plants', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Move to new box & delete plants.'),
                ),
                ListTile(
                  onTap: () {
                    BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSettingsBoxes());
                  },
                  leading: SizedBox(width: 40, height: 40, child: SvgPicture.asset('assets/settings/icon_lab.svg')),
                  title: Text('Labs', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Change controller & delete labs.'),
                ),
                ListTile(
                  onTap: () {
                    BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSettingsDevices());
                  },
                  leading:
                      SizedBox(width: 40, height: 40, child: SvgPicture.asset('assets/settings/icon_controller.svg')),
                  title: Text('Controllers', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Edit & delete controllers.'),
                ),
                ListTile(
                  onTap: () async {
                    final Email email = Email(
                      subject: 'App feedback',
                      body: 'Hey guys,\n\nHere\' some feedback:\n\n\nCheers,\n',
                      recipients: ['towelie@supergreenlab.com'],
                      isHTML: false,
                    );
                    await FlutterEmailSender.send(email);
                  },
                  leading:
                      SizedBox(width: 40, height: 40, child: SvgPicture.asset('assets/settings/icon_feedback.svg')),
                  title: Text('Send us some feedback!', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Tap to send over email'),
                ),
                ListTile(
                  onTap: () async {
                    File logFile = File(await Logger.logFilePath());
                    final Directory tmpDir = await getTemporaryDirectory();
                    String tmpLogFile = '${tmpDir.path}/log.txt';
                    await logFile.copy(tmpLogFile);
                    final Email email = Email(
                      subject: 'Log file',
                      body: 'Hey stant,\n\nhere\'s my log file\n\ncheers.',
                      recipients: ['stant@supergreenlab.com'],
                      attachmentPaths: [tmpLogFile],
                      isHTML: false,
                    );
                    await FlutterEmailSender.send(email);
                  },
                  leading: SizedBox(width: 40, height: 40, child: Image.asset('assets/settings/avatar.jpg')),
                  title: Text('Send my logs to stant', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Tap to send over email'),
                ),
                ListTile(
                  title: Text('App version'),
                  subtitle: Text('$version ($buildNumber)'),
                ),
              ],
            )));
  }
}
