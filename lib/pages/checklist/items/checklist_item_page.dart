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
import 'package:super_green_app/data/rel/checklist/categories.dart';
import 'package:super_green_app/data/rel/checklist/conditions.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class ChecklistItemPage extends StatelessWidget {
  final Function() onSelect;
  final Function() onDelete;
  final ChecklistSeed checklistSeed;

  late final List<ChecklistCondition> conditions;
  late final List<ChecklistAction> actions;

  ChecklistItemPage({Key? key, required this.checklistSeed, required this.onSelect, required this.onDelete})
      : super(key: key) {
    conditions = ChecklistCondition.fromMapArray(json.decode(checklistSeed.conditions));
    actions = ChecklistAction.fromMapArray(json.decode(checklistSeed.actions));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            spreadRadius: 2.0,
            blurRadius: 2.0,
            offset: Offset(1, 1),
          )
        ],
      ),
      child: Column(
        children: [
          renderHeader(context),
          renderBody(context),
        ],
      ),
    );
  }

  Widget renderHeader(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SizedBox(
              width: 32,
              height: 32,
              child: SvgPicture.asset(
                ChecklistCategoryIcons[checklistSeed.category]!,
                width: 32,
                height: 32,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      checklistSeed.title,
                      style: TextStyle(color: Color(0xff506EBA), fontSize: 18),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        checklistSeed.category,
                        style: TextStyle(color: Color(0xff2D6A14)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          checklistSeed.synced ? "Synced" : "Not synced",
                          style: TextStyle(color: checklistSeed.synced ? Color(0xff2D6A14) : Color.fromARGB(255, 150, 40, 58), fontSize: 10,),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          InkWell(
              onTap: onDelete,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 4.0,
                  right: 16.0,
                ),
                child: Icon(
                  Icons.delete,
                  color: Color(0xff606060),
                ),
              )),
          InkWell(
              onTap: onSelect,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 4.0,
                  right: 16.0,
                ),
                child: Icon(
                  Icons.settings,
                  color: Color(0xff606060),
                ),
              )),
        ],
      ),
    );
  }

  Widget renderBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          checklistSeed.description == ''
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(checklistSeed.description),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Conditions',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ...conditions.map((c) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                bottom: 8.0,
              ),
              child: Text((conditions.indexOf(c) != 0 ? 'AND ' : '') + c.asSentence),
            );
          }).toList(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Actions',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ...actions.map((a) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                bottom: 8.0,
              ),
              child: Text((actions.indexOf(a) != 0 ? 'AND ' : '') + a.asSentence),
            );
          }),
        ],
      ),
    );
  }
}
