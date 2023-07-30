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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_green_app/data/rel/checklist/actions.dart';
import 'package:super_green_app/data/rel/checklist/conditions.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class ChecklistItemPage extends StatelessWidget {
  final Function() onSelect;
  final ChecklistSeed checklistSeed;

  late final List<ChecklistCondition> conditions;
  late final List<ChecklistAction> actions;

  ChecklistItemPage({Key? key, required this.checklistSeed, required this.onSelect}) : super(key: key) {
    conditions = ChecklistCondition.fromMapArray(json.decode(checklistSeed.conditions));
    actions = ChecklistAction.fromMapArray(json.decode(checklistSeed.actions));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              spreadRadius: 1.0,
              blurRadius: 2.0,
              offset: Offset(2, 3),
            )
          ],
        ),
        child: Column(
          children: [
            renderHeader(context),
            renderBody(context),
          ],
        ),
      ),
    );
  }

  Widget renderHeader(BuildContext context) {
    return Container(
      height: 65.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/checklist/icon_monitoring.svg'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(checklistSeed.title),
                  Text('PARASITS CHECK'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Conditions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ...conditions.map((c) {
          return Text(c.asSentence);
        }).toList(),
        Text(
          'Actions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ...actions.map((a) {
          return Text(a.asSentence);
        }),
      ],
    );
  }
}
