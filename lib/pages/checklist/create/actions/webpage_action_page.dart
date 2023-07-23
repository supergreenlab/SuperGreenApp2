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
import 'package:super_green_app/widgets/feed_form/feed_form_textarea.dart';

class WebpageActionPage extends StatefulWidget {

  final ChecklistActionWebpage action;

  final void Function(ChecklistAction) onUpdate;
  final void Function() onClose;

  WebpageActionPage({Key? key, required this.onClose, required this.action, required this.onUpdate}) : super(key: key);

  @override
  State<WebpageActionPage> createState() => _WebpageActionPageState();
}

class _WebpageActionPageState extends State<WebpageActionPage> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();

  @override
  void initState() {
    _urlController.text = widget.action.url ?? '';
    _instructionController.text = widget.action.instructions ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CreateChecklistSection(
      icon: SvgPicture.asset('assets/checklist/icon_webpage.svg'),
      onClose: widget.onClose,
      title: 'Open web page',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _renderURLField(context),
      ),
    );
  }

  Widget _renderURLField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Enter URL of webpage to open:'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FeedFormTextarea(
            placeholder: 'https://...',
            soloLine: true,
            noPadding: true,
            textEditingController: _urlController,
            onChanged: (value) {
              widget.onUpdate(widget.action.copyWith(
                url: value,
              ));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xff6A6A6A)),
          ),
        ),
        SizedBox(
          height: 150,
          child: FeedFormTextarea(
            placeholder: 'ex: When the temperature gets too high, some fungus might develop on your leaves.',
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
