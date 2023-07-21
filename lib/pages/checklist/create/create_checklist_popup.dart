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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/pages/checklist/create/create_checklist_section.dart';

abstract class CreateChecklistPopup extends StatelessWidget {

  final String title;
  final Function() onClose;

  const CreateChecklistPopup({Key? key, required this.onClose, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          left: 0,
          child: InkWell(
            onTap: onClose,
            child: Container(
              color: Color(0x45454545),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CreateChecklistSection(
                title: title,
                child: renderConditions(context),
                onClose: onClose,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget renderConditions(BuildContext context);

  Widget renderCondition(BuildContext context, String icon, String title, String description, String expample) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5)),
          border: Border(
            top: BorderSide(color: Color(0xFFdedede)),
            left: BorderSide(color: Color(0xFFdedede)),
            right: BorderSide(color: Color(0xFFdedede)),
            bottom: BorderSide(color: Color(0xFFdedede)),
          ),
        ),
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0, bottom: 8.0, right: 16),
                  child: SvgPicture.asset(icon),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(description),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          expample,
                          style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
