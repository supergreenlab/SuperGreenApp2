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
import 'package:super_green_app/pages/checklist/create/widgets/checklist_metric_key.dart';
import 'package:super_green_app/widgets/checkbox_label.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_textarea.dart';

class MetricConditionPage extends StatefulWidget {
  final ChecklistConditionMetric condition;

  final void Function(ChecklistCondition) onUpdate;
  final void Function()? onClose;
  final bool hideTitle;

  const MetricConditionPage(
      {Key? key, this.onClose, required this.condition, required this.onUpdate, this.hideTitle = false})
      : super(key: key);

  @override
  State<MetricConditionPage> createState() => _MetricConditionPageState();
}

class _MetricConditionPageState extends State<MetricConditionPage> {
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  @override
  void initState() {
    _minController.text = widget.condition.min == null ? '' : widget.condition.min.toString();
    _maxController.text = widget.condition.max == null ? '' : widget.condition.max.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CreateChecklistSection(
      hideTitle: widget.hideTitle,
      icon: SvgPicture.asset('assets/checklist/icon_monitoring.svg'),
      onClose: this.widget.onClose,
      title: 'Metric monitoring',
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
        ChecklistMetricKey(
          metricKey: widget.condition.key,
          onChange: (String type) {
            widget.onUpdate(widget.condition.copyWith(
              key: type,
            ));
          },
        ),
      ],
    );
  }

  Widget _renderCheckboxes(BuildContext context) {
    return Column(
      children: [
        CheckboxLabel(
            text: 'Trigger this condition when the temperature is OUT of this range.',
            onChanged: (p0) => widget.onUpdate(widget.condition.copyWith(
                  inRange: !(p0!),
                )),
            value: !(widget.condition.inRange)),
        CheckboxLabel(
            text: 'Trigger this condition when the temperature is IN this range.',
            onChanged: (p0) => widget.onUpdate(widget.condition.copyWith(
                  inRange: p0!,
                )),
            value: widget.condition.inRange),
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
                    keyboardType: TextInputType.number,
                    placeholder: '(Optional)',
                    soloLine: true,
                    noPadding: true,
                    textEditingController: _minController,
                    onChanged: (value) {
                      widget.onUpdate(widget.condition.copyWith(
                        min: double.parse(value),
                      ));
                    },
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
                    keyboardType: TextInputType.number,
                    placeholder: '(Optional)',
                    soloLine: true,
                    noPadding: true,
                    textEditingController: _maxController,
                    onChanged: (value) {
                      widget.onUpdate(widget.condition.copyWith(
                        max: double.parse(value),
                      ));
                    },
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('For how long?'),
      ChecklistDuration(
        duration: widget.condition.duration,
        unit: widget.condition.durationUnit,
        onUpdate: (int? duration, String? unit) {
          widget.onUpdate(widget.condition.copyWith(
            duration: duration,
            durationUnit: unit,
          ));
        },
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: CheckboxLabel(
          text: 'This should repeat multiple days in a row.',
          value: widget.condition.daysInRow,
          onChanged: (newValue) {
            widget.onUpdate(widget.condition.copyWith(
              daysInRow: newValue,
            ));
          },
        ),
      ),
      !widget.condition.daysInRow
          ? Container()
          : Row(
              children: [
                Expanded(
                  child: ChecklistDuration(
                    hideUnit: true,
                    duration: widget.condition.nDaysInRow,
                    unit: 'DAYS',
                    onUpdate: (int? duration, String? unit) {
                      widget.onUpdate(widget.condition.copyWith(
                        nDaysInRow: duration,
                      ));
                    },
                  ),
                ),
                Expanded(child: Text('Days')),
              ],
            ),
    ]);
  }
}
