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

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/pages/checklist/create/create_checklist_section.dart';
import 'package:super_green_app/widgets/checkbox_label.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_textarea.dart';

class MetricConditionPage extends StatefulWidget {

  final void Function() onClose;

  const MetricConditionPage({Key? key, required this.onClose}) : super(key: key);

  @override
  State<MetricConditionPage> createState() => _MetricConditionPageState();
}

class _MetricConditionPageState extends State<MetricConditionPage> {
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CreateChecklistSection(
      onClose: this.widget.onClose,
      title: 'Metric condition',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _renderMetrics(context),
            _renderCheckboxes(context),
            _renderMinMax(context),
            _renderDuration(context),
          ],
        ),
      ),
    );
  }

  Widget _renderMetrics(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Monitored metric:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        DropdownButton<int>(
          value: 0,
          onChanged: (int? value) {},
          items: [
            DropdownMenuItem(
              value: 0,
              child: Row(
                children: [
                  SvgPicture.asset('assets/feed_card/icon_media.svg'),
                  Text('Temperature'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _renderCheckboxes(BuildContext context) {
    return Column(
      children: [
        CheckboxLabel(
            text: 'Trigger this condition when the temperature is OUT of this range.',
            onChanged: (p0) => null,
            value: true),
        CheckboxLabel(
            text: 'Trigger this condition when the temperature is IN this range.',
            onChanged: (p0) => null,
            value: false),
      ],
    );
  }

  Widget _renderMinMax(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Minimum value:'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FeedFormTextarea(
                    placeholder: '(Optional)',
                    soloLine: true,
                    noPadding: true,
                    textEditingController: _minController,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Maximum value:'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FeedFormTextarea(
                    placeholder: '(Optional)',
                    soloLine: true,
                    noPadding: true,
                    textEditingController: _minController,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderDuration(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('For how long?'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: FeedFormTextarea(
                  placeholder: '(Optional)',
                  soloLine: true,
                  noPadding: true,
                  textEditingController: _minController,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: DropdownButton<int>(
                    value: 0,
                    onChanged: (int? value) {},
                    items: [
                      DropdownMenuItem(
                        value: 0,
                        child: Text('Days'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
