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
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/pages/checklist/create/actions/diary_action_page.dart';
import 'package:super_green_app/pages/checklist/create/actions/webpage_action_page.dart';
import 'package:super_green_app/pages/checklist/create/conditions/card_condition_page.dart';
import 'package:super_green_app/pages/checklist/create/conditions/metric_condition_page.dart';
import 'package:super_green_app/pages/checklist/create/conditions/phase_condition_page.dart';
import 'package:super_green_app/pages/checklist/create/create_checklist_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_textarea.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class CreateChecklistPage extends TraceableStatefulWidget {
  @override
  _CreateChecklistPageState createState() => _CreateChecklistPageState();
}

class _CreateChecklistPageState extends State<CreateChecklistPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateChecklistBloc, CreateChecklistBlocState>(
      listener: (BuildContext context, CreateChecklistBlocState state) {
        if (state is CreateChecklistBlocStateLoaded) {}
      },
      child: BlocBuilder<CreateChecklistBloc, CreateChecklistBlocState>(
          bloc: BlocProvider.of<CreateChecklistBloc>(context),
          builder: (context, state) {
            Widget body = FullscreenLoading(
              title: 'Loading..',
            );
            if (state is CreateChecklistBlocStateInit) {
              body = FullscreenLoading();
            } else if (state is CreateChecklistBlocStateLoaded) {
              body = _renderLoaded(context, state);
            }
            return Scaffold(
              backgroundColor: Color(0xffededed),
              appBar: SGLAppBar(
                '🦜',
                backgroundColor: Colors.deepPurple,
                titleColor: Colors.yellow,
                iconColor: Colors.white,
              ),
              body: body,
            );
          }),
    );
  }

  Widget _renderLoaded(BuildContext context, CreateChecklistBlocStateLoaded state) {
    return ListView(
      children: [
        Container(
          height: 10,
        ),
        _renderInfos(context, state),
        _renderConditions(context, state),
        _renderActions(context, state),
        Container(
          height: 60,
        ),
      ],
    );
  }

  Widget _renderInfos(BuildContext context, CreateChecklistBlocStateLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Title',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xff6A6A6A)),
                ),
              ),
              FeedFormTextarea(
                noPadding: true,
                textEditingController: _titleController,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xff6A6A6A)),
                ),
              ),
              SizedBox(
                height: 150,
                child: FeedFormTextarea(
                  noPadding: true,
                  textEditingController: _descriptionController,
                ),
              ),
              _renderOptionCheckbx(
                  context,
                  'This checklist entry can repeat. Entries that don\’t repeat will be removed from your checklist when checked.',
                  (p0) => null,
                  false),
              _renderOptionCheckbx(context,
                  'Make this checklist entry public so others can add it to their checklist too.', (p0) => null, true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderConditions(BuildContext context, CreateChecklistBlocStateLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Conditions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xff6A6A6A)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 32,
                ),
                child: MarkdownBody(
                  fitContent: true,
                  shrinkWrap: true,
                  data:
                      'Configure the conditions for this checklist item to show up in your checklist.\n\nIt can be as simple as a classic reminder, or something smarter like “If the temperature reaches a given value”',
                  styleSheet: MarkdownStyleSheet(
                      p: TextStyle(color: Color(0xff636363), fontSize: 14), textAlign: WrapAlignment.center),
                ),
              ),
              MetricConditionPage(),
              CardConditionPage(),
              PhaseConditionPage(),
              _renderAddButton(context, '+ ADD CONDITION'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderActions(BuildContext context, CreateChecklistBlocStateLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Actions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xff6A6A6A)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 32,
                ),
                child: MarkdownBody(
                  fitContent: true,
                  shrinkWrap: true,
                  data:
                      'Here you can set the actions required to complete this checklist item.\n\nActions can be things like “Add watering entry to diary” or “Read this webpage”',
                  styleSheet: MarkdownStyleSheet(
                      p: TextStyle(color: Color(0xff636363), fontSize: 14), textAlign: WrapAlignment.center),
                ),
              ),
              WebpageActionPage(),
              DiaryActionPage(),
              _renderAddButton(context, '+ ADD ACTION'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderOptionCheckbx(BuildContext context, String text, Function(bool?) onChanged, bool value) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        bottom: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SizedBox(
              width: 24,
              height: 32,
              child: Checkbox(
                onChanged: onChanged,
                value: value,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                onChanged(!value);
              },
              child: MarkdownBody(
                fitContent: true,
                shrinkWrap: true,
                data: text,
                styleSheet: MarkdownStyleSheet(p: TextStyle(color: Colors.black, fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderAddButton(BuildContext context, String title) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 50, // Specify your container height
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Color.fromARGB(255, 86, 86, 86),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
