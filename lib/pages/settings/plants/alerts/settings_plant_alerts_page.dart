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

import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/settings/plants/alerts/settings_plant_alerts_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';

class SettingsPlantAlertsPage extends TraceableStatelessWidget {
  static String get settingsPlantAlertPageTitle {
    return Intl.message(
      'Add controller',
      name: 'settingsPlantAlertPageTitle',
      desc: 'Device alerts page title',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get settingsPlantAlertPageLoading {
    return Intl.message(
      'Updating parameters..',
      name: 'settingsPlantAlertPageLoading',
      desc: 'Loading text when setting alert parameters',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get settingsPlantAlertPageSectionTitle {
    return Intl.message(
      'Metric monitoring',
      name: 'settingsPlantAlertPagePairControllerSectionTitle',
      desc: 'Section title for the alert parameters setup',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get settingsPlantAlertPageInstructions {
    return Intl.message(
      'No need to constantly check the plant monitoring, just setup some alerts, and the app will tell you when something\s wrong.',
      name: 'settingsPlantAlertPageInstructions',
      desc: 'Explanation for alerts',
      locale: SGLLocalizations.current.localeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: BlocProvider.of<SettingsPlantAlertsBloc>(context),
      listener: (BuildContext context, SettingsPlantAlertsBlocState state) async {
        if (state is SettingsPlantAlertsBlocStateDone) {
          await Future.delayed(Duration(seconds: 2));
          BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(mustPop: true));
        }
      },
      child: BlocBuilder<SettingsPlantAlertsBloc, SettingsPlantAlertsBlocState>(
          cubit: BlocProvider.of<SettingsPlantAlertsBloc>(context),
          builder: (context, state) {
            Widget body;
            if (state is SettingsPlantAlertsBlocStateLoading) {
              body = _renderLoading();
            } else if (state is SettingsPlantAlertsBlocStateDone) {
              body = Fullscreen(
                title: CommonL10N.done,
                child: Icon(
                  Icons.check,
                  color: Color(0xff3bb30b),
                  size: 100,
                ),
              );
            } else {
              body = _renderForm(context, state);
            }
            return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                  appBar: SGLAppBar(
                    SettingsPlantAlertsPage.settingsPlantAlertPageTitle,
                    hideBackButton: true,
                    backgroundColor: Color(0xff0b6ab3),
                    titleColor: Colors.white,
                    iconColor: Colors.white,
                  ),
                  body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body)),
            );
          }),
    );
  }

  Widget _renderLoading() {
    return FullscreenLoading(title: SettingsPlantAlertsPage.settingsPlantAlertPageLoading);
  }

  Widget _renderForm(BuildContext context, SettingsPlantAlertsBlocState state) {
    return Column(
      children: <Widget>[
        Container(
          height: 100,
          color: Color(0xff0b6ab3),
        ),
        SectionTitle(
          title: SettingsPlantAlertsPage.settingsPlantAlertPageSectionTitle,
          icon: 'assets/settings/icon_remotecontrol.svg',
          backgroundColor: Color(0xff0b6ab3),
          titleColor: Colors.white,
          large: true,
          elevation: 5,
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MarkdownBody(
                    fitContent: true,
                    data: SettingsPlantAlertsPage.settingsPlantAlertPageInstructions,
                    styleSheet: MarkdownStyleSheet(p: TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GreenButton(
                onPressed: () {
                  BlocProvider.of<SettingsPlantAlertsBloc>(context).add(SettingsPlantAlertsBlocEventUpdateParameters());
                },
                title: 'PAIR CONTROLLER',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
