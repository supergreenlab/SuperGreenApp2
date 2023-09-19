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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/data/assets/checklist.dart';
import 'package:super_green_app/pages/checklist/collections/checklist_collections_bloc.dart';
import 'package:super_green_app/pages/checklist/create/create_checklist_section.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:collection/collection.dart';

class ChecklistCollectionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChecklistCollectionsBloc, ChecklistCollectionsBlocState>(
      builder: (BuildContext context, ChecklistCollectionsBlocState state) {
        Widget body = FullscreenLoading();
        if (state is ChecklistCollectionsBlocStateLoaded) {
          body = _renderLoaded(context, state);
        }

        return Scaffold(
          backgroundColor: Color(0xffEDEDED),
          appBar: SGLAppBar(
            '🦜',
            backgroundColor: Colors.deepPurple,
            titleColor: Colors.yellow,
            iconColor: Colors.white,
          ),
          body: body,
        );
      },
    );
  }

  Widget _renderLoaded(BuildContext context, ChecklistCollectionsBlocStateLoaded state) {
    return ListView(children: [
      ...state.collections.map<Widget>((c) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0,),
          child: CreateChecklistSection(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: SvgPicture.asset(ChecklistCollectionCategory[c.category.value]!),
                      ),
                      Text(c.title.value, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xff454545)),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: MarkdownBody(
                      data: c.description.value,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(color: Color(0xff454545), fontSize: 12),
                        h1: TextStyle(color: Color(0xff454545), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GreenButton(
                        onPressed: state.checklistCollections.firstWhereOrNull((cc) => cc.serverID == c.serverID.value) != null ? null : () {
                          BlocProvider.of<ChecklistCollectionsBloc>(context).add(ChecklistCollectionsBlocEventAddCollection(c));
                        },
                        title: 'Add collection',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'More to come soon!',
            style: TextStyle(fontSize: 20,),
          ),
        ),
      ),
    ]);
  }
}
