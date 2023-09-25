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
import 'package:flutter_svg/svg.dart';
import 'package:super_green_app/data/assets/checklist.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/checklist/action_popup/checklist_action_popup_bloc.dart';
import 'package:super_green_app/pages/checklist/action_popup/checklist_action_popup_page.dart';

class ChecklistItemPage extends StatelessWidget {
  final Function()? onSelect;
  final Function()? onDelete;
  final Plant plant;
  final Box box;
  final ChecklistSeed checklistSeed;
  final ChecklistCollection? collection;

  ChecklistItemPage(
      {Key? key,
      required this.plant,
      required this.box,
      required this.checklistSeed,
      required this.onSelect,
      required this.onDelete,
      required this.collection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext c) {
            return BlocProvider<ChecklistActionPopupBloc>(
              create: (BuildContext context) => ChecklistActionPopupBloc(this.plant, this.box, this.checklistSeed),
              child: ChecklistActionPopupPage(),
            );
          },
        );
      },
      child: Container(
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
                          style: TextStyle(
                            color: checklistSeed.synced ? Color(0xff2D6A14) : Color.fromARGB(255, 150, 40, 58),
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          onDelete == null ? Container() : InkWell(
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
          onSelect == null ? Container() : InkWell(
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
          collection == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    'From collection: ${collection!.title}',
                    style: TextStyle(color: Color(0xff606060), fontWeight: FontWeight.bold),
                  ),
                ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Tap top view details', style: TextStyle(color: Color(0xffababab))),
            ],
          ),
        ],
      ),
    );
  }
}
