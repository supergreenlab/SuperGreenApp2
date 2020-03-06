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
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_schedule/form/feed_schedule_form_bloc.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_layout.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_param_layout.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';

class FeedScheduleFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<FeedScheduleFormBloc>(context),
      listener: (BuildContext context, FeedScheduleFormBlocState state) {
        if (state is FeedScheduleFormBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop(mustPop: true));
        }
      },
      child: BlocBuilder<FeedScheduleFormBloc, FeedScheduleFormBlocState>(
          bloc: BlocProvider.of<FeedScheduleFormBloc>(context),
          builder: (BuildContext context, FeedScheduleFormBlocState state) {
            Widget body;
            if (state is FeedScheduleFormBlocStateUnInitialized) {
              body = FullscreenLoading(
                title: 'Loading..',
              );
            } else {
              body = FeedFormLayout(
                title: 'Add schedule',
                changed: state.schedule != state.initialSchedule,
                valid: state.schedule != state.initialSchedule,
                onOK: () => BlocProvider.of<FeedScheduleFormBloc>(context)
                    .add(FeedScheduleFormBlocEventCreate()),
                body: _renderSchedules(context, state),
              );
            }
            return AnimatedSwitcher(
              child: body,
              duration: Duration(milliseconds: 200),
            );
          }),
    );
  }

  Widget _renderSchedules(
      BuildContext context, FeedScheduleFormBlocState state) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(children: [
            this._renderSchedule(
                context,
                state.schedules['VEG'],
                'Vegetative schedule',
                'assets/feed_form/icon_veg.svg',
                SGLLocalizations.of(context).instructionsVegScheduleHelper,
                state.schedule == 'VEG', () {
              BlocProvider.of<FeedScheduleFormBloc>(context)
                  .add(FeedScheduleFormBlocEventSetSchedule('VEG'));
            }),
            this._renderSchedule(
                context,
                state.schedules['BLOOM'],
                'Blooming schedule',
                'assets/feed_form/icon_bloom.svg',
                SGLLocalizations.of(context).instructionsBloomScheduleHelper,
                state.schedule == 'BLOOM', () {
              BlocProvider.of<FeedScheduleFormBloc>(context)
                  .add(FeedScheduleFormBlocEventSetSchedule('BLOOM'));
            }),
            this._renderSchedule(
                context,
                state.schedules['AUTO'],
                'Auto flower schedule',
                'assets/feed_form/icon_autoflower.svg',
                SGLLocalizations.of(context).instructionsAutoScheduleHelper,
                state.schedule == 'AUTO', () {
              BlocProvider.of<FeedScheduleFormBloc>(context)
                  .add(FeedScheduleFormBlocEventSetSchedule('AUTO'));
            }),
          ]),
        ),
      ],
    );
  }

  Widget _renderSchedule(
      BuildContext context,
      Map<String, dynamic> schedule,
      String title,
      String icon,
      String helper,
      bool selected,
      Function onPressed) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: FeedFormParamLayout(
        title: title,
        icon: icon,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(helper),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: <Widget>[
                      ButtonTheme(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 4.0),
                          minWidth: 0,
                          height: 0,
                          child: RaisedButton(
                            elevation: 0,
                            color: Colors.transparent,
                            child: Icon(Icons.settings),
                            onPressed: () {},
                          )),
                      _renderScheduleTimes(context, schedule),
                    ],
                  ),
                  GreenButton(
                    title: selected ? 'SELECTED' : 'SELECT',
                    onPressed: onPressed,
                    color: selected ? 0xff3bb30b : 0xff777777,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderScheduleTimes(
      BuildContext context, Map<String, dynamic> schedule) {
    final pad = (s) => s.toString().padLeft(2, '0');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('ON: '),
            Text('${pad(schedule['ON_HOUR'])}:${pad(schedule['ON_MIN'])}',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Row(
          children: <Widget>[
            Text('OFF: '),
            Text('${pad(schedule['OFF_HOUR'])}:${pad(schedule['OFF_MIN'])}',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
