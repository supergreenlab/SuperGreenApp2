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
import 'package:super_green_app/widgets/feed_form/feed_form_textarea.dart';

class WebpageActionPage extends StatefulWidget {
  final void Function() onClose;

  const WebpageActionPage({Key? key, required this.onClose}) : super(key: key);

  @override
  State<WebpageActionPage> createState() => _WebpageActionPageState();
}

class _WebpageActionPageState extends State<WebpageActionPage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CreateChecklistSection(
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
            textEditingController: controller,
          ),
        ),
      ],
    );
  }
}
