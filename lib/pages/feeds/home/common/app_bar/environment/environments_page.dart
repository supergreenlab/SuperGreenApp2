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
import 'package:intl/intl.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/widgets/app_bar_missing_controller.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/widgets/app_bar_title.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/environment/graphs/box_app_bar_metrics_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/environment/graphs/box_app_bar_metrics_page.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/widgets/app_bar_tab.dart';

class EnvironmentsPage extends StatelessWidget {
  static String get environmentsPageControlTitle {
    return Intl.message(
      'Environment control',
      name: 'environmentsPageControlTitle',
      desc: 'Title displayed above the environment control buttons',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get environmentsPageLight {
    return Intl.message(
      'Light',
      name: 'environmentsPageLight',
      desc: 'Label for the light dimming control page button',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get environmentsPageVentilation {
    return Intl.message(
      'Ventil',
      name: 'environmentsPageVentilation',
      desc: 'Label for the ventilation control page button',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get environmentsPageSchedule {
    return Intl.message(
      'Schedule',
      name: 'environmentsPageSchedule',
      desc: 'Label for the schedule control page button',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get environmentsPageAlerts {
    return Intl.message(
      'Alerts',
      name: 'environmentsPageAlerts',
      desc: 'Label for the alert control page button',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  final Box box;
  final Plant? plant;
  final void Function(Future<dynamic>?)? futureFn;

  const EnvironmentsPage(this.box, {Key? key, this.futureFn, this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget graphBody;
    if (box.device != null) {
      graphBody = _renderGraphs(context);
    } else {
      graphBody = Stack(children: [
        _renderGraphs(context),
        AppBarMissingController(this.box),
      ]);
    }

    return AppBarTab(
        child: AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: Column(
              children: [
                AppBarTitle(title: 'Graphs', showDate: false),
                Expanded(child: graphBody),
              ],
            )));
  }

  Widget _renderGraphs(BuildContext context) {
    return BlocProvider<BoxAppBarMetricsBloc>(
      create: (context) => BoxAppBarMetricsBloc(box: box),
      child: BoxAppBarMetricsPage(),
    );
  }
}
