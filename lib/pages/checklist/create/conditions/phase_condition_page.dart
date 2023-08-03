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
import 'package:super_green_app/pages/checklist/create/widgets/checklist_phase.dart';

class PhaseConditionPage extends StatelessWidget {

  final ChecklistConditionAfterPhase condition;

  final void Function(ChecklistCondition) onUpdate;
  final void Function() onClose;

  const PhaseConditionPage({Key? key, required this.onClose, required this.condition, required this.onUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CreateChecklistSection(
      icon: SvgPicture.asset('assets/checklist/icon_phase.svg'),
      onClose: onClose,
      title: 'When the plant reaches a phase',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          _renderCardType(context),
          _renderDuration(context),
        ]),
      ),
    );
  }

  Widget _renderCardType(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text('When plant is:', style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        ChecklistPhase(
          phase: condition.phase,
          onChange: (String phase) {
            onUpdate(condition.copyWith(phase: phase));
          },
        ),
      ],
    );
  }

  Widget _renderDuration(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('After:'),
      ChecklistDuration(
        duration: condition.duration,
        unit: condition.durationUnit,
        onUpdate: (int? duration, String? unit) {
          onUpdate(condition.copyWith(
            duration: duration,
            durationUnit: unit,
          ));
        },
      ),
    ]);
  }
}
