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
import 'package:super_green_app/data/rel/checklist/actions.dart';
import 'package:super_green_app/pages/checklist/create/create_checklist_section.dart';
import 'package:super_green_app/pages/checklist/create/widgets/checklist_card_type.dart';

class DiaryActionPage extends StatelessWidget {

  final ChecklistActionCreateCard action;

  final void Function(ChecklistAction) onUpdate;
  final void Function() onClose;

  const DiaryActionPage({Key? key, required this.onClose, required this.action, required this.onUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CreateChecklistSection(
      onClose: onClose,
      title: 'Create diary card',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _renderCardTypes(context),
      ),
    );
  }

  Widget _renderCardTypes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ChecklistCardType(onChange: (String entryType) {
          onUpdate(action.copyWith(entryType: entryType));
        }, cardType: action.entryType,),
      ],
    );
  }
}
