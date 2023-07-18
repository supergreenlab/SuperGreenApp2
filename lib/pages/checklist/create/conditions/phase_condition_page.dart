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
import 'package:super_green_app/pages/checklist/create/create_checklist_section.dart';
import 'package:super_green_app/pages/checklist/create/widgets/checklist_duration.dart';

class PhaseConditionPage extends StatelessWidget {

  final void Function() onClose;

  const PhaseConditionPage({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CreateChecklistSection(
      onClose: onClose,
      title: 'Phase condition',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          _renderCardType(context),
          _renderDuration(context),
        ]),
      ),
    );
  }

  Widget _renderCardType(BuildContext context) {
    return Text('pouet');
  }

  Widget _renderDuration(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('After:'),
      ChecklistDuration(),
    ]);
  }
}
