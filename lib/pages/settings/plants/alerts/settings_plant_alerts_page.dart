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
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/data/api/backend/services/models/alerts.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/notifications/notifications.dart';
import 'package:super_green_app/pages/settings/plants/alerts/settings_plant_alerts_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_button.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';

class SettingsPlantAlertsPage extends TraceableStatefulWidget {
  static String get settingsPlantAlertPageTitle {
    return Intl.message(
      'Alerts',
      name: 'settingsPlantAlertPageTitle',
      desc: 'Device alerts page title',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get settingsPlantAlertPageLoading {
    return Intl.message(
      'Loading',
      name: 'settingsPlantAlertPageLoading',
      desc: 'Loading text when setting alert parameters',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get settingsPlantAlertPageSectionTitle {
    return Intl.message(
      'Alert settings',
      name: 'settingsPlantAlertPageSectionTitle',
      desc: 'Section title for the alert parameters setup',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get settingsPlantAlertPageInstructions {
    return Intl.message(
      '**No need to constantly check the plant monitoring!** Just setup your alerts, and the app will tell you when something\'s wrong.',
      name: 'settingsPlantAlertPageInstructions',
      desc: 'Explanation for alerts',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get settingsDayAlertPageInstructions {
    return Intl.message(
      'Day alert settings are used while the lights are on.',
      name: 'settingsDayAlertPageInstructions',
      desc: 'Explanation for day alerts',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get settingsNightAlertPageInstructions {
    return Intl.message(
      'Night alert settings are used while the lights are off.',
      name: 'settingsNightAlertPageInstructions',
      desc: 'Explanation for night alerts',
      locale: SGLLocalizations.current.localeName,
    );
  }

  @override
  _SettingsPlantAlertsPageState createState() => _SettingsPlantAlertsPageState();
}

class _SettingsPlantAlertsPageState extends State<SettingsPlantAlertsPage> {
  AlertsSettings alertsSettings;
  bool enabled;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: BlocProvider.of<SettingsPlantAlertsBloc>(context),
      listener: (BuildContext context, SettingsPlantAlertsBlocState state) async {
        if (state is SettingsPlantAlertsBlocStateLoaded) {
          setState(() {
            this.enabled = state.enabled;
            this.alertsSettings = state.alertsSettings;
          });
        } else if (state is SettingsPlantAlertsBlocStateDone) {
          await Future.delayed(Duration(seconds: 2));
          BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(mustPop: true));
        }
      },
      child: BlocBuilder<SettingsPlantAlertsBloc, SettingsPlantAlertsBlocState>(
          cubit: BlocProvider.of<SettingsPlantAlertsBloc>(context),
          builder: (context, state) {
            Widget body;
            if (state is SettingsPlantAlertsBlocStateNotLoaded) {
              body = _renderNotLoaded(context, state);
            } else if (state is SettingsPlantAlertsBlocStateLoading) {
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
            } else if (state is SettingsPlantAlertsBlocStateLoaded) {
              body = _renderForm(context, state);
            } else {
              body = _renderLoading();
            }
            return WillPopScope(
              onWillPop: () async {
                return await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Unsaved changed'),
                        content: Text('Changes will not be saved. Continue?'),
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
              },
              child: Scaffold(
                  appBar: SGLAppBar(
                    SettingsPlantAlertsPage.settingsPlantAlertPageTitle,
                    backgroundColor: Color(0xff0bb354),
                    titleColor: Colors.white,
                    iconColor: Colors.white,
                    hideBackButton: state is SettingsPlantAlertsBlocStateDone,
                  ),
                  body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body)),
            );
          }),
    );
  }

  Widget _renderLoading() {
    return FullscreenLoading(title: SettingsPlantAlertsPage.settingsPlantAlertPageLoading);
  }

  Widget _renderForm(BuildContext context, SettingsPlantAlertsBlocStateLoaded state) {
    String unit = AppDB().getAppData().freedomUnits == true ? '°F' : '°C';
    List<Widget> items = [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: MarkdownBody(
          fitContent: true,
          data: SettingsPlantAlertsPage.settingsPlantAlertPageInstructions,
          styleSheet: MarkdownStyleSheet(p: TextStyle(color: Colors.black, fontSize: 16)),
        ),
      ),
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: _renderOptionCheckbx(context, 'Enable notifications', (bool newValue) {
            setState(() {
              if (enabled == false && newValue == true) {
                BlocProvider.of<NotificationsBloc>(context).add(NotificationsBlocEventRequestPermission());
              }
              enabled = newValue;
            });
          }, enabled)),
    ];

    if (enabled) {
      items.addAll([
        SectionTitle(
          title: 'Day alert settings',
          icon: 'assets/settings/icon_day_alerts.svg',
          backgroundColor: Color(0xffd8d23f),
          titleColor: Colors.white,
          large: true,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: MarkdownBody(
            fitContent: true,
            data: SettingsPlantAlertsPage.settingsDayAlertPageInstructions,
            styleSheet: MarkdownStyleSheet(p: TextStyle(color: Colors.black, fontSize: 16)),
          ),
        ),
        renderParameters(
          context,
          title: 'Day temperature alerts',
          icon: 'assets/settings/icon_day_temperature.svg',
          color: Colors.white,
          min: alertsSettings.minTempDay,
          max: alertsSettings.maxTempDay,
          onChange: (int min, int max) {
            alertsSettings = alertsSettings.copyWith(
              minTempDay: min,
              maxTempDay: max,
            );
          },
          displayFn: (int value) => '${_tempUnit(value.toDouble())}',
          unit: unit,
          step: 1,
        ),
        renderParameters(
          context,
          title: 'Day humi alerts',
          icon: 'assets/settings/icon_day_humidity.svg',
          color: Colors.white,
          min: alertsSettings.minHumiDay,
          max: alertsSettings.maxHumiDay,
          onChange: (int min, int max) {
            alertsSettings = alertsSettings.copyWith(
              minHumiDay: min,
              maxHumiDay: max,
            );
          },
          displayFn: (int value) => '$value',
          unit: '%',
          step: 1,
        ),
        SectionTitle(
          title: 'Night alert settings',
          icon: 'assets/settings/icon_night_alerts.svg',
          titleColor: Colors.white,
          backgroundColor: Color(0xff36649a),
          large: true,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: MarkdownBody(
            fitContent: true,
            data: SettingsPlantAlertsPage.settingsNightAlertPageInstructions,
            styleSheet: MarkdownStyleSheet(p: TextStyle(color: Colors.black, fontSize: 16)),
          ),
        ),
        renderParameters(
          context,
          title: 'Night temperature alerts',
          icon: 'assets/settings/icon_night_temperature.svg',
          color: Colors.white,
          min: alertsSettings.minTempNight,
          max: alertsSettings.maxTempNight,
          onChange: (int min, int max) {
            alertsSettings = alertsSettings.copyWith(
              minTempNight: min,
              maxTempNight: max,
            );
          },
          displayFn: (int value) => '${_tempUnit(value.toDouble())}',
          unit: unit,
          step: 1,
        ),
        renderParameters(
          context,
          title: 'Night humi alerts',
          icon: 'assets/settings/icon_night_humidity.svg',
          color: Colors.white,
          min: alertsSettings.minHumiNight,
          max: alertsSettings.maxHumiNight,
          onChange: (int min, int max) {
            alertsSettings = alertsSettings.copyWith(
              minHumiNight: min,
              maxHumiNight: max,
            );
          },
          displayFn: (int value) => '$value',
          unit: '%',
          step: 1,
        ),
      ]);
    }
    return Column(
      children: <Widget>[
        SectionTitle(
          title: SettingsPlantAlertsPage.settingsPlantAlertPageSectionTitle,
          icon: 'assets/settings/icon_alerts.svg',
          backgroundColor: Color(0xff0bb354),
          titleColor: Colors.white,
          large: true,
          elevation: 5,
        ),
        Expanded(
          child: ListView(children: items),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GreenButton(
                onPressed: () {
                  BlocProvider.of<SettingsPlantAlertsBloc>(context)
                      .add(SettingsPlantAlertsBlocEventUpdateParameters(enabled, alertsSettings));
                },
                title: 'SAVE',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget renderParameters(BuildContext context,
      {String icon,
      String title,
      Color color,
      int min,
      int max,
      void onChange(int min, int max),
      String displayFn(int value),
      String unit,
      int step}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionTitle(
            title: title,
            icon: icon,
            backgroundColor: color,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Minimum', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          renderNumberParam(
            value: min,
            onChange: (int value) {
              setState(() {
                onChange(value, max);
              });
            },
            displayFn: displayFn,
            unit: unit,
            step: step,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Maximum', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          renderNumberParam(
            value: max,
            onChange: (int value) {
              setState(() {
                onChange(min, value);
              });
            },
            displayFn: displayFn,
            unit: unit,
            step: step,
          ),
        ],
      ),
    );
  }

  Widget renderNumberParam({int value, void onChange(int value), String displayFn(int value), String unit, int step}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ButtonTheme(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), //adds padding inside the button
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, //limits the touch area to the button area
              height: 36,
              minWidth: 60, //wraps child's width
              child: FeedFormButton(
                title: '-',
                onPressed: () {
                  onChange(value - step);
                },
                textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${displayFn(value)}$unit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          ButtonTheme(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), //adds padding inside the button
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, //limits the touch area to the button area
              height: 36,
              minWidth: 60, //wraps child's width
              child: FeedFormButton(
                title: '+',
                onPressed: () {
                  onChange(value + step);
                },
                textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
        ],
      ),
    );
  }

  Widget _renderOptionCheckbx(BuildContext context, String text, Function(bool) onChanged, bool value) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
            onChanged: onChanged,
            value: value,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                onChanged(!value);
              },
              child: MarkdownBody(
                fitContent: true,
                data: text,
                styleSheet: MarkdownStyleSheet(p: TextStyle(color: Colors.black, fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderNotLoaded(BuildContext context, SettingsPlantAlertsBlocStateNotLoaded state) {
    if (state.hasController == false) {
      return _renderNoDevice(context, state);
    } else if (state.isSync == false) {
      if (state.isLoggedIn == false) {
        return _renderNotLoggedIn(context, state);
      }
      return _renderNotSynced(context, state);
    }
    return Fullscreen(
      title: 'Unknown error',
      child: Icon(
        Icons.error,
        color: Colors.red,
      ),
    );
  }

  Widget _renderNoDevice(BuildContext context, SettingsPlantAlertsBlocStateNotLoaded state) {
    return Fullscreen(
      title: 'Alerts require a controller',
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/settings/icon_nocontroller.svg',
            width: 200,
            height: 200,
          ),
          GreenButton(
            title: 'Lab settings',
            onPressed: () {
              BlocProvider.of<MainNavigatorBloc>(context)
                  .add(MainNavigateToSettingsBox(state.box, futureFn: (future) async {
                await future;
                BlocProvider.of<SettingsPlantAlertsBloc>(context).add(SettingsPlantAlertsBlocEventInit());
              }));
            },
          ),
        ],
      ),
    );
  }

  Widget _renderNotSynced(BuildContext context, SettingsPlantAlertsBlocStateNotLoaded state) {
    return FullscreenLoading(
      title: 'Waiting for controller to sync with backend..',
    );
  }

  Widget _renderNotLoggedIn(BuildContext context, SettingsPlantAlertsBlocStateNotLoaded state) {
    return Fullscreen(
      title: 'Please login to set your alerts.',
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/settings/icon_account.svg',
            width: 200,
            height: 200,
          ),
          GreenButton(
            title: 'Login/create account',
            onPressed: () {
              BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSettingsAuth(futureFn: (future) async {
                await future;
                BlocProvider.of<SettingsPlantAlertsBloc>(context).add(SettingsPlantAlertsBlocEventInit());
              }));
            },
          ),
        ],
      ),
    );
  }

  double _tempUnit(double temp) {
    if (AppDB().getAppData().freedomUnits == true) {
      return temp * 9 / 5 + 32;
    }
    return temp;
  }
}
