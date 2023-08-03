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
import 'package:super_green_app/data/rel/checklist/conditions.dart';
import 'package:super_green_app/pages/checklist/create/create_checklist_section.dart';
import 'package:super_green_app/pages/checklist/create/widgets/checklist_duration.dart';
import 'package:super_green_app/widgets/checkbox_label.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_date_picker.dart';

class TimerConditionPage extends StatelessWidget {
  final ChecklistConditionTimer condition;

  final void Function(ChecklistCondition) onUpdate;
  final void Function()? onClose;
  final bool hideTitle;
  final bool noBorder;

  const TimerConditionPage(
      {Key? key,
      this.onClose,
      required this.condition,
      required this.onUpdate,
      this.hideTitle = false,
      this.noBorder = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CreateChecklistSection(
      hideTitle: hideTitle,
      noBorder: noBorder,
      icon: SvgPicture.asset('assets/checklist/icon_reminder.svg'),
      onClose: onClose,
      title: 'At a given time',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _renderDate(context),
        ]),
      ),
    );
  }

  Widget _renderDate(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FeedFormDatePicker(
          condition.date ?? DateTime.now(),
          onChange: (DateTime? newDate) {
            onUpdate(condition.copyWith(date: newDate));
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CheckboxLabel(
            text: 'Repeat timer',
            onChanged: (p0) => onUpdate(condition.copyWith(
              repeat: p0!,
            )),
            value: condition.repeat,
          ),
        ),
        condition.repeat ? _renderDuration(context) : Container(),
      ],
    );
  }

  Widget _renderDuration(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('Enter the repeat period:'),
        ChecklistDuration(
          duration: condition.repeatDuration,
          unit: condition.durationUnit,
          onUpdate: (int? duration, String? unit) {
            onUpdate(condition.copyWith(
              repeatDuration: duration,
              durationUnit: unit,
            ));
          },
        ),
      ]),
    );
  }
}
