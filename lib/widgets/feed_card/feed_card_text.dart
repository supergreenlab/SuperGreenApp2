/*
 * Copyright (C) 2018  SuperGreenLab <towelie@supergreenlab.com>
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
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:super_green_app/widgets/green_button.dart';

class FeedCardText extends StatefulWidget {
  final String text;
  final Function(String) onEdited;
  final bool edit;

  const FeedCardText(this.text, {this.edit = false, this.onEdited});

  @override
  _FeedCardTextState createState() => _FeedCardTextState();
}

class _FeedCardTextState extends State<FeedCardText> {
  TextEditingController _textEditingController;

  @override
  Widget build(BuildContext context) {
    Widget text;
    if (widget.edit != true) {
      if (_textEditingController != null) {
        _textEditingController = null;
      }
      text = MarkdownBody(
        data: widget.text,
        styleSheet: MarkdownStyleSheet(
            strong: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            p: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal)),
      );
    } else {
      if (_textEditingController == null) {
        _textEditingController = TextEditingController(text: widget.text);
      }
      text = Column(
        children: <Widget>[
          TextField(
            autofocus: true,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: _textEditingController,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GreenButton(
                title: 'OK',
                onPressed: () {
                  setState(() {
                    widget.onEdited(_textEditingController.value.text);
                  });
                },
              ),
            ),
          )
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0, bottom: 8.0),
      child: text,
    );
  }
}
