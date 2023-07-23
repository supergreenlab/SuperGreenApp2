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
import 'package:super_green_app/data/rel/checklist/actions.dart';
import 'package:super_green_app/pages/checklist/create/create_checklist_section.dart';
import 'package:super_green_app/pages/checklist/create/widgets/checklist_card_type.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_textarea.dart';

class DiaryActionPage extends StatefulWidget {
  final ChecklistActionCreateCard action;

  final void Function(ChecklistAction) onUpdate;
  final void Function() onClose;

  DiaryActionPage({Key? key, required this.onClose, required this.action, required this.onUpdate})
      : super(key: key);

  @override
  State<DiaryActionPage> createState() => _DiaryActionPageState();
}

class _DiaryActionPageState extends State<DiaryActionPage> {
  final TextEditingController _instructionController = TextEditingController();

  @override
  void initState() {
    _instructionController.text = widget.action.instructions ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CreateChecklistSection(
      icon: SvgPicture.asset('assets/checklist/icon_create_diary.svg'),
      onClose: widget.onClose,
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
        ChecklistCardType(
          onChange: (String entryType) {
            widget.onUpdate(widget.action.copyWith(entryType: entryType));
          },
          cardType: widget.action.entryType,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Instructions',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xff6A6A6A)),
          ),
        ),
        SizedBox(
          height: 150,
          child: FeedFormTextarea(
            placeholder: 'ex: Check the leaves for small white dots. Make sure to check both sides of the leaf. Getting a macro lens will help.',
            noPadding: true,
            textEditingController: _instructionController,
            onChanged: (value) {
              widget.onUpdate(widget.action.copyWith(instructions: _instructionController.text));
            },
          ),
        ),
      ],
    );
  }
}
