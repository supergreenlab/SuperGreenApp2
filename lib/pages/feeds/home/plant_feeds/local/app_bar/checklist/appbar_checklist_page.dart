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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/data/rel/checklist/actions.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/app_bar/checklist/actions/checklist_action_page.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/app_bar/checklist/appbar_checklist_bloc.dart';
import 'package:super_green_app/syncer/syncer_bloc.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:tuple/tuple.dart';

class AppbarChecklistPage extends StatefulWidget {
  @override
  _AppbarChecklistPageState createState() => _AppbarChecklistPageState();
}

class _AppbarChecklistPageState extends State<AppbarChecklistPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AppbarChecklistBloc, AppbarChecklistBlocState>(
      listener: (BuildContext context, AppbarChecklistBlocState state) {
        if (state is AppbarChecklistBlocStateCreated) {
          BlocProvider.of<SyncerBloc>(context)
              .add(SyncerBlocEventForceSyncChecklists());
          BlocProvider.of<MainNavigatorBloc>(context).add(
              MainNavigateToChecklist(state.plant, state.box, state.checklist));
        }
      },
      child: BlocBuilder<AppbarChecklistBloc, AppbarChecklistBlocState>(
          bloc: BlocProvider.of<AppbarChecklistBloc>(context),
          builder: (context, state) {
            Widget body = FullscreenLoading(
              title: 'Loading..',
            );
            if (state is AppbarChecklistBlocStateInit) {
              body = FullscreenLoading();
            } else if (state is AppbarChecklistBlocStateLoaded) {
              if (state.checklist == null) {
                body = _renderCreateChecklist(context, state);
              } else if (state.actions!.length == 0) {
                body = _renderEmpty(context, state);
              } else {
                body = _renderLoaded(context, state);
              }
            }
            return body;
          }),
    );
  }

  Widget _renderEmpty(
      BuildContext context, AppbarChecklistBlocStateLoaded state) {
    return Column(
      children: [
        _checklistButton(context, state),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Nothing for today. 👌",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18,
                    color: Color(0xff454545)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _renderCreateChecklist(
      BuildContext context, AppbarChecklistBlocStateLoaded state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Your checklist is empty.\n\nPress the button below to start using it.",
          style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 18,
              color: Color(0xff454545)),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: GreenButton(
            title: 'Create checklist',
            onPressed: () {
              if (state.requiresLogin) {
                _login(context);
              } else {
                BlocProvider.of<AppbarChecklistBloc>(context)
                    .add(AppbarChecklistBlocEventCreate());
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _renderLoaded(
      BuildContext context, AppbarChecklistBlocStateLoaded state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: _checklistButton(context, state),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: state.actions!.map<Widget>(
                  (Tuple3<ChecklistSeed, ChecklistAction, ChecklistLog>
                      action) {
                int index = state.actions!.indexOf(action);
                return Padding(
                  padding: index == 0
                      ? EdgeInsets.zero
                      : const EdgeInsets.only(top: 9.0),
                  child: ChecklistActionButton.getActionPage(
                      plant: state.plant,
                      box: state.box,
                      checklistSeed: action.item1,
                      checklistAction: action.item2,
                      summarize: true,
                      onCheck: () {
                        BlocProvider.of<AppbarChecklistBloc>(context).add(
                            AppbarChecklistBlocEventCheckChecklistLog(
                                action.item3));
                      },
                      onSkip: () {
                        BlocProvider.of<AppbarChecklistBloc>(context).add(
                            AppbarChecklistBlocEventSkipChecklistLog(
                                action.item3));
                      }),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _checklistButton(
      BuildContext context, AppbarChecklistBlocStateLoaded state) {
    return InkWell(
      onTap: () {
        BlocProvider.of<MainNavigatorBloc>(context).add(
            MainNavigateToChecklist(state.plant, state.box, state.checklist!));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SvgPicture.asset('assets/checklist/icon_checklist.svg'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 10.0, right: 8.0),
            child: Text('OPEN CHECKLIST (${state.nPendingLogs})',
                style: TextStyle(
                    color: Color(0xff3bb30b),
                    decoration: TextDecoration.underline)),
          ),
        ],
      ),
    );
  }

  void _login(BuildContext context) async {
    bool? confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog.adaptive(
            title: Text('Please login'),
            content: Text(
                'The checklist feature requires a SGL account to work for you when you\'re not there:)'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(CommonL10N.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(CommonL10N.loginCreateAccount),
              ),
            ],
          );
        });
    if (confirm ?? false) {
      BlocProvider.of<MainNavigatorBloc>(context)
          .add(MainNavigateToSettingsAuth(futureFn: (future) async {
        bool done = await future;
        if (done == true) {
          BlocProvider.of<AppbarChecklistBloc>(context)
              .add(AppbarChecklistBlocEventInit());
          BlocProvider.of<AppbarChecklistBloc>(context)
              .add(AppbarChecklistBlocEventCreate());
        }
      }));
    }
  }
}
