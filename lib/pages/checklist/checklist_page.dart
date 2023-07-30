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
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/checklist/actions.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/checklist/checklist_bloc.dart';
import 'package:super_green_app/pages/checklist/create/create_checklist_section.dart';
import 'package:super_green_app/pages/checklist/items/checklist_item_page.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/app_bar/checklist/actions/checklist_action_page.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:tuple/tuple.dart';

class ChecklistPage extends TraceableStatefulWidget {
  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  bool showAutoChecklist = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChecklistBloc, ChecklistBlocState>(
      listener: (BuildContext context, ChecklistBlocState state) {
        if (state is ChecklistBlocStateLoaded) {
          setState(() {
            showAutoChecklist = !AppDB().isCloseAutoChecklist(state.checklist.id);
          });
        }
      },
      child: BlocBuilder<ChecklistBloc, ChecklistBlocState>(
          bloc: BlocProvider.of<ChecklistBloc>(context),
          builder: (context, state) {
            Widget body = FullscreenLoading(
              title: 'Loading..',
            );
            if (state is ChecklistBlocStateInit) {
              body = FullscreenLoading();
            } else if (state is ChecklistBlocStateLoaded) {
              if (state.checklistSeeds.length != 0) {
                body = _renderLoaded(context, state);
              } else {
                body = _renderEmpty(context, state);
              }
            }
            return Scaffold(
              backgroundColor: Color(0xffEDEDED),
              appBar: SGLAppBar(
                '🦜',
                backgroundColor: Colors.deepPurple,
                titleColor: Colors.yellow,
                iconColor: Colors.white,
                actions: state is ChecklistBlocStateLoaded
                    ? [
                        IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            BlocProvider.of<MainNavigatorBloc>(context)
                                .add(MainNavigateToCreateChecklist(state.checklist));
                          },
                        ),
                      ]
                    : [],
              ),
              body: body,
            );
          }),
    );
  }

  Widget _renderEmpty(BuildContext context, ChecklistBlocStateLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _renderAutoChecklistPopulate(context, state),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Your checklist is empty.\n\nPress the button below to start using it.",
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18, color: Color(0xff454545)),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: GreenButton(
                  title: 'Create new item',
                  onPressed: () {
                    BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToCreateChecklist(state.checklist));
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _renderLoaded(BuildContext context, ChecklistBlocStateLoaded state) {
    return ListView(
      children: [
        _renderAutoChecklistPopulate(context, state),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0,),
          child: CreateChecklistSection(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 16.0,
                  ),
                  child:
                      Text('Today\'s Actions', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff454545))),
                ),
                ...state.actions!.map((Tuple2<ChecklistSeed, ChecklistAction> action) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ChecklistActionPage(plant: state.plant, checklistSeed: action.item1, checklistAction: action.item2),
                  );
                }).toList(),
                Container(height: 10.0,),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 16.0,
                  ),
                  child:
                      Text('Future items', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff454545))),
                ),
                ...state.checklistSeeds.map((cks) {
                  return ChecklistItemPage(
                    checklistSeed: cks,
                    onSelect: () {
                      BlocProvider.of<MainNavigatorBloc>(context)
                          .add(MainNavigateToCreateChecklist(state.checklist, checklistSeed: cks));
                    },
                  );
                }).toList(),
                Container(height: 30.0,),
              ]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderAutoChecklistPopulate(BuildContext context, ChecklistBlocStateLoaded state) {
    if (!showAutoChecklist) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CreateChecklistSection(
        title: 'Auto checklist',
        onClose: () {
          setState(() {
            this.showAutoChecklist = false;
            AppDB().setCloseAutoChecklist(state.checklist.id);
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(width: 24, height: 32, child: Checkbox(value: false, onChanged: (bool? value) {})),
                  ),
                  Text('Activate auto checklist?',
                      style: TextStyle(
                        color: Color(0xff454545),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 32.0,
                  bottom: 12,
                  right: 8,
                  top: 8,
                ),
                child: Text(
                    'If checked, your checklist will be automatically populated with common checklist items based on your plant stage, diary items, environment etc.. Can be changed later in the settings.',
                    style: TextStyle(color: Color(0xff454545))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
