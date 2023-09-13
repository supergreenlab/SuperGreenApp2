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
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/checklist/actions.dart';
import 'package:super_green_app/data/rel/checklist/categories.dart';
import 'package:super_green_app/pages/checklist/action_popup/checklist_action_popup_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/app_bar/checklist/actions/checklist_action_page.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class ChecklistActionPopupPage extends StatefulWidget {
  @override
  State<ChecklistActionPopupPage> createState() => _ChecklistActionPopupPageState();
}

class _ChecklistActionPopupPageState extends State<ChecklistActionPopupPage> {
  bool noRepeat = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChecklistActionPopupBloc, ChecklistActionPopupBlocState>(
      listener: (BuildContext context, ChecklistActionPopupBlocState state) => {
        if (state is ChecklistActionPopupBlocStateLoaded) {
          setState(() {
            noRepeat = AppDB().isNoRepeatChecklistSeed(state.checklistSeed.id);
          })
        }
      },
      child: BlocBuilder<ChecklistActionPopupBloc, ChecklistActionPopupBlocState>(
        builder: (BuildContext context, ChecklistActionPopupBlocState state) {
          if (state is ChecklistActionPopupBlocStateInit) {
            return InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: FullscreenLoading(),
            );
          }
    
          return Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 20, left: 12, right: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: _renderBody(context, state as ChecklistActionPopupBlocStateLoaded),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _renderBody(BuildContext context, ChecklistActionPopupBlocStateLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _renderTitle(context, state),
        Expanded(child: _renderChecklistSeed(context, state)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Actions (${state.checklistLogs.length})",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff454545)),
          ),
        ),
        _renderRepeat(context, state),
        _renderActions(context, state),
      ],
    );
  }

  Widget _renderRepeat(BuildContext context, ChecklistActionPopupBlocStateLoaded state) {
    if (!state.checklistSeed.repeat) {
      return Container();
    }
    return InkWell(
      onTap: () {
        setState(() {
          noRepeat = !noRepeat;
        });
        AppDB().setNoRepeatChecklistSeed(state.checklistSeed.id, noRepeat);
      },
      child: Row(
        children: [
          Checkbox(value: noRepeat, onChanged: (bool? v) {}),
          Text("Ok don't show this checklist again."),
        ],
      ),
    );
  }

  Widget _renderTitle(BuildContext context, ChecklistActionPopupBlocStateLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: SvgPicture.asset(
                    ChecklistCategoryIcons[state.checklistSeed.category]!,
                    width: 20,
                  ),
                ),
                Expanded(
                  child: Text(
                    state.checklistSeed.title,
                    maxLines: 3,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff454545)),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8.0),
              child: Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderChecklistSeed(BuildContext context, ChecklistActionPopupBlocStateLoaded state) {
    if (state.checklistSeed.description.length == 0) {
      return Container();
    }
    double height = MediaQuery.of(context).size.height * 0.35;
    if (state.checklistLogs.length == 1) {
      height = height * 0.6;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: SingleChildScrollView(
        child: MarkdownBody(
          data: state.checklistSeed.description,
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(color: Color(0xff454545), fontSize: 14),
            h1: TextStyle(color: Color(0xff454545), fontSize: 16, fontWeight: FontWeight.bold),
            h2: TextStyle(color: Color(0xff454545), fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _renderActions(BuildContext context, ChecklistActionPopupBlocStateLoaded state) {
    double height = MediaQuery.of(context).size.height * 0.25;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: height),
        child: SingleChildScrollView(
          child: Column(
            children: state.checklistLogs.map<Widget>((log) {
              ChecklistAction action = ChecklistAction.fromJSON(log.action);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChecklistActionButton.getActionPage(
                    plant: state.plant,
                    box: state.box,
                    checklistSeed: state.checklistSeed,
                    checklistAction: action,
                    summarize: false,
                    onCheck: () {
                      BlocProvider.of<ChecklistActionPopupBloc>(context)
                          .add(ChecklistActionPopupBlocEventCheckChecklistLog(log.copyWith(noRepeat: noRepeat)));
                      if (state.checklistLogs.length == 1) {
                        Navigator.pop(context);
                      }
                    },
                    onSkip: () {
                      BlocProvider.of<ChecklistActionPopupBloc>(context)
                          .add(ChecklistActionPopupBlocEventSkipChecklistLog(log));
                      if (state.checklistLogs.length == 1) {
                        Navigator.pop(context);
                      }
                    }),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
